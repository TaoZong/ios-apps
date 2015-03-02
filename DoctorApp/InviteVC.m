//
//  InviteVC.m
//  DoctorApp
//
//  Created by Tao Zong on 11/19/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "InviteVC.h"
#import "Reachability.h"

@interface InviteVC ()
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@end

@implementation InviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25, 25)];
    UIImage *backImage = [UIImage imageNamed:@"LArrow.png"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
}

-(void) popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)invite:(id)sender {
    NSString *emailString = self.emailTxt.text;
    NSString *caseid = self.caseid;
    NSMutableDictionary *postDict = [NSMutableDictionary new];
    [postDict setObject:caseid forKey:@"case_id"];
    [postDict setObject:emailString forKey:@"email"];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/doctor/invite_team_member"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:5];
    
    NSHTTPURLResponse *response = nil;
    
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"~~~~~ Status code: %d", [response statusCode]);
    
    if([response statusCode] == 200)
    {
        [self popBack];
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

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

@end
