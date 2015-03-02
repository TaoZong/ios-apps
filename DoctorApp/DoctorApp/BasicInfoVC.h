//
//  BasicInfoVC.h
//  DoctorApp
//
//  Created by Tao Zong on 10/24/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDTakeController.h"

@interface BasicInfoVC : UIViewController<UITextFieldDelegate>
@property FDTakeController *takeController;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIView *darkView;
+ (void)setCirc:(UIImage *)image;
@end
