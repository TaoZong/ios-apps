//
//  DoctorAppAppDelegate.h
//  DoctorApp
//
//  Created by Tao Zong on 7/28/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInVC.h"
#import "FirstLaunchVC.h"
#import "ShowVC.h"

@interface DoctorAppAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SignInVC *signInVC;
@property (strong, nonatomic) FirstLaunchVC *firstVC;
@property (strong, nonatomic) ShowVC *showVC;
@property (assign, nonatomic) NSInteger globalTimeInteger;

@property (strong, nonatomic) NSMutableDictionary *globalProfile;
@property (strong, nonatomic) NSMutableArray *globalCases;
@property (strong, nonatomic) NSString *devicetoken;
@end
