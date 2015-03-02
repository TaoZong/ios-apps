//
//  MyCaseCell.m
//  DoctorApp
//
//  Created by Tao Zong on 10/15/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "MyCaseCell.h"

@interface MyCaseCell ()

@end

@implementation MyCaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        UIImage *timeimage = [UIImage imageNamed:@"top-notification"];
        self.dateImgageView = [[UIImageView alloc] init];
        [self.dateImgageView setFrame:CGRectMake(0, 10, 50, 50)];
        self.dateImgageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:self.dateImgageView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 25, 35)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        [self.timeLabel setNumberOfLines:1];
        [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.timeLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 30)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [self.titleLabel setNumberOfLines:1];
        [self addSubview:self.titleLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 80, 10)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        [self.dateLabel setNumberOfLines:1];
        
        [self addSubview:self.dateLabel];
        
        self.extendButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 15, 40, 40)];
        [self addSubview:self.extendButton];
        
        UIView *view1 = [[UIView alloc] initWithFrame: CGRectMake(0, 69, 240, 1)];
        view1.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view1];
        
        self.extendView = [[UIView alloc] initWithFrame: CGRectMake(0, 70, 240, 0)];
        [self addSubview:self.extendView];

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
