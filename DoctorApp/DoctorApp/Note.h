//
//  Note.h
//  DoctorApp
//
//  Created by Tao Zong on 10/24/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject {NSString *title, *time;}

-(void) setData:(NSString *)title Time:(NSString *)time;

-(NSString *) getTitle;
-(NSString *) getTime;

@end
