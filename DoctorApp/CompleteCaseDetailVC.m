//
//  CompleteCaseDetailVC.m
//  DoctorApp
//
//  Created by Tao Zong on 11/11/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "CompleteCaseDetailVC.h"
#import "DoctorAppAppDelegate.h"
#import "DocumentVC.h"
#import "Reachability.h"

@interface CompleteCaseDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSDictionary *myCase;

@end

@implementation CompleteCaseDetailVC

static NSArray *months;
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
    [super viewWillAppear:animated];
    months = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    NSArray *viewsToRemove = [self.scrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
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
    NSArray *array = self.myCase[@"case"][@"comments"];
    NSMutableArray *commentArray = [NSMutableArray new];
    NSMutableArray *teamcommentArray = [NSMutableArray new];
    NSMutableArray *requirementArray = [NSMutableArray new];
    for(int i = 0; i < [array count]; i++)
    {
        NSDictionary *d = [array objectAtIndex:i];
        NSString *label = d[@"label"];
        if([label isEqualToString:@"12"])
        {
            [commentArray addObject:d];
        }
        else if([label isEqualToString:@"13"])
        {
            [teamcommentArray addObject:d];
        }
        else if([label isEqualToString:@"14"])
        {
            [requirementArray addObject:d];
        }
        
    }
//    NSLog(@"%@",self.myCase);
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"CASE";
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
    
    UIView *requirementView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 70)];
    requirementView.backgroundColor = [UIColor whiteColor];
    UILabel *requirementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    requirementLabel.text = @"    NOTES FOR PATIENT";
    requirementLabel.font = [UIFont systemFontOfSize:14];
    requirementLabel.textColor = [UIColor whiteColor];
    requirementLabel.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [requirementView addSubview:requirementLabel];
    
    int h = 70;
    for(int i = 0; i < [requirementArray count]; i++)
    {
        NSDictionary *d = [requirementArray objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, h, 240, 0)];
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
        NSString *content = d[@"content"][@"en_us"];
        NSString *author = d[@"author"];
        NSString *bodyString = [NSString stringWithFormat:@"By %@\n\n%@\n\n%@",author,date,content];
        label.text = bodyString;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:myFont];
        CGSize constraint = CGSizeMake(240,20000);
        CGSize size = [label sizeThatFits:constraint];
        [label setFrame:CGRectMake(20, h, 240, size.height)];
        [requirementView addSubview:label];
        h = h + size.height + 5;
        if([requirementArray count] > 0 && i != ([requirementArray count] - 1))
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, h, 240, 1)];
            line.backgroundColor = [UIColor grayColor];
            [requirementView addSubview:line];
        }
        
        h = h + 10;
    }
    [requirementView setFrame:CGRectMake(0, 0, 280, h)];
    [self.scrollView addSubview:requirementView];
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, requirementView.frame.origin.y + requirementView.frame.size.height + 20, 280, 70)];
    commentView.backgroundColor = [UIColor whiteColor];
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    commentLabel.text = @"    COMMENT";
    commentLabel.font = [UIFont systemFontOfSize:14];
    commentLabel.textColor = [UIColor whiteColor];
    commentLabel.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [commentView addSubview:commentLabel];

    h = 70;
    for(int i = 0; i < [commentArray count]; i++)
    {
        NSDictionary *d = [commentArray objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, h, 240, 0)];
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
        NSString *content = d[@"content"][@"en_us"];
        NSString *author = d[@"author"];
        NSString *bodyString = [NSString stringWithFormat:@"By %@\n\n%@\n\n%@",author,date,content];
        label.text = bodyString;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:myFont];
        CGSize constraint = CGSizeMake(240,20000);
        CGSize size = [label sizeThatFits:constraint];
        [label setFrame:CGRectMake(20, h, 240, size.height)];
        [commentView addSubview:label];
        h = h + size.height + 5;
        if([commentArray count] > 0 && i != ([commentArray count] - 1))
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, h, 240, 1)];
            line.backgroundColor = [UIColor grayColor];
            [commentView addSubview:line];
        }
        
        h = h + 10;
    }
    [commentView setFrame:CGRectMake(0, requirementView.frame.origin.y + requirementView.frame.size.height + 20, 280, h)];
    [self.scrollView addSubview:commentView];
    
    UIView *teamcommentView = [[UIView alloc] initWithFrame:CGRectMake(0, commentView.frame.origin.y + commentView.frame.size.height + 20, 280, 70)];
    teamcommentView.backgroundColor = [UIColor whiteColor];
    UILabel *teamcommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    teamcommentLabel.text = @"    TEAM COMMENT";
    teamcommentLabel.font = [UIFont systemFontOfSize:14];
    teamcommentLabel.textColor = [UIColor whiteColor];
    teamcommentLabel.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [teamcommentView addSubview:teamcommentLabel];
    
    h = 70;
    for(int i = 0; i < [teamcommentArray count]; i++)
    {
        NSDictionary *d = [teamcommentArray objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, h, 240, 0)];
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
        NSString *content = d[@"content"][@"en_us"];
        NSString *author = d[@"author"];
        NSString *bodyString = [NSString stringWithFormat:@"By %@\n\n%@\n\n%@",author,date,content];
        label.text = bodyString;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:myFont];
        CGSize constraint = CGSizeMake(240,20000);
        CGSize size = [label sizeThatFits:constraint];
        [label setFrame:CGRectMake(20, h, 240, size.height)];
        [teamcommentView addSubview:label];
        h = h + size.height + 5;
        if([teamcommentArray count] > 0 && i != ([teamcommentArray count] - 1))
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, h, 240, 1)];
            line.backgroundColor = [UIColor grayColor];
            [teamcommentView addSubview:line];
        }
        
        h = h + 10;
    }
    [teamcommentView setFrame:CGRectMake(0, commentView.frame.origin.y + commentView.frame.size.height + 20, 280, h)];
    [self.scrollView addSubview:teamcommentView];
    
    UIView *personalInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, teamcommentView.frame.origin.y + teamcommentView.frame.size.height + 20, 280, 300)];
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
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.myCase[@"case"][@"belong_to"][@"firstname"][@"en_us"],self.myCase[@"case"][@"belong_to"][@"lastname"][@"en_us"]];
    nameLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:nameLabel];
    
    UILabel *sexTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 90, 30)];
    sexTitle.text = @"Sex :";
    sexTitle.font = [UIFont boldSystemFontOfSize:myFont];
    sexTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:sexTitle];
    
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 75, 160, 30)];
    NSString *sexString = self.myCase[@"case"][@"patient_info"][@"gender"];
    sexLabel.text = [sexString capitalizedString];
    sexLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:sexLabel];
    
    UILabel *raceTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, 90, 30)];
    raceTitle.text = @"Ethnicity/Race :";
    raceTitle.font = [UIFont boldSystemFontOfSize:myFont];
    raceTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:raceTitle];
    
    UILabel *raceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 105, 160, 30)];
    NSString *raceString = self.myCase[@"case"][@"patient_info"][@"ethnicity"];
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
    NSString *yearString = self.myCase[@"case"][@"patient_info"][@"dob"][@"year"];
    NSString *monthString = self.myCase[@"case"][@"patient_info"][@"dob"][@"month"];
    NSString *dayString = self.myCase[@"case"][@"patient_info"][@"dob"][@"day"];
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
    weightLabel.text = self.myCase[@"case"][@"patient_info"][@"weight"];
    weightLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:weightLabel];
    
    UILabel *heightTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 195, 90, 30)];
    heightTitle.text = @"Height :";
    heightTitle.font = [UIFont boldSystemFontOfSize:myFont];
    heightTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:heightTitle];
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 195, 160, 30)];
    heightLabel.text = self.myCase[@"case"][@"patient_info"][@"height"];
    heightLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:heightLabel];
    
    UILabel *smokeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 225, 90, 30)];
    smokeTitle.text = @"Smokes :";
    smokeTitle.font = [UIFont boldSystemFontOfSize:myFont];
    smokeTitle.textAlignment = NSTextAlignmentRight;
    [personalInfoView addSubview:smokeTitle];
    
    UILabel *smokeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 225, 160, 30)];
    if(self.myCase[@"case"][@"patient_info"][@"smoking"])
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
    if(self.myCase[@"case"][@"patient_info"][@"drinking"])
        drinkLabel.text = @"Yes";
    else
        drinkLabel.text = @"No";
    drinkLabel.font = [UIFont systemFontOfSize:myFont];
    [personalInfoView addSubview:drinkLabel];
    [self.scrollView addSubview:personalInfoView];
    
    UIView *dischargeView = [[UIView alloc] initWithFrame:CGRectMake(0, personalInfoView.frame.origin.y + personalInfoView.frame.size.height + 20, 280, 50)];
    dischargeView.backgroundColor = [UIColor whiteColor];
    UILabel *dischargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    dischargeLabel.text = @"    ORIGINAL DIAGNOSIS";
    dischargeLabel.font = [UIFont systemFontOfSize:14];
    dischargeLabel.textColor = [UIColor whiteColor];
    dischargeLabel.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8];
    [dischargeView addSubview:dischargeLabel];
    UILabel *dischargeTxt = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 240, 1)];
    NSString *dischargeString = self.myCase[@"case"][@"original_diagnosis"][@"en_us"];
    dischargeTxt.text = [self stringByConvertingHTMLToPlainText:dischargeString];
    [dischargeTxt setNumberOfLines:0];
    dischargeTxt.lineBreakMode = NSLineBreakByWordWrapping;
    dischargeTxt.font = [UIFont systemFontOfSize:myFont];
    CGSize constraint = CGSizeMake(240, 20000.0f);
    CGSize size = [dischargeTxt sizeThatFits:constraint];
    [dischargeTxt setFrame:CGRectMake(20, 50, 240, size.height)];
    [dischargeView addSubview:dischargeTxt];
    [dischargeView setFrame:CGRectMake(0, personalInfoView.frame.size.height + 20 + personalInfoView.frame.origin.y, 280, size.height + 70)];
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
    NSMutableString *issueString = [NSMutableString new];
    NSArray *issueArray = self.myCase[@"case"][@"issue"];
    for(int i = 0; i < [issueArray count]; i++)
    {
        NSDictionary *d =[issueArray objectAtIndex:i];
        NSString *question = d[@"content"][@"en_us"];
        NSString *answer = d[@"answer"][@"en_us"];
        if(!question)
            question = @"";
        if(!answer)
            answer = @"";
        [issueString appendString:[NSString stringWithFormat:@"<p>Q:    %@</p><p>A:    %@</p><p></p><p></p>",question,answer]];
    }
    issueTxt.text = [self stringByConvertingHTMLToPlainText:issueString];
    [issueTxt setNumberOfLines:0];
    issueTxt.lineBreakMode = NSLineBreakByWordWrapping;
    issueTxt.font = [UIFont systemFontOfSize:myFont];
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
    NSArray *summaryArray = self.myCase[@"case"][@"relevant_medical_info"];
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
    
    NSArray *documents = self.myCase[@"case"][@"ehr_mdfiles"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) popBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
        NSArray *documents = self.myCase[@"ehr_mdfiles"];
        targetVC.doc =  [documents objectAtIndex:x];
    }
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
                self.myCase = jsonObject;
            }
        }
    }
    
    else
    {
        [self popNCError];
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

@end
