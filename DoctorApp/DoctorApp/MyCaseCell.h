//
//  MyCaseCell.h
//  DoctorApp
//
//  Created by Tao Zong on 10/15/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCaseCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *dateImgageView;
@property (nonatomic, strong) UIButton *extendButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *extendImageView;
@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, strong) UIView *extendView;

@end
