//
//  ProfessionalInfoVC.m
//  DoctorApp
//
//  Created by Tao Zong on 10/29/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "ProfessionalInfoVC.h"
#import "DoctorAppAppDelegate.h"
#import "Reachability.h"

@interface ProfessionalInfoVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextView *pageLinkTxt;
@property (strong, nonatomic) UITextView *specialityTxt;
@property (strong, nonatomic) UITextView *bgTxt;
@property UIBarButtonItem *doneBt;

@property (strong, nonatomic) NSMutableDictionary *profile;

@end

@implementation ProfessionalInfoVC
static int x;
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
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25, 25)];
    UIImage *backImage = [UIImage imageNamed:@"LArrow.png"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    self.doneBt = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = self.doneBt;
    
    UIView *identifierTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    identifierTitleView.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8f];
    [self.scrollView addSubview: identifierTitleView];
    
    UILabel *identifierTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 260, 20)];
    identifierTitleLabel.text = @"National Provider Identifier (NPI)";
    identifierTitleLabel.font = [UIFont systemFontOfSize:16];
    identifierTitleLabel.textColor = [UIColor whiteColor];
    [identifierTitleView addSubview:identifierTitleLabel];
    
    UILabel *identifierLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 280, 30)];
    identifierLabel.text = self.profile[@"profile"][@"licence"];
    identifierLabel.textAlignment = NSTextAlignmentCenter;
    identifierLabel.backgroundColor = [UIColor whiteColor];
    identifierLabel.font = [UIFont systemFontOfSize:12];
    identifierLabel.textColor = [UIColor blackColor];
    [self.scrollView addSubview:identifierLabel];
    
    UIView *pagelinkTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 280, 40)];
    pagelinkTitleView.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8f];
    [self.scrollView addSubview: pagelinkTitleView];
    
    UILabel *pagelinkTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 260, 20)];
    pagelinkTitleLabel.text = @"Professional Page Link";
    pagelinkTitleLabel.font = [UIFont systemFontOfSize:16];
    pagelinkTitleLabel.textColor = [UIColor whiteColor];
    [pagelinkTitleView addSubview:pagelinkTitleLabel];
    
    self.pageLinkTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, 130, 280, 30)];
    self.pageLinkTxt.backgroundColor = [UIColor whiteColor];
    self.pageLinkTxt.text = self.profile[@"profile"][@"url"];
    self.pageLinkTxt.delegate = self;
    self.pageLinkTxt.tag = 1;
    [self.scrollView addSubview:self.pageLinkTxt];
    
    UIView *specialityTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, 280, 40)];
    specialityTitleView.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8f];
    [self.scrollView addSubview: specialityTitleView];
    
    UILabel *specialityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 260, 20)];
    specialityTitleLabel.text = @"Speciality";
    specialityTitleLabel.font = [UIFont systemFontOfSize:16];
    specialityTitleLabel.textColor = [UIColor whiteColor];
    [specialityTitleView addSubview:specialityTitleLabel];
    
    self.specialityTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, 220, 280, 60)];
    self.specialityTxt.backgroundColor = [UIColor whiteColor];
    self.specialityTxt.text = self.profile[@"profile"][@"specialty"];
    self.specialityTxt.delegate = self;
    self.specialityTxt.tag = 2;
    [self.scrollView addSubview:self.specialityTxt];
    
    UIView *bgTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 280, 40)];
    bgTitleView.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:76.0f/255.0f blue:104.0f/255.0f alpha:0.8f];
    [self.scrollView addSubview: bgTitleView];
    
    UILabel *bgTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 260, 20)];
    bgTitleLabel.text = @"Background";
    bgTitleLabel.font = [UIFont systemFontOfSize:16];
    bgTitleLabel.textColor = [UIColor whiteColor];
    [bgTitleView addSubview:bgTitleLabel];
    
    self.bgTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, 340, 280, 200)];
    self.bgTxt.backgroundColor = [UIColor whiteColor];
    self.bgTxt.text = self.profile[@"profile"][@"bio"][@"en_us"];
    self.bgTxt.delegate = self;
    self.bgTxt.tag = 3;
    [self.scrollView addSubview:self.bgTxt];
    
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) popBack
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)done
{
    NSMutableDictionary *d = [self.profile[@"profile"] mutableCopy];
    [d setValue:self.pageLinkTxt.text forKey:@"url"];
    [d setValue:self.specialityTxt.text forKey:@"specialty"];
    NSMutableDictionary *dd = [d[@"bio"] mutableCopy];
    [dd setValue:self.bgTxt.text forKey:@"en_us"];
    [d setValue:dd forKey:@"bio"];
    [self.profile setObject:d forKey:@"profile"];
    [self updateProfile];
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


-(void) slideFrame:(BOOL) up
{
    int movementDistance = 0;
    if(x == 1)
        movementDistance = 100;
    else if(x == 2)
        movementDistance = 150;
    else if(x == 3)
        movementDistance = 250;
    
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

- (void)textViewDidBeginEditing:(UITextView *)textView{
    x = textView.tag;
    [self slideFrame:YES];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    x = textView.tag;
    [self slideFrame:NO];
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
