//
//  CaseDetailVC.h
//  DoctorApp
//
//  Created by Tao Zong on 7/30/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseDetailVC : UIViewController
@property (strong, nonatomic) NSString *caseid;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIView *darkView;
@end
