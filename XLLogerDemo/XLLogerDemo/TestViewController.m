//
//  TestViewController.m
//  XLLogerDemo
//
//  Created by mgfjx on 2021/9/17.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:button];
    
}

- (void)btnClicked {
    NSLog(@"btnClicked");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@", [NSDate date]);
}

@end
