//
//  Note.m
//  DoctorApp
//
//  Created by Tao Zong on 10/24/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "Note.h"

@implementation Note

-(void) setData:(NSString *)iTitle Time:(NSString *)iTime
{
    title = iTitle;
    time = iTime;
}

-(NSString *) getTitle
{
    return title;
}
-(NSString *) getTime
{
    return time;
}

@end
