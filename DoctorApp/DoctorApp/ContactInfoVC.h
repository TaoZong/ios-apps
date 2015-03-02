//
//  ContactInfoVC.h
//  DoctorApp
//
//  Created by Tao Zong on 10/24/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactInfoVC : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIView *darkView;
@end
