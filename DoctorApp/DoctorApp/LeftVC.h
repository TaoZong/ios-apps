//
//  LeftVC.h
//  DoctorApp
//
//  Created by Tao Zong on 7/29/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"
#import "FDTakeController.h"

@interface LeftVC : AMSlideMenuLeftTableViewController

@property FDTakeController *takeController;
@property (strong, nonatomic) NSDictionary *profile;
@property (strong, nonatomic) NSDictionary *status;
@property (strong, nonatomic) UIImage* profileImage;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIView *darkView;

+ (void)setCirc:(UIImage *)image;
+ (void)setName:(NSString *)name;
@end
