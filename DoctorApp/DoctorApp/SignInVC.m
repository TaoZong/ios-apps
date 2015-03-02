//
//  SignInVC.m
//  DoctorApp
//
//  Created by Tao Zong on 7/29/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "SignInVC.h"
#import "TimeoutApplication.h"
#import "Reachability.h"
#import "DoctorAppAppDelegate.h"

@interface SignInVC ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *signin;
@property (weak, nonatomic) IBOutlet UIButton *forgetPW;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation SignInVC

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
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.signin.layer.cornerRadius = 5;
    self.signin.clipsToBounds = YES;
    self.view1.layer.cornerRadius = 5;
    self.view1.clipsToBounds = YES;
    self.view2.layer.cornerRadius = 5;
    self.view2.clipsToBounds = YES;
    [self.signin addTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPW addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.username.autocorrectionType = UITextAutocorrectionTypeNo;
    self.username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if([standardUserDefaults stringForKey:@"usernametologin"])
    {
        self.username.text = [standardUserDefaults stringForKey:@"usernametologin"];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
//        NSLog(textField.text);
    }
    else {
        
        [textField resignFirstResponder];
//        NSLog(textField.text);
    }
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
//        NSLog(textField.text);
    }
    else {
//        NSLog(textField.text);
    }
    return true;
}

-(void) slideFrame:(BOOL) up
{
    int movementDistance = 0;
    
    if (self.interfaceOrientation == UIDeviceOrientationPortrait){
        movementDistance = 200;
    }else if(self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
        movementDistance = -130;
    }else if(self.interfaceOrientation == UIDeviceOrientationLandscapeLeft){
        movementDistance = -200;
    }else{
        movementDistance = 200;
    }
    
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    } else {
        self.view.frame = CGRectOffset(self.view.frame, movement, 0);
    }
    
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self slideFrame:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self slideFrame:NO];
}
- (void)sign {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    NSString *inputusername, *inputpassword, *devicetoken;
    inputusername = self.username.text;
    inputpassword = self.password.text;
    DoctorAppAppDelegate *appDelegate = (DoctorAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    devicetoken = appDelegate.devicetoken;

    
    //global font xml
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userFont.xml"];
    NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *writeData;
    if(!readData)
    {
        writeData = [[NSMutableDictionary alloc] init];
        [writeData setValue:@"10" forKey:@"fontsize"];
        BOOL result = [[writeData copy] writeToFile: path atomically:YES];
        NSLog(@"%@", result ? @"new font saved" : @"new font not saved");
    }
    
    if ([inputusername isEqualToString:@""]) {
        [self popError:@"Please enter your 'User Name'!"];
    }
    else if([inputpassword isEqualToString:@""]) {
        [self popError:@"Please enter your 'Password'!"];
    }
    else {
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             inputusername, @"username",
                             inputpassword, @"password",
                             devicetoken, @"device",
                             nil];
        NSError *error = nil;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/mobile/login"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:postData];
        [request setTimeoutInterval:5];
        [self startLoadingIndicator];
        
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if(conn)
        {
//            NSLog(@"Connection Successful");
        }
        else
        {
            NSLog(@"Connection could not be made");
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    [self stopLoadingIndicator];
    NSError *error = nil;
    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSString *arrayString = dictionary[@"message"];
    if (arrayString)
    {
        NSLog(@"%@", arrayString);
        
        if([arrayString isEqualToString:@"Login successful"])
        {
            NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setValue:self.username.text forKey:@"usernametologin"];
            
            [(TimeoutApplication *)[UIApplication sharedApplication] resetIdleTimer];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *navigation = [storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
            [self presentViewController:navigation animated:YES completion:nil];
            
        }
        else
        {
            self.password.text = @"";
            [self popError:@"Sorry, cannot sign in. Your 'User Name' or 'Password' was entered incorrectly."];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self stopLoadingIndicator];
    [self popNCError];
    NSLog(@"fail with error");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (void)popError: (NSString *)errorMessage
{
    UIAlertView *alertView;
    alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)popNCError
{
    NSString *errorMessage = @"Please check your internet connection then try again.";
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
            [self sign];
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

- (void)forget
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigation = [storyboard instantiateViewControllerWithIdentifier:@"forgetVC"];
    [self presentViewController:navigation animated:YES completion:nil];
}

@end
