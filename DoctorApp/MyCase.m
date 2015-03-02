//
//  MyCase.m
//  DoctorApp
//
//  Created by Tao Zong on 10/21/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "MyCase.h"

@implementation MyCase

-(void) setData:(NSArray *)iNotifications Title:(NSString *)iTitle Date:(NSString *)iDate Time:(NSString *)iTime IsTop:(BOOL)iIsTopPriority WithId:(NSString *)case_id
{
    notifications = iNotifications;
    title = iTitle;
    date = iDate;
    time = iTime;
    isTopPriority = iIsTopPriority;
    caseid = case_id;
}

-(NSArray *) getNotifications
{
    return notifications;
}

-(NSString *) getTitle
{
    return title;
}

-(NSString *) getDate
{
    return date;
}

-(NSString *) getTime
{
    return time;
}

-(BOOL) getTop
{
    return isTopPriority;
}

-(NSString *) getCaseid
{
    return caseid;
}

@end
