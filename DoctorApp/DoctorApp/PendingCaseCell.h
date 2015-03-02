//
//  PendingCaseCell.h
//  DoctorApp
//
//  Created by Tao Zong on 10/22/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingCaseCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *dateImgageView;
@property (nonatomic, strong) UIButton *extendButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *extendImageView;
@property (nonatomic, strong) UIView *extendView;
@property (nonatomic, strong) UIButton *acceptBt;
@property (nonatomic, strong) UIButton *declineBt;
@end
