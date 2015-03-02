//
//  ForgetPWVC.m
//  DoctorApp
//
//  Created by Tao Zong on 11/17/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "ForgetPWVC.h"
#import "Reachability.h"

@interface ForgetPWVC ()
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property UIView *view1;
@property UIView *view2;
@end

@implementation ForgetPWVC

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
    
    [self.emailTxt becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:68.0f/255.0f green:138.0f/255.0f blue:195.0f/255.0f alpha:1.0f]];
}

-(void) popBack
{
    [self performSegueWithIdentifier:@"back" sender:self];
}

- (IBAction)confirmEmail:(id)sender
{
    [self.emailTxt resignFirstResponder];
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.emailTxt.text, @"email",
                         nil];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/user/forgetpassword"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:5];
    NSURLResponse *requestResponse;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    if(jsonData)
    {
        self.view1 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.view1 setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f]];
        [self.view addSubview:self.view1];
        
        self.view2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 150 ) / 2, 250, 150)];
        [self.view1 addSubview:self.view2];
        [self.view2 setBackgroundColor:[UIColor whiteColor]];
        
        UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 250, 70)];
        [label setText:@"An email has been sent to you. Please check your email box and follow the instructions to reset your password."];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setEditable:NO];
        [label setSelectable:NO];
        [self.view2 addSubview:label];
        
        UIButton *bt1 = [[UIButton alloc] initWithFrame:CGRectMake(75, 105, 100, 30)];
        [bt1 setTitle:@"OK" forState:UIControlStateNormal];
        [bt1 setBackgroundColor:[UIColor lightGrayColor]];
        [bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt1.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [bt1 addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self.view2 addSubview:bt1];
    }
    
}

- (void)closeView
{
    [self.view1 removeFromSuperview];
    [self performSegueWithIdentifier:@"back" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)popNCError
{
    NSString *errorMessage = @"Please check your internet connection then try again.";
    if([self currentNetworkStatus])
    {
        errorMessage = @"Sorry for the inconvenience that our service is currently under maintenance. Please retry after a while. Thank you.";
    }
    UIAlertView *alertView;
    alertView = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (BOOL)currentNetworkStatus
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
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
