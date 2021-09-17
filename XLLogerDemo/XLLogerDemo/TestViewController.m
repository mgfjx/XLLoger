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
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@", [NSDate date]);
}

@end
