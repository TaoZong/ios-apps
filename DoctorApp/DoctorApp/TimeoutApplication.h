//
//  TimeoutApplication.h
//  DoctorApp
//
//  Created by Tao Zong on 10/6/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define kApplicationTimeoutInMinutes 5
#define kApplicationDidTimeoutNotification @"ApplicationDidTimeout"

@interface TimeoutApplication : UIApplication {
    NSTimer *_idleTimer;
}

- (void)resetIdleTimer;

@end
