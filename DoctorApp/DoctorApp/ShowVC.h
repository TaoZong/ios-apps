//
//  ShowVC.h
//  DoctorApp
//
//  Created by Tao Zong on 7/29/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@interface ShowVC : UIViewController<UITableViewDelegate, UITableViewDataSource, MZTimerLabelDelegate, UIWebViewDelegate>
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIView *darkView;
//@property (strong, nonatomic) IBOutlet MZTimerLabel *timeCount;
//@property (nonatomic, strong) NSMutableArray *selectedIndexPaths1;
//@property (nonatomic, strong) NSMutableArray *selectedIndexPaths2;
@end
