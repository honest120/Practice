//
//  ViewController.m
//  01、绘图_01
//
//  Created by kinglinfu on 16/8/29.
//  Copyright © 2016年 Tens. All rights reserved.
//

#import "ViewController.h"
#import "BezierPathView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BezierPathView *pathView = [[BezierPathView alloc] initWithFrame:self.view.bounds];
    pathView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:pathView];
}




@end
