//
//  CMBBaseViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBBaseViewController.h"
#import "CMBUtility.h"

@interface CMBBaseViewController ()

@end

@implementation CMBBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"SetoFont-SP" size:19.0]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTintColor:[CMBUtility tintColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
