//
//  SignInVC.h
//  DoctorApp
//
//  Created by Tao Zong on 7/29/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInVC : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIView *darkView;
@end
