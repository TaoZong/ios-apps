//
//  AddressCell.h
//  DoctorApp
//
//  Created by Tao Zong on 10/28/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIButton *selectLabelBt;
@property (nonatomic, strong) UITextField *streetTxt;
@property (nonatomic, strong) UITextField *cityTxt;
@property (nonatomic, strong) UITextField *stateTxt;
@property (nonatomic, strong) UITextField *countryTxt;
@property (nonatomic, strong) UITextField *zipcodeTxt;
@property (nonatomic, strong) UIButton *removeBt;
@property (nonatomic, strong) UIView *seperator;
@end
