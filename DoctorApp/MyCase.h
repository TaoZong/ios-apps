//
//  MyCase.h
//  DoctorApp
//
//  Created by Tao Zong on 10/21/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCase : NSObject {NSArray *notifications; NSString *title, *date, *time, *caseid; BOOL isTopPriority;}

-(void) setData:(NSArray *)notifications Title:(NSString *)title Date:(NSString *)date Time:(NSString *)time IsTop:(BOOL)isTopPriority WithId:(NSString *)caseid;

-(NSArray *) getNotifications;
-(NSString *) getTitle;
-(NSString *) getDate;
-(NSString *) getTime;
-(NSString *) getCaseid;
-(BOOL) getTop;

@end