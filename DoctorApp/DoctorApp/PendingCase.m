//
//  PendingCase.m
//  DoctorApp
//
//  Created by Tao Zong on 10/22/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "PendingCase.h"

@implementation PendingCase

-(void) setData:(NSString *)iSummary Title:(NSString *)iTitle Date:(NSString *)iDate Time:(NSString *)iTime WithId:(NSString *)case_id
{
    title = iTitle;
    summary = iSummary;
    date = iDate;
    time = iTime;
    caseid = case_id;
}

-(NSString *) getSummary
{
    return summary;
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

-(NSString *) getCaseid
{
    return caseid;
}

@end
