//
//  PendingCase.h
//  DoctorApp
//
//  Created by Tao Zong on 10/22/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingCase : NSObject {NSString *title, *date, *time, *summary, *caseid;}

-(void) setData:(NSString *)summary Title:(NSString *)title Date:(NSString *)date Time:(NSString *)time WithId:(NSString *)caseid;

-(NSString *) getSummary;
-(NSString *) getTitle;
-(NSString *) getDate;
-(NSString *) getTime;
-(NSString *) getCaseid;

@end

