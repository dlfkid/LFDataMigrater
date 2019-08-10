//
//  MainViewController.m
//  LFDataMigraterDemo
//
//  Created by LeonDeng on 2019/7/31.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "MainViewController.h"
#import "LFDataMigrater.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MainViewController";
    [[LFDataMigrater alloc] initWithDataBaseName:@"test" Path:@"Go to hell" toVersion:@3];
}


@end
