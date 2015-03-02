//
//  ShowVC.m
//  DoctorApp
//
//  Created by Tao Zong on 7/29/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "ShowVC.h"
#import <QuartzCore/QuartzCore.h>
#import "MyCaseCell.h"
#import "PendingCaseCell.h"
#import "NoteCell.h"
#import "CaseDetailVC.h"
#import "PendingCaseDetailVC.h"
#import "CompleteCaseDetailVC.h"
#import "NoteVC.h"
#import "DoctorAppAppDelegate.h"
#import "MyCase.h"
#import "PendingCase.h"
#import "Note.h"
#import "Reachability.h"


@interface ShowVC ()

@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UITableView *caselist;
@property (strong, nonatomic) UIScrollView *notelist;
@property (strong, nonatomic) UIScrollView *caseScrollView;

@property (strong, nonatomic) UILabel *txtView1;
@property (strong, nonatomic) UILabel *txtView2;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *data2;
@property (strong, nonatomic) NSMutableArray *data3;

@property UIView *notificationBtView, *caselistBtView, *noteBtView;
@property UIView *notificationView, *caselistView, *noteView;
@property UIView *topPriorityCaseView, *currentCaseView, *pendingCaseView, *completeCaseView;
@property UILabel *notificationBtLabel, *caselistBtLabel, *noteBtLabel;
@property UIImageView *notificationBtImage, *caselistBtImage, *noteBtImage;
@property UIView *view1;
@property UIView *view2;
@property UIBarButtonItem *addNoteBt;


@property (strong, nonatomic) NSMutableArray *cases, *casesWithOrder, *topPriorityCaselist, *currentCaselist, *pendingCaselist, *completeCaselist;
@end



@implementation ShowVC

static NSString *cellIdentifier = @"rowCell1";
static NSString *cellIdentifier2 = @"rowCell2";
static NSString *cellIdentifier3 = @"rowCell3";
static bool flag = true;
static NSMutableArray *selectedIndexPaths1;
static NSMutableArray *selectedIndexPaths2;
static NSArray *months;
static int x, y, noCount, noCount2;
static int tabNumber = 0;
static int myFont = 10;
bool makeEmpty = false;
static bool topSelected, currentSelected, pendingSelected, completeSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    flag = true;
    self.caseScrollView.bounces = NO;
    self.notelist.bounces = NO;
    topSelected = true;
    currentSelected = true;
    pendingSelected = true;
    completeSelected = false;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startLoadingIndicator];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:68.0f/255.0f green:138.0f/255.0f blue:195.0f/255.0f alpha:1.0f]];
    [self showView];
    [self stopLoadingIndicator];
    
    
}

- (void)showView
{
    noCount = 0;
    noCount2 = 0;
    self.data = [[NSMutableArray alloc] init];
    self.data2 = [[NSMutableArray alloc] init];
    self.data3 = [[NSMutableArray alloc] init];
    y = -1;
    
    // load user font
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userFont.xml"];
    NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
    if(readData)
    {
        NSString *fontString = readData[@"fontsize"];
        myFont = [fontString intValue];
    }
    
    DoctorAppAppDelegate *appDelegate = (DoctorAppAppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.showVC = self;
    [self getCases];
    appDelegate.globalCases = self.casesWithOrder;
    
    
    
    months = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
    if (!selectedIndexPaths1) {
        selectedIndexPaths1 = [NSMutableArray new];
    }
    if (!selectedIndexPaths2) {
        selectedIndexPaths2 = [NSMutableArray new];
    }
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"NOTIFICATION";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    //    self.timeCount.delegate = self;
    //    [self.timeCount start];
    
    self.notificationBtView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width / 3, 60)];
    [self.notificationBtView setBackgroundColor: [UIColor whiteColor]];
    [self.buttonView addSubview:self.notificationBtView];
    self.notificationBtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width / 3, 20)];
    self.notificationBtLabel.text = @"NOTIFICATION";
    self.notificationBtLabel.textAlignment = NSTextAlignmentCenter;
    self.notificationBtLabel.font = [UIFont boldSystemFontOfSize:12];
    self.notificationBtLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0/255.0f blue:195.0f/255.0f alpha:1.0f];
    [self.notificationBtView addSubview:self.notificationBtLabel];
    self.notificationBtImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 6 - 25, 5, 50, 45)];
    self.notificationBtImage.image = [UIImage imageNamed:@"m-01"];
    [self.notificationBtView addSubview:self.notificationBtImage];
    UITapGestureRecognizer *tapNotification =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showNotification)];
    [self.notificationBtView addGestureRecognizer:tapNotification];
    
    self.caselistBtView = [[UIView alloc] initWithFrame: CGRectMake(self.view.bounds.size.width / 3, 0, self.view.bounds.size.width / 3, 60)];
    [self.caselistBtView setBackgroundColor: [UIColor whiteColor]];
    [self.buttonView addSubview:self.caselistBtView];
    self.caselistBtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width / 3, 20)];
    self.caselistBtLabel.text = @"CASE LIST";
    self.caselistBtLabel.textAlignment = NSTextAlignmentCenter;
    self.caselistBtLabel.font = [UIFont boldSystemFontOfSize:12];
    self.caselistBtLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    [self.caselistBtView addSubview:self.caselistBtLabel];
    self.caselistBtImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 6 - 25, 5, 50, 45)];
    self.caselistBtImage.image = [UIImage imageNamed:@"m-03"];
    [self.caselistBtView addSubview:self.caselistBtImage];
    UITapGestureRecognizer *tapCaselist =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showCaselist)];
    [self.caselistBtView addGestureRecognizer:tapCaselist];
    
    self.noteBtView = [[UIView alloc] initWithFrame: CGRectMake(2 * self.view.bounds.size.width / 3, 0, self.view.bounds.size.width / 3, 60)];
    [self.noteBtView setBackgroundColor: [UIColor whiteColor]];
    [self.buttonView addSubview:self.noteBtView];
    self.noteBtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width / 3, 20)];
    self.noteBtLabel.text = @"NOTE";
    self.noteBtLabel.textAlignment = NSTextAlignmentCenter;
    self.noteBtLabel.font = [UIFont boldSystemFontOfSize:12];
    self.noteBtLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    [self.noteBtView addSubview:self.noteBtLabel];
    self.noteBtImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 6 - 35, 0, 70, 50)];
    self.noteBtImage.image = [UIImage imageNamed:@"note-bt-gray"];
    [self.noteBtView addSubview:self.noteBtImage];
    UITapGestureRecognizer *tapNote =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showNote)];
    [self.noteBtView addGestureRecognizer:tapNote];
    
    
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, self.buttonView.frame.size.width, 5.0f);
    TopBorder.backgroundColor = [UIColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:198.0f/255.0f alpha:1.0f].CGColor;
    [self.buttonView.layer addSublayer:TopBorder];
    
    CALayer *RightBorder1 = [CALayer layer];
    RightBorder1.frame = CGRectMake(self.notificationBtView.frame.size.width - 2, 0.0f, 2.0f, 60.0f);
    RightBorder1.backgroundColor = [UIColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:198.0f/255.0f alpha:1.0f].CGColor;
    
    CALayer *RightBorder2 = [CALayer layer];
    RightBorder2.frame = CGRectMake(self.notificationBtView.frame.size.width - 2, 0.0f, 2.0f, 60.0f);
    RightBorder2.backgroundColor = [UIColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:198.0f/255.0f alpha:1.0f].CGColor;
    
    [self.notificationBtView.layer addSublayer:RightBorder1];
    [self.caselistBtView.layer addSublayer:RightBorder2];
    
    
    
    
    
    
    
    //    [self.timeCount startWithEndingBlock:^(NSTimeInterval countTime) {
    //        DoctorAppAppDelegate *appDelegate = (DoctorAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    //        appDelegate.globalTimeInteger = countTime;
    //        NSString *inStr = [NSString stringWithFormat: @"%d", (int)countTime];
    //        NSLog(inStr);
    //    }];
    //
    self.caselist.separatorColor = [UIColor clearColor];
    
    
    if([self.casesWithOrder count] > 0)
    {
        for(int i = 0; i < [self.casesWithOrder count]; i++)
        {
            NSDictionary *caseDictionary = [self.casesWithOrder objectAtIndex:i];
            if([caseDictionary[@"status"] isEqualToString:@"2"])
            {
                noCount2++;
                NSString *caseid = caseDictionary[@"_id"];
                NSString *firstname = caseDictionary[@"belong_to"][@"firstname"][@"en_us"];
                NSString *lastname = caseDictionary[@"belong_to"][@"lastname"][@"en_us"];
                NSString *title = [NSString stringWithFormat:@"%@ %@",firstname, lastname];
                NSString *discharge_input = caseDictionary[@"original_diagnosis"][@"en_us"];
                NSArray *infoArray = caseDictionary[@"relevant_medical_info"];
                NSString *summary_input;
                if([infoArray count] > 0)
                {
                    for(int i = 0; i < [infoArray count]; i++)
                    {
                        NSDictionary *d = [infoArray objectAtIndex:i];
                        NSString *label = d[@"label"];
                        if([label isEqualToString:@"1"])
                            summary_input = d[@"en_us"];
                            
                    }
                }
                
                NSString *summary = [NSString stringWithFormat:@"%@",discharge_input];
                
                NSString *startdate = caseDictionary[@"create_date"];
                NSDateFormatter* df = [[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSDate *someDateInUTC = [df dateFromString:startdate];
                NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
                NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateInLocalTimezone];
                
                NSInteger year = [components year];
                NSInteger month = [components month];
                NSInteger day = [components day];
                
                NSString *date = [NSString stringWithFormat:@"%@ %d %d", [months objectAtIndex:(month - 1)], day, year];
                NSString *time = [NSString stringWithFormat:@"%d", day];
                
                PendingCase *pCase1 = [[PendingCase alloc] init];
                [pCase1 setData:summary Title:title Date:date Time:time WithId:caseid];
                [self.data2 addObject:pCase1];
            }
            else if(([caseDictionary[@"status"] isEqualToString:@"3"] || [caseDictionary[@"status"] isEqualToString:@"4"]))
            {
                
                NSArray *arr = caseDictionary[@"notifications"];
                if([arr count] > 0)
                {
                    noCount = noCount + [arr count];
                    NSString *caseid = caseDictionary[@"_id"];
                    NSArray *notifications = caseDictionary[@"notifications"];
                    NSString *firstname = caseDictionary[@"belong_to"][@"firstname"][@"en_us"];
                    NSString *lastname = caseDictionary[@"belong_to"][@"lastname"][@"en_us"];
                    NSString *title = [NSString stringWithFormat:@"%@ %@",firstname, lastname];
                    
                    NSString *startdate = caseDictionary[@"start_date"];
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                    NSDate *someDateInUTC = [df dateFromString:startdate];
                    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
                    NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateInLocalTimezone];
                    
                    NSInteger year = [components year];
                    NSInteger month = [components month];
                    NSInteger day = [components day];
                    
                    NSString *date = [NSString stringWithFormat:@"%@ %d %d", [months objectAtIndex:(month - 1)], day, year];
                    NSString *time = [NSString stringWithFormat:@"%d", day];
                    
                    MyCase *mCase1 = [[MyCase alloc] init];
                    BOOL istop = YES;
                    if ([caseDictionary[@"status"] isEqualToString:@"3"])
                        istop = NO;
                    [mCase1 setData:notifications Title:title Date:date Time:time IsTop:istop WithId:caseid];
                    [self.data addObject:mCase1];
                }
                
            }
        }
    }
    
    self.txtView1 = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 20, 20)];
    [self.txtView1 setText:[NSString stringWithFormat:@"%d",noCount]];
    [self.txtView1 setTextColor:[UIColor whiteColor]];
    [self.txtView1 setFont:[UIFont boldSystemFontOfSize:12]];
    [self.txtView1 setBackgroundColor:[UIColor redColor]];
    [self.txtView1 setNumberOfLines:1];
    [self.txtView1 setTextAlignment:NSTextAlignmentCenter];
    [self.button1 addSubview: self.txtView1];
    
    self.txtView2 = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 20, 20)];
    [self.txtView2 setText:[NSString stringWithFormat:@"%d",noCount2]];
    [self.txtView2 setTextColor:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
    [self.txtView2 setFont:[UIFont boldSystemFontOfSize:12]];
    [self.txtView2 setBackgroundColor:[UIColor whiteColor]];
    [self.txtView2 setNumberOfLines:1];
    [self.txtView2 setTextAlignment:NSTextAlignmentCenter];
    [self.button2 addSubview: self.txtView2];
    
    [self.button1 addTarget:self action:@selector(setfirst) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(setsecond) forControlEvents:UIControlEventTouchUpInside];
    
    if(tabNumber == 0)
        [self showNotification];
    else if(tabNumber == 1)
        [self showCaselist];
    else if(tabNumber == 2)
        [self showNote];
    if(flag)
        [self setfirst];
    else
        [self setsecond];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setfirst
{
    [self.button1 setBackgroundColor:[UIColor whiteColor]];
    [self.button1 setTitleColor:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.txtView1 setBackgroundColor:[UIColor redColor]];
    [self.txtView1 setTextColor:[UIColor whiteColor]];
    
    [self.button2 setBackgroundColor:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.txtView2 setBackgroundColor:[UIColor whiteColor]];
    [self.txtView2 setTextColor:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
    
    flag = true;
    [self.caselist registerClass:[MyCaseCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self.caselist reloadData];
    [self.caselist reloadData];
    [self.caselist scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)setsecond
{
//    NSLog(@"%@",self.data2);
    [self.button2 setBackgroundColor:[UIColor whiteColor]];
    [self.button2 setTitleColor:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.txtView2 setBackgroundColor:[UIColor redColor]];
    [self.txtView2 setTextColor:[UIColor whiteColor]];
    
    [self.button1 setBackgroundColor:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.txtView1 setBackgroundColor:[UIColor whiteColor]];
    [self.txtView1 setTextColor:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
    
    flag = false;
    [self.caselist registerClass:[PendingCaseCell class] forCellReuseIdentifier:cellIdentifier2];
    [self.caselist reloadData];
    [self.caselist reloadData];
    [self.caselist scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(makeEmpty)
        return 0;
    if(flag)
        return [self.data count];
    else
        return [self.data2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(flag) {
        MyCaseCell *cell = (MyCaseCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[MyCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        BOOL isSelected = [selectedIndexPaths1 containsObject:indexPath];
        MyCase *mycase = [self.data objectAtIndex:indexPath.row];
        cell.titleLabel.text = [mycase getTitle];
        cell.timeLabel.text = [mycase getTime];
        cell.dateLabel.text = [mycase getDate];
        if([mycase getTop])
            [cell.dateImgageView setImage: [UIImage imageNamed:@"top-notification"]];
        else
            [cell.dateImgageView setImage: [UIImage imageNamed:@"notification"]];
        [cell.extendButton addTarget:self action:@selector(seeMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.extendButton setTag:indexPath.row];
        if(isSelected) {
            int h = [mycase getNotifications].count * 50;
            CGRect frame = [cell frame];
            frame.size.height = 90 + h;
            cell.frame = frame;
            
            CGRect frame2 = [cell.extendView frame];
            frame2.size.height = h + 20;
            cell.extendView.frame = frame2;
            cell.extendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 20, 20)];

            [cell.extendImageView setImage:[UIImage imageNamed:@"downarrow"]];
            cell.extendImageView.contentMode = UIViewContentModeBottom;
            [cell.extendView addSubview:cell.extendImageView];
            for(int i = 0; i < [[mycase getNotifications] count]; i++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, i * 50 + 20, 200, 50)];
                NSDictionary *d = [[mycase getNotifications] objectAtIndex:i];
                NSString *startdate = d[@"date"];
                NSDateFormatter* df = [[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSDate *someDateInUTC = [df dateFromString:startdate];
                NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
                NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateInLocalTimezone];
                
                NSInteger year = [components year];
                NSInteger month = [components month];
                NSInteger day = [components day];
                
                NSString *date = [NSString stringWithFormat:@"%@ %d %d", [months objectAtIndex:(month - 1)], day, year];
                NSString *content = d[@"content"];
                if([content isEqualToString:@"0"])
                    content = @"Case created";
                else if([content isEqualToString:@"1"])
                    content = @"Case setup done";
                else if([content isEqualToString:@"11"])
                    content = @"Case accepted";
                else if([content isEqualToString:@"12"])
                    content = @"Comments made";
                else if([content isEqualToString:@"13"])
                    content = @"Team comments made";
                else if([content isEqualToString:@"14"])
                    content = @"Notes for patient made";
                NSString *author = [NSString stringWithFormat:@"%@ %@",d[@"name"][@"firstname"][@"en_us"],d[@"name"][@"lastname"][@"en_us"]];
                label.text = [NSString stringWithFormat:@"%@\n    By %@\n    %@",content,author,date];
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.numberOfLines = 0;
                [label setFont:[UIFont systemFontOfSize:myFont]];
                [cell.extendView addSubview:label];
            }
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39 + h , 240, 1)];
            [line setBackgroundColor:[UIColor lightGrayColor]];
            [cell.extendView addSubview:line];
            
            [cell.extendButton setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        }
        else {
            CGRect frame = [cell frame];
            frame.size.height = 70;
            cell.frame = frame;
            [cell.extendButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        PendingCaseCell *cell = (PendingCaseCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if(cell == nil) {
            cell = [[PendingCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
        }
        BOOL isSelected = [selectedIndexPaths2 containsObject:indexPath];
        PendingCase *pendingcase = [self.data2 objectAtIndex:indexPath.row];
        cell.titleLabel.text = [pendingcase getTitle];
        cell.timeLabel.text = [pendingcase getTime];
        cell.dateLabel.text = [pendingcase getDate];
        [cell.dateImgageView setImage: [UIImage imageNamed:@"notification"]];
        [cell.extendButton addTarget:self action:@selector(seeMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.extendButton setTag:indexPath.row];
        [cell.acceptBt setTag:indexPath.row];
        [cell.declineBt setTag:indexPath.row];
        [cell.acceptBt addTarget:self action:@selector(acceptCase:) forControlEvents:UIControlEventTouchUpInside];
        [cell.acceptBt addTarget:self action:@selector(seeMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.declineBt addTarget:self action:@selector(declineCase:) forControlEvents:UIControlEventTouchUpInside];
        [cell.declineBt addTarget:self action:@selector(seeMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        if(isSelected) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 1)];
            label.text = [self stringByConvertingHTMLToPlainText:[pendingcase getSummary]];
            label.font = [UIFont systemFontOfSize:myFont];
            [label setNumberOfLines:0];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize constraint = CGSizeMake(200, 20000.0f);
            CGSize size = [label sizeThatFits:constraint];
            [label setFrame:CGRectMake(20, 20, 200, size.height)];
            
            CGRect frame = [cell frame];
            frame.size.height = 140 + size.height;
            cell.frame = frame;
            
            CGRect frame2 = [cell.extendView frame];
            frame2.size.height = 20 + size.height;
            cell.extendView.frame = frame2;
            cell.extendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 20, 20)];
            
            [cell.extendImageView setImage:[UIImage imageNamed:@"downarrow"]];
            cell.extendImageView.contentMode = UIViewContentModeBottom;
            [cell.extendView addSubview:cell.extendImageView];
            
            [cell.extendView addSubview:label];
            
            [cell.acceptBt setFrame: CGRectMake(120, 100 + size.height, 50, 20)];
            [cell.acceptBt setTitle:@"Accept" forState:UIControlStateNormal];
            [cell.acceptBt.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
            [cell.acceptBt setBackgroundColor:[UIColor colorWithRed:70.0f/255.0f green:189.0f/255.0f blue:63.0f/255.0f alpha:1.0f]];
            CALayer *btnLayer = [cell.acceptBt layer];
            [btnLayer setMasksToBounds:YES];
            [btnLayer setCornerRadius:5.0f];
            
            
            [cell.declineBt setFrame: CGRectMake(180, 100 + size.height, 50, 20)];
            [cell.declineBt setTitle:@"Reject" forState:UIControlStateNormal];
            [cell.declineBt.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
            [cell.declineBt setBackgroundColor:[UIColor colorWithRed:107.0f/255.0f green:128.0f/255.0f blue:151.0f/255.0f alpha:1.0f]];
            CALayer *btnLayer2 = [cell.declineBt layer];
            [btnLayer2 setMasksToBounds:YES];
            [btnLayer2 setCornerRadius:5.0f];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 69 + size.height, 240, 1)];
            [line setBackgroundColor:[UIColor lightGrayColor]];
            [cell.extendView addSubview:line];
            
            [cell.extendButton setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        }
        else {
            CGRect frame = [cell frame];
            frame.size.height = 70;
            cell.frame = frame;
            [cell.extendButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [self tableView:self.caselist cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;

}

- (void)seeMoreButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [self addOrRemoveSelectedIndexPath:indexPath];
}

- (void)addOrRemoveSelectedIndexPath:(NSIndexPath *)indexPath
{
    if(flag) {
        
        BOOL containsIndexPath = [selectedIndexPaths1 containsObject:indexPath];
        
        if (containsIndexPath) {
            [selectedIndexPaths1 removeObject:indexPath];
        }else{
            [selectedIndexPaths1 addObject:indexPath];
        }
    }
    else {
        
        BOOL containsIndexPath = [selectedIndexPaths2 containsObject:indexPath];
        
        if (containsIndexPath) {
            [selectedIndexPaths2 removeObject:indexPath];
        }else{
            [selectedIndexPaths2 addObject:indexPath];
        }
    }
//    NSLog(@"reload: %d", indexPath.row);
    [self.caselist reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.caselist)
    {
        x = indexPath.row;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(flag)
            
            [self performSegueWithIdentifier:@"detailViewController" sender:self];
        else
            [self performSegueWithIdentifier:@"detailViewController2" sender:self];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailViewController"]) {
        CaseDetailVC *targetVC = (CaseDetailVC*)segue.destinationViewController;
        MyCase *mCase1 = [self.data objectAtIndex:x];
        targetVC.caseid = [mCase1 getCaseid];
    }
    else if([[segue identifier] isEqualToString:@"detailViewController2"]) {
        PendingCaseDetailVC *targetVC = (PendingCaseDetailVC*)segue.destinationViewController;
        PendingCase *pCase1 = [self.data2 objectAtIndex:x];
        targetVC.caseid = [pCase1 getCaseid];
    }
    else if([[segue identifier] isEqualToString:@"detailViewController3"]) {
        CompleteCaseDetailVC *targetVC = (CompleteCaseDetailVC*)segue.destinationViewController;
        NSDictionary *cCase1 = [self.completeCaselist objectAtIndex:x];
        targetVC.caseid = cCase1[@"_id"];
    }
    else if([[segue identifier] isEqualToString:@"NoteVC"]) {
        NoteVC *targetVC = (NoteVC*)segue.destinationViewController;
        targetVC.keyString = [NSString stringWithFormat:@"%d",y];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)declineCase:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    self.view1 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view1 setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f]];
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 150 ) / 2, 250, 150)];
    [self.view1 addSubview:self.view2];
    [self.view2 setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 250, 70)];
    [label setText:@"Please confirm that you want to reject the case."];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setEditable:NO];
    [label setSelectable:NO];
    [self.view2 addSubview:label];
    
    UIButton *bt1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 105, 100, 30)];
    [bt1 setTitle:@"Do not reject" forState:UIControlStateNormal];
    [bt1 setBackgroundColor:[UIColor lightGrayColor]];
    [bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt1.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt1 addTarget:self action:@selector(closeView2) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt1];
    
    UIButton *bt2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 105, 80, 30)];
    bt2.tag = bt.tag;
    [bt2 setTitle:@"Reject" forState:UIControlStateNormal];
    [bt2 setBackgroundColor:[UIColor darkGrayColor]];
    [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt2 addTarget:self action:@selector(decline:) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt2];
}

- (void)acceptCase:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    self.view1 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view1 setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f]];
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 150 ) / 2, 250, 150)];
    [self.view1 addSubview:self.view2];
    [self.view2 setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 250, 70)];
    [label setText:@"Please confirm that you want to accept the case."];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setEditable:NO];
    [label setSelectable:NO];
    [self.view2 addSubview:label];
    
    UIButton *bt1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 105, 100, 30)];
    [bt1 setTitle:@"Do not accept" forState:UIControlStateNormal];
    [bt1 setBackgroundColor:[UIColor lightGrayColor]];
    [bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt1.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt1 addTarget:self action:@selector(closeView2) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt1];
    
    UIButton *bt2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 105, 80, 30)];
    bt2.tag = bt.tag;
    [bt2 setTitle:@"Accept" forState:UIControlStateNormal];
    [bt2 setBackgroundColor:[UIColor darkGrayColor]];
    [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt2 addTarget:self action:@selector(accept1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt2];
}

- (void)closeView1:(id)sender
{
    [self.view1 removeFromSuperview];
    selectedIndexPaths1 = [NSMutableArray new];
    selectedIndexPaths2 = [NSMutableArray new];
    self.data2 = nil;
    makeEmpty = YES;
    [self.caselist reloadData];
    makeEmpty = NO;
    [self showView];
}

- (void)closeView2
{
    [self.view1 removeFromSuperview];
}

- (void)accept1:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    int x = bt.tag;
    NSDictionary *pendingcase = [self.pendingCaselist objectAtIndex:x];
    NSString *caseid = pendingcase[@"_id"];
    NSDictionary *postDict = [NSDictionary dictionaryWithObject:caseid forKey:@"case_id"];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/doctor/accept"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:5];
    
    NSHTTPURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"~~~~~ Status code: %d", [response statusCode]);
    
    if([response statusCode] == 200)
    {
        [self.view1 removeFromSuperview];
        self.view1 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.view1 setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f]];
        [self.view addSubview:self.view1];
        
        self.view2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 150 ) / 2, 250, 150)];
        [self.view1 addSubview:self.view2];
        [self.view2 setBackgroundColor:[UIColor grayColor]];
        
        UITextView *label1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 250, 70)];
        [label1 setText:@"This message serves as a confirmation that you have successfully accept the case."];
        [label1 setFont:[UIFont systemFontOfSize:12]];
        [label1 setTextColor:[UIColor whiteColor]];
        [label1 setBackgroundColor:[UIColor grayColor]];
        [label1 setTextAlignment:NSTextAlignmentCenter];
        [label1 setEditable:NO];
        [label1 setSelectable:NO];
        [self.view2 addSubview:label1];
        
//        UITextView *label2 = [[UITextView alloc] initWithFrame:CGRectMake(70, 105, 110, 30)];
//        [label2 setText:@"Case #123"];
//        [label2 setFont:[UIFont systemFontOfSize:12]];
//        [label2 setTextColor:[UIColor whiteColor]];
//        [label2 setTextAlignment:NSTextAlignmentCenter];
//        [label2 setBackgroundColor:[UIColor darkGrayColor]];
//        [label2 setEditable:NO];
//        [label2 setSelectable:NO];
//        [self.view2 addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, 400, 250, 40)];
        [label3 setText:@"Tap to close"];
        [label3 setTextAlignment:NSTextAlignmentCenter];
        [label3 setFont:[UIFont systemFontOfSize:16]];
        [label3 setTextColor:[UIColor whiteColor]];
        [self.view1 addSubview:label3];
        
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(closeView1:)];
        tap.view.tag = bt.tag;
        [self.view1 addGestureRecognizer:tap];
    }
    else
    {
        [self.view1 removeFromSuperview];
        [self popNCError];
    }
}

- (void)decline:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    int x = bt.tag;
    NSDictionary *pendingcase = [self.pendingCaselist objectAtIndex:x];
    NSString *caseid = pendingcase[@"_id"];
    NSDictionary *postDict = [NSDictionary dictionaryWithObject:caseid forKey:@"case_id"];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/doctor/reject"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:5];
    
    NSHTTPURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"~~~~~ Status code: %d", [response statusCode]);
    
    if([response statusCode] == 200)
    {
        [self.view1 removeFromSuperview];
        self.view1 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.view1 setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f]];
        [self.view addSubview:self.view1];
        
        self.view2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 150 ) / 2, 250, 150)];
        [self.view1 addSubview:self.view2];
        [self.view2 setBackgroundColor:[UIColor grayColor]];
        
        UITextView *label1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 250, 70)];
        [label1 setText:@"This message serves as a confirmation that you have successfully reject the case."];
        [label1 setFont:[UIFont systemFontOfSize:12]];
        [label1 setTextColor:[UIColor whiteColor]];
        [label1 setBackgroundColor:[UIColor grayColor]];
        [label1 setTextAlignment:NSTextAlignmentCenter];
        [label1 setUserInteractionEnabled:NO];
        [label1 setEditable:NO];
        [label1 setSelectable:NO];
        [self.view2 addSubview:label1];
        
//        UITextView *label2 = [[UITextView alloc] initWithFrame:CGRectMake(70, 105, 110, 30)];
//        [label2 setText:@"Case #123"];
//        [label2 setFont:[UIFont systemFontOfSize:12]];
//        [label2 setTextColor:[UIColor whiteColor]];
//        [label2 setTextAlignment:NSTextAlignmentCenter];
//        [label2 setBackgroundColor:[UIColor darkGrayColor]];
//        [label2 setUserInteractionEnabled:NO];
//        [label2 setEditable:NO];
//        [label2 setSelectable:NO];
//        [self.view2 addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, 400, 250, 40)];
        [label3 setText:@"Tap to close"];
        [label3 setTextAlignment:NSTextAlignmentCenter];
        [label3 setFont:[UIFont systemFontOfSize:16]];
        [label3 setTextColor:[UIColor whiteColor]];
        [self.view1 addSubview:label3];
        
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(closeView1:)];
        tap.view.tag = bt.tag;
        [self.view1 addGestureRecognizer:tap];
    }
    else
    {
        [self.view1 removeFromSuperview];
        [self popNCError];
    }
}

- (void)showNotification
{
    tabNumber = 0;
    if([[self.bodyView subviews] containsObject:self.caselistView]) {
        [self.caselistView removeFromSuperview];
    }
    if([[self.bodyView subviews] containsObject:self.noteView]) {
        [self.noteView removeFromSuperview];
    }
    
    self.notificationBtLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0/255.0f blue:195.0f/255.0f alpha:1.0f];
    self.notificationBtImage.image = [UIImage imageNamed:@"m-01"];
    self.caselistBtLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    self.caselistBtImage.image = [UIImage imageNamed:@"m-03"];
    self.noteBtLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    self.noteBtImage.image = [UIImage imageNamed:@"note-bt-gray"];
    self.navigationItem.rightBarButtonItem = nil;
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"NOTIFICATION";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

- (void)showCaselist
{
    tabNumber = 1;
    if([[self.bodyView subviews] containsObject:self.noteView]) {
        [self.noteView removeFromSuperview];
    }
    if(![[self.bodyView subviews] containsObject:self.caselistView]) {
        self.caselistView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height)];
        self.caselistView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        [self.bodyView addSubview: self.caselistView];
    }
    self.notificationBtLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    self.notificationBtImage.image = [UIImage imageNamed:@"m-02"];
    self.caselistBtLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0/255.0f blue:195.0f/255.0f alpha:1.0f];
    self.caselistBtImage.image = [UIImage imageNamed:@"m-04"];
    self.noteBtLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    self.noteBtImage.image = [UIImage imageNamed:@"note-bt-gray"];
    self.navigationItem.rightBarButtonItem = nil;
    
    self.caseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, self.caselistView.frame.size.width - 40, self.caselistView.frame.size.height - 40)];
    self.caseScrollView.backgroundColor = [UIColor whiteColor];
    [self.caselistView addSubview:self.caseScrollView];
    
    if(topSelected)
        self.topPriorityCaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, [self.topPriorityCaselist count] * 40 + 60)];
    else
        self.topPriorityCaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
    
    self.topPriorityCaseView.backgroundColor = [UIColor whiteColor];
    
    UILabel *topPriorityCaseTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    topPriorityCaseTitle.text = @"    Top Priority Cases";
    topPriorityCaseTitle.font = [UIFont boldSystemFontOfSize:14];
    topPriorityCaseTitle.textColor = [UIColor whiteColor];
    topPriorityCaseTitle.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [self.topPriorityCaseView addSubview:topPriorityCaseTitle];
    
    UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 5, 30, 30)];
    topPriorityCaseTitle.userInteractionEnabled = YES;
    if(topSelected)
        [topButton setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    else
        [topButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(extendTop) forControlEvents:UIControlEventTouchUpInside];
    [topPriorityCaseTitle addSubview:topButton];
    
    for(int i = 0; i < [self.topPriorityCaselist count]; i++)
    {
        NSDictionary *d = [self.topPriorityCaselist objectAtIndex:i];
        NSString *firstname = d[@"belong_to"][@"firstname"][@"en_us"];
        NSString *lastname = d[@"belong_to"][@"lastname"][@"en_us"];
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
        
        NSString *startdate = d[@"start_date"];
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *someDateInUTC = [df dateFromString:startdate];
        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateInLocalTimezone];
        
        NSInteger year = [components year];
        NSInteger month = [components month];
        NSInteger day = [components day];
        
        NSString *date = [NSString stringWithFormat:@"%@ %d %d", [months objectAtIndex:(month - 1)], day, year];
        
        NSString *title = [NSString stringWithFormat:@"%@      %@",name,date];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(20, 60 + i * 40, 240, 40)];
        bt.titleLabel.font = [UIFont systemFontOfSize:12];
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.tag = i;
        [bt addTarget:self action:@selector(viewcase:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i != ([self.topPriorityCaselist count] - 1))
        {
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 240, 1)];
            line1.backgroundColor = [UIColor lightGrayColor];
            [bt addSubview:line1];
        }
        [self.topPriorityCaseView addSubview: bt];
    }
    
    if(currentSelected)
        self.currentCaseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topPriorityCaseView.frame.origin.y + self.topPriorityCaseView.frame.size.height, 280, [self.currentCaselist count] * 40 + 60)];
    else
        self.currentCaseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topPriorityCaseView.frame.origin.y + self.topPriorityCaseView.frame.size.height, 280, 60)];
    self.currentCaseView.backgroundColor = [UIColor whiteColor];
    
    UILabel *currentCaseTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    currentCaseTitle.text = @"    Current Cases";
    currentCaseTitle.font = [UIFont boldSystemFontOfSize:14];
    currentCaseTitle.textColor = [UIColor whiteColor];
    currentCaseTitle.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [self.currentCaseView addSubview:currentCaseTitle];
    currentCaseTitle.userInteractionEnabled = YES;
    UIButton *currentButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 5, 30, 30)];
    if(currentSelected)
        [currentButton setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    else
        [currentButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [currentButton addTarget:self action:@selector(extendCurrent) forControlEvents:UIControlEventTouchUpInside];
    [currentCaseTitle addSubview:currentButton];

    for(int i = 0; i < [self.currentCaselist count]; i++)
    {
        NSDictionary *d = [self.currentCaselist objectAtIndex:i];
        NSString *firstname = d[@"belong_to"][@"firstname"][@"en_us"];
        NSString *lastname = d[@"belong_to"][@"lastname"][@"en_us"];
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
        
        NSString *startdate = d[@"start_date"];
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *someDateInUTC = [df dateFromString:startdate];
        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateInLocalTimezone];
        
        NSInteger year = [components year];
        NSInteger month = [components month];
        NSInteger day = [components day];
        
        NSString *date = [NSString stringWithFormat:@"%@ %d %d", [months objectAtIndex:(month - 1)], day, year];
        
        NSString *title = [NSString stringWithFormat:@"%@      %@",name,date];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(20, 60 + i * 40, 240, 40)];
        bt.titleLabel.font = [UIFont systemFontOfSize:12];
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.tag = i + [self.topPriorityCaselist count];
        [bt addTarget:self action:@selector(viewcase:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i != ([self.currentCaselist count] - 1))
        {
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 240, 1)];
            line1.backgroundColor = [UIColor lightGrayColor];
            [bt addSubview:line1];
        }
        
        
        [self.currentCaseView addSubview: bt];
    }
    
    if(pendingSelected)
        self.pendingCaseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentCaseView.frame.origin.y + self.currentCaseView.frame.size.height, 280, [self.pendingCaselist count] * 40 + 60)];
    else
        self.pendingCaseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentCaseView.frame.origin.y + self.currentCaseView.frame.size.height, 280, 60)];
    self.pendingCaseView.backgroundColor = [UIColor whiteColor];
    
    UILabel *pendingCaseTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    pendingCaseTitle.text = @"    Pending Cases";
    pendingCaseTitle.font = [UIFont boldSystemFontOfSize:14];
    pendingCaseTitle.textColor = [UIColor whiteColor];
    pendingCaseTitle.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [self.pendingCaseView addSubview:pendingCaseTitle];
    pendingCaseTitle.userInteractionEnabled = YES;
    UIButton *pendingButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 5, 30, 30)];
    if(pendingSelected)
        [pendingButton setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    else
        [pendingButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [pendingButton addTarget:self action:@selector(extendPending) forControlEvents:UIControlEventTouchUpInside];
    [pendingCaseTitle addSubview:pendingButton];
    
    for(int i = 0; i < [self.pendingCaselist count]; i++)
    {
        NSDictionary *d = [self.pendingCaselist objectAtIndex:i];
        NSString *firstname = d[@"belong_to"][@"firstname"][@"en_us"];
        NSString *lastname = d[@"belong_to"][@"lastname"][@"en_us"];
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
        
        NSString *startdate = d[@"start_date"];
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *someDateInUTC = [df dateFromString:startdate];
        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateInLocalTimezone];
        
        NSInteger year = [components year];
        NSInteger month = [components month];
        NSInteger day = [components day];
        
        NSString *date = [NSString stringWithFormat:@"%@ %d %d", [months objectAtIndex:(month - 1)], day, year];
        
        NSString *title = [NSString stringWithFormat:@"%@      %@",name,date];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(20, 60 + i * 40, 240, 40)];
        bt.titleLabel.font = [UIFont systemFontOfSize:12];
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        bt.backgroundColor = [UIColor greenColor];
        bt.tag = i;
        [bt addTarget:self action:@selector(viewpendingcase:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i != ([self.pendingCaselist count] - 1))
        {
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 240, 1)];
            line1.backgroundColor = [UIColor lightGrayColor];
            [bt addSubview:line1];
        }
        
        
        [self.pendingCaseView addSubview: bt];
    }
    
    if(completeSelected)
        self.completeCaseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.pendingCaseView.frame.origin.y + self.pendingCaseView.frame.size.height, 280, [self.completeCaselist count] * 40 + 60)];
    else
        self.completeCaseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.pendingCaseView.frame.origin.y + self.pendingCaseView.frame.size.height, 280, 60)];
    self.completeCaseView.backgroundColor = [UIColor whiteColor];
    
    UILabel *completeCaseTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    completeCaseTitle.text = @"    Complete Cases";
    completeCaseTitle.font = [UIFont boldSystemFontOfSize:14];
    completeCaseTitle.textColor = [UIColor whiteColor];
    completeCaseTitle.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [self.completeCaseView addSubview:completeCaseTitle];
    completeCaseTitle.userInteractionEnabled = YES;
    UIButton *completeButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 5, 30, 30)];
    if(completeSelected)
        [completeButton setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    else
        [completeButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(extendComplete) forControlEvents:UIControlEventTouchUpInside];
    [completeCaseTitle addSubview:completeButton];
    
    for(int i = 0; i < [self.completeCaselist count]; i++)
    {
        NSDictionary *d = [self.completeCaselist objectAtIndex:i];
        NSString *firstname = d[@"belong_to"][@"firstname"][@"en_us"];
        NSString *lastname = d[@"belong_to"][@"lastname"][@"en_us"];
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
        
        NSString *startdate = d[@"start_date"];
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *someDateInUTC = [df dateFromString:startdate];
        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateInLocalTimezone];
        
        NSInteger year = [components year];
        NSInteger month = [components month];
        NSInteger day = [components day];
        
        NSString *date = [NSString stringWithFormat:@"%@ %d %d", [months objectAtIndex:(month - 1)], day, year];
        
        NSString *title = [NSString stringWithFormat:@"%@      %@",name,date];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(20, 60 + i * 40, 240, 40)];
        bt.titleLabel.font = [UIFont systemFontOfSize:12];
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.tag = i;
        [bt addTarget:self action:@selector(viewcompletecase:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i != ([self.completeCaselist count] - 1))
        {
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 240, 1)];
            line1.backgroundColor = [UIColor lightGrayColor];
            [bt addSubview:line1];
        }
        
        [self.completeCaseView addSubview: bt];
    }

    [self.caseScrollView addSubview:self.topPriorityCaseView];
    [self.caseScrollView addSubview:self.currentCaseView];
    [self.caseScrollView addSubview:self.pendingCaseView];
    [self.caseScrollView addSubview:self.completeCaseView];
    
    float sizeOfContent = 0;
    UIView *lLast = [self.caseScrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    sizeOfContent = wd + ht;
    self.caseScrollView.contentSize = CGSizeMake(self.caseScrollView.frame.size.width, sizeOfContent);
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"CASE LIST";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

- (void)showNote
{
    self.data3 = [[NSMutableArray alloc] init];
    tabNumber = 2;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/doctorNotes.xml"];
    NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
    //    NSLog(@"the path is %@", path);
    if(readData)
    {
        for (NSString *key in readData)
        {
            NSDictionary *d = [readData objectForKey:key];
            [self.data3 addObject:d];
        }
    }
    if([[self.bodyView subviews] containsObject:self.caselistView]) {
        [self.caselistView removeFromSuperview];
    }
    if(![[self.bodyView subviews] containsObject:self.noteView]) {
        self.noteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height)];
        self.noteView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        [self.bodyView addSubview: self.noteView];
    }
    self.notificationBtLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    self.notificationBtImage.image = [UIImage imageNamed:@"m-02"];
    self.caselistBtLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    self.caselistBtImage.image = [UIImage imageNamed:@"m-03"];
    self.noteBtLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0/255.0f blue:195.0f/255.0f alpha:1.0f];
    self.noteBtImage.image = [UIImage imageNamed:@"note-bt-blue"];
    self.addNoteBt = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(addNote)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = self.addNoteBt;
    
    self.notelist = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, self.noteView.frame.size.width - 40, self.noteView.frame.size.height - 40)];
    self.notelist.backgroundColor = [UIColor whiteColor];
    [self.noteView addSubview:self.notelist];
    
    for(int i = 0; i < [self.data3 count]; i++) {
        NSDictionary *note = [self.data3 objectAtIndex:i];
        UIButton *noteRow = [[UIButton alloc] initWithFrame:CGRectMake(20, 50 * i + 1, self.notelist.frame.size.width - 60, 49)];
        UIButton *deleteBt = [[UIButton alloc] initWithFrame:CGRectMake(self.notelist.frame.size.width - 40, 50 * i + 15, 30, 30)];
        [deleteBt setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        
        [self.notelist addSubview:noteRow];
        [self.notelist addSubview:deleteBt];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, noteRow.frame.size.width - 80, 30)];
        title.text = note[@"text"];
        title.font = [UIFont systemFontOfSize:14];
        [noteRow addSubview:title];
//        title.backgroundColor = [UIColor greenColor];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(noteRow.frame.size.width - 65, 10, 60, 30)];
        NSString *timeString = note[@"time"];
        time.text = [timeString substringToIndex:10];
        time.font = [UIFont systemFontOfSize:10];
        [noteRow addSubview:time];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 50 * (i + 1), self.notelist.frame.size.width - 40, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.notelist addSubview:line];
        noteRow.tag = i;
        [noteRow addTarget:self action:@selector(viewNote:) forControlEvents:UIControlEventTouchUpInside];
        deleteBt.tag = i;
        [deleteBt addTarget:self action:@selector(deleteNote:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    self.notelist.contentSize = CGSizeMake(self.noteView.frame.size.width - 40, 50 * [self.data3 count]);
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"NOTE";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    float sizeOfContent = 0;
    UIView *lLast = [self.notelist.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    sizeOfContent = wd + ht;
    self.notelist.contentSize = CGSizeMake(self.notelist.frame.size.width, sizeOfContent);
}

- (void)addNote
{
    y = -1;
    [self performSegueWithIdentifier:@"NoteVC" sender:self];
}

- (void)viewNote:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    y = bt.tag;
    [self performSegueWithIdentifier:@"NoteVC" sender:self];
}

- (void)deleteNote:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    self.view1 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view1 setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f]];
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 150 ) / 2, 250, 150)];
    [self.view1 addSubview:self.view2];
    [self.view2 setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 250, 70)];
    [label setText:@"Are you sure you want to delete this note?"];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setEditable:NO];
    [label setSelectable:NO];
    [self.view2 addSubview:label];
    
    UIButton *bt1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 105, 80, 30)];
    [bt1 setTitle:@"Cancel" forState:UIControlStateNormal];
    [bt1 setBackgroundColor:[UIColor lightGrayColor]];
    [bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt1.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt1 addTarget:self action:@selector(closeView2) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt1];
    
    UIButton *bt2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 105, 80, 30)];
    bt2.tag = bt.tag;
    [bt2 setTitle:@"Delete" forState:UIControlStateNormal];
    [bt2 setBackgroundColor:[UIColor darkGrayColor]];
    [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt2 addTarget:self action:@selector(deleteANote:) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt2];
    
}

- (void)deleteANote:(id)sender
{
    [self.view1 removeFromSuperview];
    UIButton *bt = (UIButton *)sender;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/doctorNotes.xml"];
    NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *writeData = [[NSMutableDictionary alloc] init];
    if(readData)
    {
        int tmp = 0;
        for (NSString *key in readData)
        {
            //            NSLog(@"%d", bt.tag);
            //            NSLog(@"%d", tmp);
            if(!(tmp == bt.tag))
            {
                [writeData setObject:[readData objectForKey:key] forKey:key];
            }
            tmp++;
        }
        BOOL result = [[writeData copy] writeToFile: path atomically:YES];
        NSLog(@"%@", result ? @"delete note saved" : @"delete note not saved");
    }
    [self showNote];
}

- (void)getCases
{
    self.cases = [[NSMutableArray alloc] init];
    self.casesWithOrder = [[NSMutableArray alloc] init];
    self.topPriorityCaselist = [[NSMutableArray alloc] init];
    self.currentCaselist = [[NSMutableArray alloc] init];
    self.pendingCaselist = [[NSMutableArray alloc] init];
    self.completeCaselist = [[NSMutableArray alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/case/getcase"]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:5];
    NSURLResponse *requestResponse;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    if(jsonData != nil)
    {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:jsonData
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            if ([jsonObject isKindOfClass:[NSDictionary class]]){
                self.cases = [jsonObject[@"cases"] mutableCopy];
                NSArray *pendingarray = jsonObject[@"pending_case"];
                for(int i = 0; i < [pendingarray count]; i++)
                {
                    NSMutableDictionary *d = [[pendingarray objectAtIndex:i] mutableCopy];
                    d[@"status"] = @"2";
                    [self.cases addObject:d];
                }
            }
        }
    }
    
    else
    {
        [self popNCError];
    }
    
    if([self.cases count] > 0)
    {
        for(int i = 0; i < [self.cases count]; i++)
        {
            NSMutableDictionary * c = [[self.cases objectAtIndex:i] mutableCopy];
            NSString *status = c[@"status"];
            if([status isEqualToString:@"2"])
            {
                [self.pendingCaselist addObject:c];
            }
            else if([status isEqualToString:@"3"])
            {
                [self.currentCaselist addObject:c];
            }
            else if([status isEqualToString:@"4"])
            {
                [self.topPriorityCaselist addObject:c];
            }
            else if([status isEqualToString:@"5"])
            {
                [self.completeCaselist addObject:c];
            }
        }
        [self.casesWithOrder addObjectsFromArray:self.topPriorityCaselist];
        [self.casesWithOrder addObjectsFromArray:self.currentCaselist];
        [self.casesWithOrder addObjectsFromArray:self.pendingCaselist];
        [self.casesWithOrder addObjectsFromArray:self.completeCaselist];
    }
}

- (NSString *)stringByConvertingHTMLToPlainText: (NSString *)myHTML
{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:[myHTML dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    return [attrString string];
}

- (void)viewcase:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    x = bt.tag;
    [self performSegueWithIdentifier:@"detailViewController" sender:self];
}

- (void)viewpendingcase:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    x = bt.tag;
    [self performSegueWithIdentifier:@"detailViewController2" sender:self];
}

- (void)viewcompletecase:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    x = bt.tag;
    [self performSegueWithIdentifier:@"detailViewController3" sender:self];
}

- (void)popNCError
{
    NSString *errorMessage = @"Please check your internet connnection then try again.";
    if([self currentNetworkStatus])
    {
        errorMessage = @"Sorry for the inconvenience that our service is currently under maintenance. Please retry after a while. Thank you.";
    }
    UIAlertView *alertView;
    alertView = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:errorMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
    [alertView show];
}

- (BOOL)currentNetworkStatus
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"%@", @"Button Cancel Pressed");
            break;
        case 1:
            NSLog(@"%@", @"Button Retry Pressed");
            [self showView];
            break;
            
        default:
            break;
    }
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

- (void)extendTop
{
    if(topSelected)
        topSelected = false;
    else
        topSelected = true;
    [self showCaselist];
}

- (void)extendCurrent
{
    if(currentSelected)
        currentSelected = false;
    else
        currentSelected = true;
    [self showCaselist];
}

- (void)extendPending
{
    if(pendingSelected)
        pendingSelected = false;
    else
        pendingSelected = true;
    [self showCaselist];
}

- (void)extendComplete
{
    if(completeSelected)
        completeSelected = false;
    else
        completeSelected = true;
    [self showCaselist];
}

@end
