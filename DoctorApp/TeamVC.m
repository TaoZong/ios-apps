//
//  TeamVC.m
//  DoctorApp
//
//  Created by Tao Zong on 11/19/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "TeamVC.h"
#import "InviteVC.h"
#import "CommentVC.h"
#import "TeamMemberVC.h"
#import "Reachability.h"

@interface TeamVC ()
@property UIView *view1;
@property UIView *view2;
@end

@implementation TeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)createTeam:(id)sender {
    self.view1 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view1 setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f]];
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 150 ) / 2, 250, 150)];
    [self.view1 addSubview:self.view2];
    [self.view2 setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 250, 70)];
    [label setText:@"Please confirm that you want to create a team."];
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
    [bt1 addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt1];
    
    UIButton *bt2 = [[UIButton alloc] initWithFrame:CGRectMake(130, 105, 100, 30)];
    [bt2 setTitle:@"Create Team" forState:UIControlStateNormal];
    [bt2 setBackgroundColor:[UIColor darkGrayColor]];
    [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bt2 addTarget:self action:@selector(createNewTeam) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:bt2];
}

- (void)closeView
{
    [self.view2 removeFromSuperview];
    [self.view1 removeFromSuperview];
}

- (void)createNewTeam
{
    NSString *caseid = self.caseid;
    NSDictionary *postDict = [NSDictionary dictionaryWithObject:caseid forKey:@"case_id"];;
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/case/create_team"]];
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
    }
    
    else
    {
        [self.view1 removeFromSuperview];
        [self popNCError];
    }
}

- (IBAction)inviteDoctor:(id)sender {
    [self performSegueWithIdentifier:@"inviteVC" sender:self];
}
- (IBAction)makeComment:(id)sender {
    [self performSegueWithIdentifier:@"commentVC" sender:self];
}
- (IBAction)viewMembers:(id)sender {
    [self performSegueWithIdentifier:@"teammemberVC" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"commentVC"]) {
        CommentVC *targetVC = (CommentVC*)segue.destinationViewController;
        targetVC.caseid = self.caseid;
        targetVC.tag = @"team";
    }
    
    if ([[segue identifier] isEqualToString:@"inviteVC"]) {
        InviteVC *targetVC = (InviteVC*)segue.destinationViewController;
        targetVC.caseid = self.caseid;
    }
    
    if ([[segue identifier] isEqualToString:@"teammemberVC"]) {
        TeamMemberVC *targetVC = (TeamMemberVC*)segue.destinationViewController;
        targetVC.caseid = self.caseid;
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


@end
