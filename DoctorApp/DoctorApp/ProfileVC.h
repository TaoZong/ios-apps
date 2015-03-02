//
//  ProfileVC.h
//  DoctorApp
//
//  Created by Tao Zong on 10/23/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController
@property (strong, nonatomic) NSDictionary *profile;
@property (strong, nonatomic) NSDictionary *status;
+ (void)setCirc:(UIImage *)image;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIView *darkView;
@end
