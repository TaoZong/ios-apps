//
//  ContactInfoVC.m
//  DoctorApp
//
//  Created by Tao Zong on 10/24/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "ContactInfoVC.h"
#import "PhoneCell.h"
#import "AddressCell.h"
#import "DoctorAppAppDelegate.h"
#import "Reachability.h"

@interface ContactInfoVC () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *addPhoneBt;
@property (strong, nonatomic) UIButton *addAddressBt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (strong, nonatomic) UITableView *phoneView;
@property (strong, nonatomic) UITableView *addressView;
@property (strong, nonatomic) NSMutableArray *data, *data2;
@property UIBarButtonItem *doneBt;
@property UIView *view1, *view2, *view3, *view4, *view5;
@property (strong, nonatomic) NSMutableDictionary *profile;

@end

@implementation ContactInfoVC

static NSString *cellIdentifier = @"rowCell1";
static NSString *cellIdentifier2 = @"rowCell2";
NSArray *pickerArray, *pickerArray2;
UIPickerView *myPickerView, *myPickerView2;
int tmp;
NSString *tmpString;
bool flag;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DoctorAppAppDelegate *appDelegate = (DoctorAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.profile = appDelegate.globalProfile;
    self.scrollView.bounces = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.data = [self.profile[@"profile"][@"phone"] mutableCopy];
    self.data2 = [self.profile[@"profile"][@"address"] mutableCopy];
    self.emailTxt.text = self.profile[@"user_info"][@"email"];
    self.emailTxt.enabled = NO;
    pickerArray = [[NSArray alloc]initWithObjects:@"Home",@"Mobile",
                   @"Office", @"Other", nil];
    pickerArray2 = [[NSArray alloc]initWithObjects:@"Home",
                    @"Office", @"Other", nil];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25, 25)];
    UIImage *backImage = [UIImage imageNamed:@"LArrow.png"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    self.doneBt = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(updateContactProfile)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = self.doneBt;
    
    self.phoneView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, 280, 120 * [self.data count])];
    self.phoneView.backgroundColor = [UIColor clearColor];
    self.phoneView.delegate = self;
    self.phoneView.dataSource = self;
    self.phoneView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.phoneView setScrollEnabled:false];
    
    self.addPhoneBt = [[UIButton alloc] initWithFrame:CGRectMake(0, self.phoneView.frame.origin.y + self.phoneView.frame.size.height, 280, 30)];
    [self.addPhoneBt setTitle:@"Add Phone Number" forState:UIControlStateNormal];
    [self.addPhoneBt setTitleColor:[UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    self.addPhoneBt.titleLabel.font = [UIFont systemFontOfSize:16];
    self.addPhoneBt.backgroundColor = [UIColor lightGrayColor];
    [self.addPhoneBt addTarget:self action:@selector(addPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *addPhoneBtImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
    addPhoneBtImage.image = [UIImage imageNamed:@"new"];
    [self.addPhoneBt addSubview:addPhoneBtImage];
    
    self.addressView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.addPhoneBt.frame.origin.y + self.addPhoneBt.frame.size.height + 20, 280, 240 * [self.data2 count])];
    self.addressView.backgroundColor = [UIColor clearColor];
    self.addressView.delegate = self;
    self.addressView.dataSource = self;
    self.addressView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.addressView setScrollEnabled:false];
    
    self.addAddressBt = [[UIButton alloc] initWithFrame:CGRectMake(0, self.addressView.frame.origin.y + self.addressView.frame.size.height, 280, 30)];
    [self.addAddressBt setTitle:@"Add Address" forState:UIControlStateNormal];
    [self.addAddressBt setTitleColor:[UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    self.addAddressBt.titleLabel.font = [UIFont systemFontOfSize:16];
    self.addAddressBt.backgroundColor = [UIColor lightGrayColor];
    [self.addAddressBt addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *addAddressBtImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
    addAddressBtImage.image = [UIImage imageNamed:@"new"];
    [self.addAddressBt addSubview:addAddressBtImage];
    
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.addPhoneBt];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.addAddressBt];
    
    [self.phoneView registerClass:[PhoneCell class] forCellReuseIdentifier:cellIdentifier];
    [self.addressView registerClass:[AddressCell class] forCellReuseIdentifier:cellIdentifier2];
    
    self.scrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.scrollView.layer.borderWidth = 1.0;
    float sizeOfContent = 0;
    UIView *lLast = [self.scrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    sizeOfContent = wd + ht + 20;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, sizeOfContent);
    
    // makes the textfields and buttons in the scrollview can scroll when drag on them
    self.scrollView.panGestureRecognizer.delaysTouchesBegan = self.scrollView.delaysContentTouches;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addPhoneNumber:(id)sender {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + 120);
    [UIView beginAnimations:@"Move" context:nil];
    [self.phoneView setFrame:CGRectMake(self.phoneView.frame.origin.x, self.phoneView.frame.origin.y, self.phoneView.frame.size.width, self.phoneView.frame.size.height + 120)];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"Home" forKey:@"label"];
    [self.data addObject:dict];
    [self.phoneView reloadData];
    [self.addPhoneBt setFrame:CGRectMake(self.addPhoneBt.frame.origin.x, self.addPhoneBt.frame.origin.y + 120, self.addPhoneBt.frame.size.width, self.addPhoneBt.frame.size.height)];
    [self.addressView setFrame:CGRectMake(self.addressView.frame.origin.x, self.addressView.frame.origin.y + 120, self.addressView.frame.size.width, self.addressView.frame.size.height)];
    [self.addAddressBt setFrame:CGRectMake(self.addAddressBt.frame.origin.x, self.addAddressBt.frame.origin.y + 120, self.addAddressBt.frame.size.width, self.addAddressBt.frame.size.height)];
    [UIView commitAnimations];
    if(self.addPhoneBt.frame.origin.y > 300)
        [self.scrollView setContentOffset:CGPointMake(self.addPhoneBt.frame.origin.x, self.addPhoneBt.frame.origin.y - 300) animated:YES];
}

- (IBAction)addAddress:(id)sender {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + 240);
    [UIView beginAnimations:@"Move" context:nil];
    [self.addressView setFrame:CGRectMake(self.addressView.frame.origin.x, self.addressView.frame.origin.y, self.addressView.frame.size.width, self.addressView.frame.size.height + 240)];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"Home" forKey:@"label"];
    [self.data2 addObject:dict];
    [self.addressView reloadData];
    [self.addAddressBt setFrame:CGRectMake(self.addAddressBt.frame.origin.x, self.addAddressBt.frame.origin.y + 240, self.addAddressBt.frame.size.width, self.addAddressBt.frame.size.height)];
//    NSLog(@"%f", self.addAddressBt.frame.origin.y);
    [UIView commitAnimations];
    if(self.addAddressBt.frame.origin.y > 300)
        [self.scrollView setContentOffset:CGPointMake(self.addAddressBt.frame.origin.x, self.addAddressBt.frame.origin.y - 300) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.phoneView)
        return [self.data count];
    else
        return [self.data2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.phoneView) {
        PhoneCell *cell = (PhoneCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[PhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.removeBt.tag = indexPath.row;
        cell.selectLabelBt.tag = indexPath.row;
        [cell.removeBt addTarget:self action:@selector(readyRemovePhone:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *phonerow = [[self.data objectAtIndex:indexPath.row] mutableCopy];
        cell.phoneNumberTxt.text = phonerow[@"number"];
        cell.phoneNumberTxt.delegate = self;
        cell.selectedLabel.text = [phonerow[@"label"] capitalizedString];
        [cell.selectLabelBt addTarget:self action:@selector(selectLabel:) forControlEvents:UIControlEventTouchUpInside];
        
        if(indexPath.row == 0) {
            [cell.removeBt removeFromSuperview];
            [cell.seperator setFrame:CGRectMake(0, 70, 280, 20)];
        }
        
        return cell;
    }
    else {
        AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if(cell == nil) {
            cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.removeBt.tag = indexPath.row;
        cell.selectLabelBt.tag = indexPath.row;
        [cell.removeBt addTarget:self action:@selector(readyRemoveAddress:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *addressrow = [[self.data2 objectAtIndex:indexPath.row] mutableCopy];
        cell.selectedLabel.text = [addressrow[@"label"] capitalizedString];
        cell.streetTxt.text = addressrow[@"street"];
        cell.cityTxt.text = addressrow[@"city"];
        cell.stateTxt.text = addressrow[@"state"];
        cell.zipcodeTxt.text = addressrow[@"zipcode"];
        cell.countryTxt.text = @"United States";
        cell.streetTxt.delegate = self;
        cell.cityTxt.delegate = self;
        cell.stateTxt.delegate = self;
        cell.zipcodeTxt.delegate = self;
        cell.countryTxt.delegate = self;
        [cell.selectLabelBt addTarget:self action:@selector(selectLabel2:) forControlEvents:UIControlEventTouchUpInside];
        
        if(indexPath.row == 0) {
            [cell.removeBt removeFromSuperview];
            [cell.seperator setFrame:CGRectMake(0, 190, 280, 20)];
        }
        
        return cell;
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.phoneView) {
        if(indexPath.row == 0)
            return 90;
        else
            return 120;
    }
    else {
        if(indexPath.row == 0)
            return 210;
        else
            return 240;
    }
    
    
}

- (void)removePhone: (id)sender
{
    [self.view2 removeFromSuperview];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - 120);
    [UIView beginAnimations:@"Move" context:nil];
    [self.phoneView setFrame:CGRectMake(self.phoneView.frame.origin.x, self.phoneView.frame.origin.y, self.phoneView.frame.size.width, self.phoneView.frame.size.height - 120)];
    UIButton *button = (UIButton *)sender;
    [self.data removeObjectAtIndex:button.tag];
    [self.phoneView reloadData];
    [self.addPhoneBt setFrame:CGRectMake(self.addPhoneBt.frame.origin.x, self.addPhoneBt.frame.origin.y - 120, self.addPhoneBt.frame.size.width, self.addPhoneBt.frame.size.height)];
    [self.addressView setFrame:CGRectMake(self.addressView.frame.origin.x, self.addressView.frame.origin.y - 120, self.addressView.frame.size.width, self.addressView.frame.size.height)];
    [self.addAddressBt setFrame:CGRectMake(self.addAddressBt.frame.origin.x, self.addAddressBt.frame.origin.y - 120, self.addAddressBt.frame.size.width, self.addAddressBt.frame.size.height)];
    [UIView commitAnimations];
}

- (void)removeAddress: (id)sender
{
    [self.view4 removeFromSuperview];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - 240);
    [UIView beginAnimations:@"Move" context:nil];
    [self.addressView setFrame:CGRectMake(self.addressView.frame.origin.x, self.addressView.frame.origin.y, self.addressView.frame.size.width, self.addressView.frame.size.height - 240)];
    UIButton *button = (UIButton *)sender;
    [self.data2 removeObjectAtIndex:button.tag];
    [self.addressView reloadData];
    [self.addAddressBt setFrame:CGRectMake(self.addAddressBt.frame.origin.x, self.addAddressBt.frame.origin.y - 240, self.addAddressBt.frame.size.width, self.addAddressBt.frame.size.height)];
    [UIView commitAnimations];
}

- (void)selectLabel: (id)sender
{
    UIButton *tBt = (UIButton *)sender;
    tmp = tBt.tag;
    tmpString = @"Home";
    
    self.view1 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view1 setBackgroundColor:[UIColor blackColor]];
    self.view1.alpha = 0.5;
    self.view1.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViews)];
    [self.view1 addGestureRecognizer:tapGesture];
    [self.view addSubview:self.view1];
    
    
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, 144, 250, 162)];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.tag = 10;
    myPickerView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [myPickerView selectRow:0 inComponent:0 animated:YES];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done)];
    doneButton.tintColor = [UIColor blackColor];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake((self.view.frame.size.width - 250) / 2, 100, 250, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    toolBar.tag = 11;
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    
    [self.view addSubview:myPickerView];
    [self.view addSubview:toolBar];
    
}

- (void)selectLabel2: (id)sender
{
    UIButton *tBt = (UIButton *)sender;
    tmp = tBt.tag;
    tmpString = @"Home";
    
    self.view1 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view1 setBackgroundColor:[UIColor blackColor]];
    self.view1.alpha = 0.5;
    self.view1.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViews)];
    [self.view1 addGestureRecognizer:tapGesture];
    [self.view addSubview:self.view1];
    
    
    myPickerView2 = [[UIPickerView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, 144, 250, 162)];
    myPickerView2.dataSource = self;
    myPickerView2.delegate = self;
    myPickerView2.showsSelectionIndicator = YES;
    myPickerView2.tag = 10;
    myPickerView2.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [myPickerView2 selectRow:0 inComponent:0 animated:YES];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done)];
    doneButton.tintColor = [UIColor blackColor];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake((self.view.frame.size.width - 250) / 2, 100, 250, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    toolBar.tag = 11;
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    
    [self.view addSubview:myPickerView2];
    [self.view addSubview:toolBar];
    
}


- (void)done {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tmp inSection:0];
    if(flag) {
        NSMutableDictionary * dict = [[self.data objectAtIndex:tmp] mutableCopy];
        [dict setValue:tmpString forKey:@"label"];
        [self.data replaceObjectAtIndex:tmp withObject:dict];
        [self.phoneView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        NSMutableDictionary * dict = [[self.data2 objectAtIndex:tmp] mutableCopy];
        [dict setValue:tmpString forKey:@"label"];
        [self.data2 replaceObjectAtIndex:tmp withObject:dict];
        [self.addressView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self removeViews];
}

- (void)removeViews {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}


#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == myPickerView)
    {
        flag = true;
        return [pickerArray count];
    }
    else
    {
        flag = false;
        return [pickerArray2 count];
    }
}

#pragma mark- Picker View Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == myPickerView)
        tmpString = [pickerArray objectAtIndex:row];
    else
        tmpString = [pickerArray2 objectAtIndex:row];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == myPickerView)
        return [pickerArray objectAtIndex:row];
    else
        return [pickerArray2 objectAtIndex:row];
}

- (void)readyRemovePhone:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    self.view2 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view2 setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f]];
    [self.view addSubview:self.view2];
    
    self.view3 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 150) / 2, 250, 150)];
    [self.view2 addSubview:self.view3];
    [self.view3 setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 250, 70)];
    [label setText:@"Please confirm that you want to remove this phone number."];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setEditable:NO];
    [label setSelectable:NO];
    [self.view3 addSubview:label];
    
    UIButton *bt1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 105, 80, 30)];
    [bt1 setTitle:@"Cancel" forState:UIControlStateNormal];
    [bt1 setBackgroundColor:[UIColor lightGrayColor]];
    [bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt1.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt1 addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view3 addSubview:bt1];
    
    UIButton *bt2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 105, 80, 30)];
    bt2.tag = bt.tag;
    [bt2 setTitle:@"Remove" forState:UIControlStateNormal];
    [bt2 setBackgroundColor:[UIColor darkGrayColor]];
    [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt2 addTarget:self action:@selector(removePhone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view3 addSubview:bt2];
}

- (void)readyRemoveAddress:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    self.view4 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view4 setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f]];
    [self.view addSubview:self.view4];
    
    self.view5 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 150) / 2, 250, 150)];
    [self.view4 addSubview:self.view5];
    [self.view5 setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 250, 70)];
    [label setText:@"Please confirm that you want to remove this address."];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setEditable:NO];
    [label setSelectable:NO];
    [self.view5 addSubview:label];
    
    UIButton *bt1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 105, 80, 30)];
    [bt1 setTitle:@"Cancel" forState:UIControlStateNormal];
    [bt1 setBackgroundColor:[UIColor lightGrayColor]];
    [bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt1.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt1 addTarget:self action:@selector(closeView2) forControlEvents:UIControlEventTouchUpInside];
    [self.view5 addSubview:bt1];
    
    UIButton *bt2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 105, 80, 30)];
    bt2.tag = bt.tag;
    [bt2 setTitle:@"Remove" forState:UIControlStateNormal];
    [bt2 setBackgroundColor:[UIColor darkGrayColor]];
    [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt2 addTarget:self action:@selector(removeAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view5 addSubview:bt2];
}

- (void)closeView
{
    [self.view2 removeFromSuperview];
}

- (void)closeView2
{
    [self.view4 removeFromSuperview];
}



- (void)updateContactProfile
{
    NSMutableDictionary *d = self.profile[@"profile"];
    NSLog(@"%@",d);
//    [d setObject:self.emailTxt.text forKey:@"email"];
//    [self.profile setObject:d forKey:@"user_info"];
    
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.data count]; i++)
    {
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        PhoneCell *phonecell = (PhoneCell *)[self.phoneView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *phonelabel = [phonecell.selectedLabel.text lowercaseString];
        NSString *phonenumber = phonecell.phoneNumberTxt.text;
        [d setObject:phonelabel forKey:@"label"];
        [d setObject:phonenumber forKey:@"number"];
        [phones addObject:d];
    }
    NSMutableArray *addresses = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.data2 count]; i++)
    {
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        AddressCell *addresscell = (AddressCell *)[self.addressView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *addresslabel = [addresscell.selectedLabel.text lowercaseString];
        NSString *street = addresscell.streetTxt.text;
        NSString *city = addresscell.cityTxt.text;
        NSString *state = addresscell.stateTxt.text;
        NSString *zipcode = addresscell.zipcodeTxt.text;
        [d setObject:addresslabel forKey:@"label"];
        [d setObject:street forKey:@"street"];
        [d setObject:city forKey:@"city"];
        [d setObject:state forKey:@"state"];
        [d setObject:zipcode forKey:@"zipcode"];
        [addresses addObject:d];
    }
    d = [self.profile[@"profile"] mutableCopy];
    [d setObject:phones forKey:@"phone"];
    [d setObject:addresses forKey:@"address"];
    [self.profile setObject:d forKey:@"profile"];
    
    NSLog(@"%@",self.profile);
    
    [self updateProfile];
    
}

- (void)startLoadingIndicator
{
    self.darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.darkView.alpha = 0.5;
    self.darkView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.darkView];
    
    self.activityView = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center=self.view.center;
    [self.activityView startAnimating];
    [self.darkView addSubview:self.activityView];
}

- (void)stopLoadingIndicator
{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    [self.darkView removeFromSuperview];
}

- (void)updateProfile
{
    [self startLoadingIndicator];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:self.profile options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/doctor/updateprofile"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:5];
    NSHTTPURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"~~~~~ Status code: %d", [response statusCode]);
    [self stopLoadingIndicator];
    if([response statusCode] == 200)
        [self popBack];
    else
        [self popNCError];
}


- (void)popNCError
{
    NSString *errorMessage = @"Please check your internet connnection then try again.";
    if([self currentNetworkStatus])
    {
        errorMessage = @"Sorry for the inconvenience that our service is currently under maintenance. Please retry after a while. Thank you.";
    }
    UIAlertView *alertView;
    alertView = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (BOOL)currentNetworkStatus
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
