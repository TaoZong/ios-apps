//
//  PhoneCell.h
//  DoctorApp
//
//  Created by Tao Zong on 10/28/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneCell : UITableViewCell
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIButton *selectLabelBt;
@property (nonatomic, strong) UITextField *phoneNumberTxt;
@property (nonatomic, strong) UIButton *removeBt;
@property (nonatomic, strong) UIView *seperator;
@end
