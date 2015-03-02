//
//  PendingCaseDetailVC.m
//  DoctorApp
//
//  Created by Tao Zong on 10/24/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "PendingCaseDetailVC.h"
#import "DoctorAppAppDelegate.h"
#import "DocumentVC.h"
#import "Reachability.h"

@interface PendingCaseDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIView *view1;
@property UIView *view2;
@property (strong, nonatomic) NSDictionary *pendingCase;
@end

@implementation PendingCaseDetailVC
static int x;
static int myFont = 10;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startLoadingIndicator];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.bounces = NO;
    // load user font
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userFont.xml"];
    NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
    if(readData)
    {
        NSString *fontString = readData[@"fontsize"];
        myFont = [fontString intValue];
    }
    
    [self getCase];
    
    //    NSLog(@"%@",self.pendingCase);
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25, 25)];
    UIImage *backImage = [UIImage imageNamed:@"LArrow.png"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *acceptBt =[[UIButton alloc] init];
    acceptBt.frame = CGRectMake(0, 0, 50, 25);
    [acceptBt setTitle:@"Accept" forState:UIControlStateNormal];
    acceptBt.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [acceptBt setBackgroundColor:[UIColor colorWithRed:70.0f/255.0f green:189.0f/255.0f blue:63.0f/255.0f alpha:1.0f]];
    [acceptBt addTarget:self action:@selector(acceptCase:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rejectBt =[[UIButton alloc] init];
    rejectBt.frame = CGRectMake(0, 0, 50, 25);
    [rejectBt setTitle:@"Reject" forState:UIControlStateNormal];
    rejectBt.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [rejectBt setBackgroundColor:[UIColor colorWithRed:107.0f/255.0f green:128.0f/255.0f blue:151.0f/255.0f alpha:1.0f]];
    [rejectBt addTarget:self action:@selector(declineCase:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *existingButtons = [[NSMutableArray alloc] initWithArray:[self.navigationItem rightBarButtonItems]];
    [existingButtons addObject:[[UIBarButtonItem alloc] initWithCustomView:acceptBt]];
    [existingButtons addObject:[[UIBarButtonItem alloc] initWithCustomView:rejectBt]];
    [self.navigationItem setRightBarButtonItems:(NSArray *)existingButtons];
    
    UIView *personalInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
    personalInfoView.backgroundColor = [UIColor whiteColor];
    UILabel *personalInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    personalInfoLabel.text = @"    PERSONAL INFO";
    personalInfoLabel.font = [UIFont systemFontOfSize:14];
    personalInfoLabel.textColor = [UIColor whiteColor];
    personalInfoLabel.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [personalInfoView addSubview:personalInfoLabel];
    
    //    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 280, 2)];
    //    line1.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    //    [personalInfoView addSubview:line1];
    
    UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 90, 30)];
    nameTitle.text = @"Name :";
    nameTitle.font = [UIFont boldSystemFontOfSize:myFont];
    nameTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:nameTitle];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, 160, 30)];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.pendingCase[@"case"][@"belong_to"][@"firstname"][@"en_us"],self.pendingCase[@"case"][@"belong_to"][@"lastname"][@"en_us"]];
    nameLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:nameLabel];
    
    UILabel *sexTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 90, 30)];
    sexTitle.text = @"Sex :";
    sexTitle.font = [UIFont boldSystemFontOfSize:myFont];
    sexTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:sexTitle];
    
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 75, 160, 30)];
    NSString *sexString = self.pendingCase[@"case"][@"patient_info"][@"gender"];
    sexLabel.text = [sexString capitalizedString];
    sexLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:sexLabel];
    
    UILabel *raceTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, 90, 30)];
    raceTitle.text = @"Ethnicity/Race :";
    raceTitle.font = [UIFont boldSystemFontOfSize:myFont];
    raceTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:raceTitle];
    
    UILabel *raceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 105, 160, 30)];
    NSString *raceString = self.pendingCase[@"case"][@"patient_info"][@"ethnicity"];
    raceLabel.text = [raceString capitalizedString];
    raceLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:raceLabel];
    
    UILabel *dobTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 135, 90, 30)];
    dobTitle.text = @"DOB :";
    dobTitle.font = [UIFont boldSystemFontOfSize:myFont];
    dobTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:dobTitle];
    
    UILabel *dobLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 135, 160, 30)];
    NSString *dobString = @"";
    NSString *yearString = self.pendingCase[@"case"][@"patient_info"][@"dob"][@"year"];
    NSString *monthString = self.pendingCase[@"case"][@"patient_info"][@"dob"][@"month"];
    NSString *dayString = self.pendingCase[@"case"][@"patient_info"][@"dob"][@"day"];
    if([yearString length] == 0) {
        dobString = @"";
    }
    else if([monthString length] == 0) {
        dobString = yearString;
    }
    else if([dayString length] > 0) {
        dobString = [NSString stringWithFormat:@"%@-%@-%@",monthString,dayString,yearString];
    }
    dobLabel.text = dobString;
    dobLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:dobLabel];
    
    UILabel *weightTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 165, 90, 30)];
    weightTitle.text = @"Weight :";
    weightTitle.font = [UIFont boldSystemFontOfSize:myFont];
    weightTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:weightTitle];
    
    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 165, 160, 30)];
    weightLabel.text = self.pendingCase[@"case"][@"patient_info"][@"weight"];
    weightLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:weightLabel];
    
    UILabel *heightTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 195, 90, 30)];
    heightTitle.text = @"Height :";
    heightTitle.font = [UIFont boldSystemFontOfSize:myFont];
    heightTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:heightTitle];
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 195, 160, 30)];
    heightLabel.text = self.pendingCase[@"case"][@"patient_info"][@"height"];
    heightLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:heightLabel];
    
    UILabel *smokeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 225, 90, 30)];
    smokeTitle.text = @"Smokes :";
    smokeTitle.font = [UIFont boldSystemFontOfSize:myFont];
    smokeTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:smokeTitle];
    
    UILabel *smokeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 225, 160, 30)];
    if(self.pendingCase[@"case"][@"patient_info"][@"smoking"])
        smokeLabel.text = @"Yes";
    else
        smokeLabel.text = @"No";
    smokeLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:smokeLabel];
    
    UILabel *drinkTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 255, 90, 30)];
    drinkTitle.text = @"Drinks :";
    drinkTitle.font = [UIFont boldSystemFontOfSize:myFont];
    drinkTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:drinkTitle];
    
    UILabel *drinkLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 255, 160, 30)];
    if(self.pendingCase[@"case"][@"patient_info"][@"drinking"])
        drinkLabel.text = @"Yes";
    else
        drinkLabel.text = @"No";
    drinkLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:drinkLabel];
    
    [self.scrollView addSubview:personalInfoView];
    
    UIView *dischargeView = [[UIView alloc] initWithFrame:CGRectMake(0, 320, 280, 50)];
    dischargeView.backgroundColor = [UIColor whiteColor];
    UILabel *dischargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    dischargeLabel.text = @"    ORIGINAL DIAGNOSIS";
    dischargeLabel.font = [UIFont systemFontOfSize:14];
    dischargeLabel.textColor = [UIColor whiteColor];
    dischargeLabel.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [dischargeView addSubview:dischargeLabel];
    UILabel *dischargeTxt = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 240, 1)];
    NSString *dischargeString = self.pendingCase[@"case"][@"original_diagnosis"][@"en_us"];
    dischargeTxt.text = [self stringByConvertingHTMLToPlainText:dischargeString];
    [dischargeTxt setNumberOfLines:0];
    dischargeTxt.lineBreakMode = NSLineBreakByWordWrapping;
    dischargeTxt.font = [UIFont systemFontOfSize:myFont];
    CGSize constraint = CGSizeMake(240, 20000.0f);
    CGSize size = [dischargeTxt sizeThatFits:constraint];
    [dischargeTxt setFrame:CGRectMake(20, 50, 240, size.height)];
    [dischargeView addSubview:dischargeTxt];
    [dischargeView setFrame:CGRectMake(0, 320, 280, size.height + 70)];
    [self.scrollView addSubview:dischargeView];
    
    UIView *issueView = [[UIView alloc] initWithFrame:CGRectMake(0, dischargeView.frame.origin.y + dischargeView.frame.size.height + 20, 280, 100)];
    issueView.backgroundColor = [UIColor whiteColor];
    UILabel *issueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    issueLabel.text = @"    SERVICES SOUGHT";
    issueLabel.font = [UIFont systemFontOfSize:14];
    issueLabel.textColor = [UIColor whiteColor];
    issueLabel.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [issueView addSubview:issueLabel];
    UILabel *issueTxt = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 240, 1)];
    NSString *issueString = @"";
    issueTxt.text = [self stringByConvertingHTMLToPlainText:issueString];
    issueTxt.font = [UIFont systemFontOfSize:myFont];
    [issueTxt setNumberOfLines:0];
    issueTxt.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size2 = [issueTxt sizeThatFits:constraint];
    [issueTxt setFrame:CGRectMake(20, 50, 240, size2.height)];
    [issueView addSubview:issueTxt];
    [issueView setFrame:CGRectMake(0, dischargeView.frame.origin.y + dischargeView.frame.size.height + 20, 280, size2.height + 70)];
    [self.scrollView addSubview:issueView];
    
    UIView *summaryView = [[UIView alloc] initWithFrame:CGRectMake(0, issueView.frame.origin.y + issueView.frame.size.height + 20, 280, 100)];
    summaryView.backgroundColor = [UIColor whiteColor];
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    summaryLabel.text = @"    RELEVANT MEDICAL INFO";
    summaryLabel.font = [UIFont systemFontOfSize:14];
    summaryLabel.textColor = [UIColor whiteColor];
    summaryLabel.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [summaryView addSubview:summaryLabel];
    UILabel *summaryTxt = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 240, 1)];
    NSString *summaryString;
    NSArray *summaryArray = self.pendingCase[@"case"][@"relevant_medical_info"];
    for(int i = 0; i < [summaryArray count]; i++)
    {
        NSDictionary *d = [summaryArray objectAtIndex:i];
        NSString *label = d[@"label"];
        if([label isEqualToString:@"1"])
            label = @"CURRENT MEDICAL CONDITION";
        else if([label isEqualToString:@"2"])
            label = @"RELEVANT MEDICAL HISTORY";
        else if([label isEqualToString:@"3"])
            label = @"CURRENT TREATMENT PLAN";
        [summaryString stringByAppendingString:label];
        [summaryString stringByAppendingString:@"\n"];
        NSString *sum = d[@"en_us"];
        [summaryString stringByAppendingString:sum];
        [summaryString stringByAppendingString:@"\n\n"];
    }
    summaryTxt.text = [self stringByConvertingHTMLToPlainText:summaryString];
    summaryTxt.font = [UIFont systemFontOfSize:myFont];
    [summaryTxt setNumberOfLines:0];
    summaryTxt.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size3 = [summaryTxt sizeThatFits:constraint];
    [summaryTxt setFrame:CGRectMake(20, 50, 240, size3.height)];
    [summaryView addSubview:summaryTxt];
    [summaryView setFrame:CGRectMake(0, issueView.frame.origin.y + issueView.frame.size.height + 20, 280, size3.height + 70)];
    [self.scrollView addSubview:summaryView];
    
    NSArray *documents = self.pendingCase[@"case"][@"ehr_mdfiles"];
    UIView *documentView = [[UIView alloc] initWithFrame:CGRectMake(0, summaryView.frame.origin.y + summaryView.frame.size.height + 20, 280, 70 + 30 * [documents count])];
    documentView.backgroundColor = [UIColor whiteColor];
    UILabel *documentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    documentLabel.text = @"    DOCUMENTS";
    documentLabel.font = [UIFont systemFontOfSize:14];
    documentLabel.textColor = [UIColor whiteColor];
    documentLabel.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [documentView addSubview:documentLabel];
    
    for(int i = 0; i < [documents count]; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50 + 30 * i, 280, 30)];
        [button setTintColor:[UIColor blueColor]];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:myFont];
        NSDictionary *doc = [documents objectAtIndex:i];
        [button setTitle:doc[@"label"] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(viewDocument:) forControlEvents:UIControlEventTouchUpInside];
        [documentView addSubview:button];
    }
    
    [self.scrollView addSubview:documentView];
    
    self.scrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.scrollView.layer.borderWidth = 1.0;
    float sizeOfContent = 0;
    UIView *lLast = [self.scrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    sizeOfContent = wd + ht;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, sizeOfContent);
    
    // makes the textfields and buttons in the scrollview can scroll when drag on them
    self.scrollView.panGestureRecognizer.delaysTouchesBegan = self.scrollView.delaysContentTouches;
    [self stopLoadingIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)declineCase:(id)sender
{
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
    [bt1 addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt1];
    
    UIButton *bt2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 105, 80, 30)];
    [bt2 setTitle:@"Reject" forState:UIControlStateNormal];
    [bt2 setBackgroundColor:[UIColor darkGrayColor]];
    [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt2 addTarget:self action:@selector(decline) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt2];
}

-(void) acceptCase:(id)sender
{
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
    [bt1 addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt1];
    
    UIButton *bt2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 105, 80, 30)];
    [bt2 setTitle:@"Accept" forState:UIControlStateNormal];
    [bt2 setBackgroundColor:[UIColor darkGrayColor]];
    [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt2 addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt2];
}

-(void) closeAndBack
{
    [self.view1 removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) closeView
{
    [self.view1 removeFromSuperview];
}

-(void) accept:(id)sender
{
    NSString *caseid = self.pendingCase[@"case"][@"_id"];
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
    
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
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
                                                action:@selector(closeAndBack)];
        [self.view1 addGestureRecognizer:tap];
    }
    else
    {
        [self.view1 removeFromSuperview];
        [self popNCError];
    }
}

-(void)decline
{
    NSString *caseid = self.pendingCase[@"case"][@"_id"];
    NSDictionary *postDict = [NSDictionary dictionaryWithObject:caseid forKey:@"case_id"];;
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/doctor/reject"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:5];
    
    NSHTTPURLResponse *response = nil;
    
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
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
                                                action:@selector(closeAndBack)];
        [self.view1 addGestureRecognizer:tap];
    }
    
    else
    {
        [self.view1 removeFromSuperview];
        [self popNCError];
    }
}

- (NSString *)stringByConvertingHTMLToPlainText: (NSString *)myHTML
{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:[myHTML dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    return [attrString string];
}

- (void)viewDocument:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    x = bt.tag;
    [self performSegueWithIdentifier:@"DocumentVC" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DocumentVC"]) {
        DocumentVC *targetVC = (DocumentVC*)segue.destinationViewController;
        NSArray *documents = self.pendingCase[@"case"][@"ehr_mdfiles"];
        targetVC.doc =  [documents objectAtIndex:x];
    }
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


- (void)getCase
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://ehr-v1-beta.herokuapp.com/api/v1/case/getcase/%@",self.caseid];
    [request setURL:[NSURL URLWithString:url]];
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
                self.pendingCase = jsonObject;
            }
        }
    }
    
    else
    {
        [self popNCError];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
