//
//  MainVC.m
//  DoctorApp
//
//  Created by Tao Zong on 7/28/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSString *) segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString * identifier;
    
    switch (indexPath.row) {
        case 0:
            identifier = @"first";
            break;
        case 1:
            identifier = @"1";
            break;
        case 2:
            identifier = @"2";
            break;
        case 3:
            identifier = @"3";
            break;
        case 4:
            identifier = @"4";
            break;
        case 6:
            identifier = @"logout";
            break;
    }
    
    return identifier;
}

- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){10,10};
    frame.size = (CGSize){20,20};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
}

@end
