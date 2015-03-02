//
//  TeamMemberVC.h
//  DoctorApp
//
//  Created by Tao Zong on 11/22/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMemberVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) NSString *caseid;
@end
