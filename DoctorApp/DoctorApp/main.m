//
//  main.m
//  DoctorApp
//
//  Created by Tao Zong on 7/28/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DoctorAppAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([DoctorAppAppDelegate class]));
        int retVal = UIApplicationMain(argc, argv, @"TimeoutApplication", NSStringFromClass([DoctorAppAppDelegate class]));
        return retVal;

    }
}
