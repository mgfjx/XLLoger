//
//  XLLogerManager.m
//  XLLogerDemo
//
//  Created by mgfjx on 2021/9/12.
//

#import "XLLogerManager.h"
#import "XLLogerView.h"

#define kEnableKey @"kEnableKey"

@interface XLLogerManager ()

@property (nonatomic, strong) UIWindow *window ;
@property (nonatomic, strong) XLLogerView *logView ;
@property (nonatomic, strong) NSPipe *outputPipe ;

/// temporary log if logView don't create
@property (nonatomic, strong) NSString *temporaryLog ;

@end

@implementation XLLogerManager

static XLLogerManager *singleton = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [super allocWithZone:zone];
        });
    }
    return singleton;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [super init];
        singleton.textColor = [UIColor whiteColor];
        singleton.textSize = 12.0f;
        singleton.autoDestination = YES;
        singleton.temporaryLog = @"";
        id enable = [[NSUserDefaults standardUserDefaults] objectForKey:kEnableKey];
        if (!enable) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEnableKey];
        }
        singleton.enable = [[NSUserDefaults standardUserDefaults] boolForKey:kEnableKey];
    });
    return singleton;
}

- (id)copyWithZone:(NSZone *)zone{
    return singleton;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return singleton;
}

+ (instancetype)manager {
    return [[self alloc] init];
}

- (void)prepare {
    if (!self.enable) {
        return;
    }
    if (self.autoDestination) {
        if (!isatty(STDERR_FILENO)) {
            [self captureStandardOutput];
        }
    } else {
        [self captureStandardOutput];
    }
}

- (void)setEnable:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:kEnableKey];
    _enable = enable;
}

/// add XLLoger View On Root window
- (void)showOnWindow {
    
    if (self.logView) {
        return;
    }
    
    UIWindow *window ;
    if (@available(iOS 13.0, *)) {
        NSSet *sets = [[UIApplication sharedApplication] connectedScenes];
        for (UIScene *scene in sets) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                
            }
        }
        UIScene *scene = sets.anyObject;
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        window = windowScene.windows.firstObject;
    } else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    if (!window) {
        return;
    }
    [self showOnView:window];
}

- (void)showOnView:(UIView *)superView {
    XLLogerView *logView = [[XLLogerView alloc] initWithFrame:CGRectMake(20, 88, 300, 400)];
    logView.defaultLog = self.temporaryLog;
    [superView addSubview:logView];
    self.logView = logView;
    self.temporaryLog = nil;
    
    __weak __typeof(&*self) weakSelf  = self;
    logView.closeCallback = ^{
        if (weakSelf.logView) {
            [weakSelf.logView removeFromSuperview];
            weakSelf.logView = nil;
        }
    };
}

- (void)captureStandardOutput {
    self.outputPipe = [NSPipe pipe];
    dup2(self.outputPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectNotificationHandle:) name:NSFileHandleReadCompletionNotification object:self.outputPipe.fileHandleForReading]; // register notification
    [self.outputPipe.fileHandleForReading readInBackgroundAndNotify];
    
}

- (void)redirectNotificationHandle:(NSNotification *)nf {
    NSData *data = [[nf userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (self.outputCallback) {
        self.outputCallback(str);
    } else {
        self.temporaryLog = [[NSString alloc] initWithFormat:@"%@%@", self.temporaryLog, str];
    }
    [[nf object] readInBackgroundAndNotify];
}

@end
