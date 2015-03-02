//
//  TimeoutApplication.m
//  DoctorApp
//
//  Created by Tao Zong on 10/6/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "TimeoutApplication.h"

@implementation TimeoutApplication

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    
    // Fire up the timer upon first event
    if(!_idleTimer) {
        [self resetIdleTimer];
    }
    
    // Check to see if there was a touch event
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan) {
            [self resetIdleTimer];
        }
    }
}

- (void)resetIdleTimer
{
    if (_idleTimer) {
        [_idleTimer invalidate];
//        [_idleTimer release];
    }
    
    // Schedule a timer to fire in kApplicationTimeoutInMinutes * 60
    int timeout = kApplicationTimeoutInMinutes * 60;
    _idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                   target:self
                                                 selector:@selector(idleTimerExceeded)
                                                 userInfo:nil
                                                  repeats:NO];
    
}

- (void)idleTimerExceeded {
    /* Post a notification so anyone who subscribes to it can be notified when
     * the application times out */
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kApplicationDidTimeoutNotification object:nil];
}

//- (void) dealloc {
//    [_idleTimer release];
//    [super dealloc];
//}


@end
