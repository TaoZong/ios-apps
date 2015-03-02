//
//  IssueVC.m
//  DoctorApp
//
//  Created by Tao Zong on 11/21/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "IssueVC.h"
#import "Reachability.h"

@interface IssueVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *myCase;
@property (strong, nonatomic) NSMutableArray *issues;
@end

@implementation IssueVC

static int myFont = 10;
static int x;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.bounces = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // load user font
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userFont.xml"];
    NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
    if(readData)
    {
        NSString *fontString = readData[@"fontsize"];
        myFont = [fontString intValue];
    }
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25, 25)];
    UIImage *backImage = [UIImage imageNamed:@"LArrow.png"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIBarButtonItem *doneBt = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(saveIssues)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = doneBt;
    
    [self getCase];
    
    NSArray *issueArray = self.myCase[@"case"][@"issue"];
    self.issues = [NSMutableArray new];
    int y = 20;
    for(int i = 0; i < [issueArray count]; i++)
    {
        int h = 0;
        CGSize constraint = CGSizeMake(240, 20000.0f);
        NSDictionary *d = [issueArray objectAtIndex:i];
        UIView *issueView = [[UIView alloc] initWithFrame:CGRectMake(20, y, 240, 1)];
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 240, 1)];
        questionLabel.text = [NSString stringWithFormat:@"Question:\n%@",d[@"content"][@"en_us"]];
        questionLabel.font = [UIFont systemFontOfSize:myFont];
        [questionLabel setNumberOfLines:0];
        questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [questionLabel sizeThatFits:constraint];
        [questionLabel setFrame:CGRectMake(20, h, 240, size.height)];
        [issueView addSubview:questionLabel];
        h = h + size.height + 10;
        
        UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, h, 240, 20)];
        answerLabel.text = [NSString stringWithFormat:@"Answer:"];
        answerLabel.font = [UIFont systemFontOfSize:myFont];
        [issueView addSubview:answerLabel];
        h = h + 20;
        
        UITextView *answerTxt = [[UITextView alloc] initWithFrame:CGRectMake(20, h, 240, 100)];
        answerTxt.text = d[@"answer"][@"en_us"];
        answerTxt.font = [UIFont systemFontOfSize:myFont];
        answerTxt.layer.borderWidth = 2.0f;
        answerTxt.layer.borderColor = [[UIColor grayColor] CGColor];
        [issueView addSubview:answerTxt];
        [self.issues addObject:answerTxt];
        h = h + 120;
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, h - 1, 240, 1)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [issueView addSubview:line];
        
        [issueView setFrame:CGRectMake(0, y, 280, h)];
        y = y + h + 20;
        
        [self.scrollView addSubview:issueView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self popNCError];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveIssues
{
    NSMutableArray *arr = [self.myCase[@"case"][@"issue"] mutableCopy];
    for(int i = 0; i < [arr count]; i++)
    {
        NSMutableDictionary *d = [[arr objectAtIndex:i] mutableCopy];
        UITextView *txt = [self.issues objectAtIndex:i];
        NSMutableDictionary *dd = [d[@"answer"] mutableCopy];
        dd[@"en_us"] = txt.text;
        d[@"answer"] = dd;
        [arr replaceObjectAtIndex:i withObject:d];
    }
    NSString *caseid = self.myCase[@"case"][@"_id"];
    NSLog(caseid);
    NSLog(@"%@",arr);
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         arr, @"issue",
                         caseid, @"case_id",
                         nil];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/case/update_issue"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:5];
    NSURLResponse *requestResponse;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    if(jsonData)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
