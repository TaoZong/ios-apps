//
//  AddressCell.m
//  DoctorApp
//
//  Created by Tao Zong on 10/28/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        self.titleView.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8f];
        [self addSubview:self.titleView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 145, 20)];
        title.text = @"Address";
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
        
        self.streetTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, 280, 30)];
        self.streetTxt.layer.masksToBounds=YES;
        self.streetTxt.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        self.streetTxt.layer.borderWidth= 1.0f;
        self.streetTxt.textAlignment = NSTextAlignmentCenter;
        self.streetTxt.placeholder = @"Street";
        self.streetTxt.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.streetTxt];
        
        self.cityTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, 280, 30)];
        self.cityTxt.layer.masksToBounds=YES;
        self.cityTxt.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        self.cityTxt.layer.borderWidth= 1.0f;
        self.cityTxt.textAlignment = NSTextAlignmentCenter;
        self.cityTxt.placeholder = @"City";
        self.cityTxt.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.cityTxt];
        
        self.stateTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 280, 30)];
        self.stateTxt.layer.masksToBounds=YES;
        self.stateTxt.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        self.stateTxt.layer.borderWidth= 1.0f;
        self.stateTxt.textAlignment = NSTextAlignmentCenter;
        self.stateTxt.placeholder = @"State";
        self.stateTxt.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.stateTxt];
        
        self.zipcodeTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, 130, 280, 30)];
        self.zipcodeTxt.layer.masksToBounds=YES;
        self.zipcodeTxt.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        self.zipcodeTxt.layer.borderWidth= 1.0f;
        self.zipcodeTxt.textAlignment = NSTextAlignmentCenter;
        self.zipcodeTxt.placeholder = @"Zip Code";
        self.zipcodeTxt.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.zipcodeTxt];
        
        self.countryTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, 160, 280, 30)];
        self.countryTxt.layer.masksToBounds=YES;
        self.countryTxt.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        self.countryTxt.layer.borderWidth= 1.0f;
        self.countryTxt.textAlignment = NSTextAlignmentCenter;
        self.countryTxt.placeholder = @"Country";
        self.countryTxt.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.countryTxt];
        
        self.removeBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 190, 280, 30)];
        self.removeBt.backgroundColor = [UIColor clearColor];
        [self.removeBt setTitle:@"Remove Address" forState:UIControlStateNormal];
        [self.removeBt setTitleColor:[UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        self.removeBt.backgroundColor = [UIColor lightGrayColor];
        self.removeBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.removeBt];
        
        UIImageView *removePhoneBtImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        removePhoneBtImage.image = [UIImage imageNamed:@"delete"];
        [self.removeBt addSubview:removePhoneBtImage];
        
        self.seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 220, 280, 20)];
        self.seperator.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        [self addSubview:self.seperator];
    }
    return self;
}

@end
