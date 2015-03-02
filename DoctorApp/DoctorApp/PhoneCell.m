//
//  PhoneCell.m
//  DoctorApp
//
//  Created by Tao Zong on 10/28/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "PhoneCell.h"

@implementation PhoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        self.titleView.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8f];
        [self addSubview:self.titleView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 145, 20)];
        title.text = @"Phone Number";
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor whiteColor];
        [self.titleView addSubview:title];
        
        self.selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 100, 20)];
//        self.selectedLabel.text = @"Home";
        self.selectedLabel.textAlignment = NSTextAlignmentRight;
        self.selectedLabel.textColor = [UIColor whiteColor];
        [self.titleView addSubview:self.selectedLabel];
        
        self.selectLabelBt = [[UIButton alloc] initWithFrame:CGRectMake(250, 5, 30, 30)];
        UIImage *btnImage = [UIImage imageNamed:@"extend2"];
        [self.selectLabelBt setImage:btnImage forState:UIControlStateNormal];
        [self.titleView addSubview:self.selectLabelBt];
        
        self.phoneNumberTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, 280, 30)];
        self.phoneNumberTxt.layer.masksToBounds=YES;
        self.phoneNumberTxt.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        self.phoneNumberTxt.layer.borderWidth= 1.0f;
        self.phoneNumberTxt.textAlignment = NSTextAlignmentCenter;
        self.phoneNumberTxt.placeholder = @"Edit Phone Number";
        self.phoneNumberTxt.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.phoneNumberTxt];
        
        self.removeBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, 280, 30)];
        self.removeBt.backgroundColor = [UIColor lightGrayColor];
        [self.removeBt setTitle:@"Remove phone number" forState:UIControlStateNormal];
        [self.removeBt setTitleColor:[UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        self.removeBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.removeBt];
        
        UIImageView *removePhoneBtImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        removePhoneBtImage.image = [UIImage imageNamed:@"delete"];
        [self.removeBt addSubview:removePhoneBtImage];
        
        self.seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 280, 20)];
        self.seperator.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        [self addSubview:self.seperator];
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
