//
//  ViewController.m
//  XLLogerDemo
//
//  Created by mgfjx on 2021/9/12.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "XLLogerDemo-Swift.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) LogManager *manager ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[XLLogerManager manager] showOnWindow];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[XLLogerManager manager] showOnWindow];
    });
    
    LogManager *manager = [[LogManager alloc] init];
    [manager openConsolePipe];
    self.manager = manager;
    
    manager.callback = ^(NSString * str) {
        self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, str];
    };
}

- (IBAction)logSomething:(UIButton *)sender {
    [[XLLogerManager manager] showOnWindow];
    NSLog(@"%@", [NSDate date]);
    
}

- (IBAction)recover:(UIButton *)sender {
    printf("hahaha");
}

- (IBAction)popController:(UIButton *)sender {
    
    TestViewController *vc = [[TestViewController alloc] init];
    vc.view.backgroundColor = [UIColor orangeColor];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
