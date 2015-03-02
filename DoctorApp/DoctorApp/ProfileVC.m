//
//  ProfileVC.m
//  DoctorApp
//
//  Created by Tao Zong on 10/23/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "ProfileVC.h"
#import "DoctorAppAppDelegate.h"
#import "Reachability.h"

@interface ProfileVC ()

@property (weak, nonatomic) IBOutlet UIView *basicInfoView;
@property (strong, nonatomic) UIView *contactInfoView;
@property (strong, nonatomic) UIView *professionalInfoView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end

@implementation ProfileVC

static UIImageView *circ;
static int myFont;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.scrollView.bounces = NO;
    
    // load user font
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userFont.xml"];
    NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
    if(readData)
    {
        NSString *fontString = readData[@"fontsize"];
        myFont = [fontString intValue];
    }
    
    [self showView];
    [self stopLoadingIndicator];
    
}

- (void)showView
{
    [self getDoctorProfile];
    DoctorAppAppDelegate *appDelegate = (DoctorAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *profile = appDelegate.globalProfile;
    //    NSLog(@"%@",profile);
    NSString *firstname = profile[@"user_info"][@"firstname"][@"en_us"];
    //    NSLog(firstname);
    NSString *lastname = profile[@"user_info"][@"lastname"][@"en_us"];
    NSString *gender = [profile[@"profile"][@"gender"] capitalizedString];
    NSString *email = profile[@"user_info"][@"email"];
    NSMutableArray *phoneList = [profile[@"profile"][@"phone"] mutableCopy];
    NSMutableArray *addressList = [profile[@"profile"][@"address"] mutableCopy];
    NSString *npi = profile[@"profile"][@"licence"];
    NSString *url = profile[@"profile"][@"url"];
    NSString *specialty = profile[@"profile"][@"specialty"];
    NSString *bio = profile[@"profile"][@"bio"][@"en_us"];
    NSString *photoPath = profile[@"user_info"][@"avatar"];
    UIImage *profileImage = [UIImage imageNamed:@"user"];
    if(photoPath.length > 0)
    {
        profileImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: photoPath]]];
    }
    if([phoneList count] == 0)
    {
        NSDictionary *d = [[NSDictionary alloc] initWithObjectsAndKeys:@"home", @"label", @"", @"number",  nil];
        [phoneList addObject:d];
        [profile setObject:phoneList forKey:@"phone"];
        
    }
    if([addressList count] == 0)
    {
        NSDictionary *d = [[NSDictionary alloc] initWithObjectsAndKeys:@"home", @"label", @"", @"street", @"", @"city", @"", @"state", @"", @"zipcode",  nil];
        [addressList addObject:d];
        [profile setObject:addressList forKey:@"address"];
    }
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"PROFILE";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    circ = [[UIImageView alloc] initWithFrame:CGRectMake(230, 90, 0, 0)];
    circ.clipsToBounds = YES;
    [self setRoundedView:circ toDiameter:70.0];
    [circ setImage:profileImage];
    [circ setBackgroundColor:[UIColor lightGrayColor]];
    [self.basicInfoView addSubview:circ];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
    self.nameLabel.font = [UIFont systemFontOfSize:myFont];
    self.sexLabel.text = gender;
    self.sexLabel.font = [UIFont systemFontOfSize:myFont];
    
    self.contactInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, 280, 110 + 70 * [phoneList count] + 120 * [addressList count])];
    self.contactInfoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.contactInfoView];
    
    UILabel *contactInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 140, 30)];
    contactInfoLabel.text = @"Contact Information";
    contactInfoLabel.font = [UIFont systemFontOfSize:12];
    [self.contactInfoView addSubview: contactInfoLabel];
    
    UIButton *editContactInfoBt = [[UIButton alloc] initWithFrame:CGRectMake(220, 0, 50, 40)];
    [editContactInfoBt setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.contactInfoView addSubview:editContactInfoBt];
    [editContactInfoBt addTarget:self action:@selector(editContactInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 280, 2)];
    line1.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.contactInfoView addSubview:line1];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 50, 40, 40)];
    image1.image = [UIImage imageNamed:@"email"];
    [self.contactInfoView addSubview: image1];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 200, 40)];
    emailLabel.text = email;
    emailLabel.font = [UIFont systemFontOfSize:myFont];
    [self.contactInfoView addSubview: emailLabel];
    
    UIView *subline1 = [[UIView alloc] initWithFrame:CGRectMake(60, 88, 200, 2)];
    subline1.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.contactInfoView addSubview:subline1];
    
    for(int i = 0; i < [phoneList count]; i++)
    {
        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 90 + 70 * i, 40, 40)];
        image2.image = [UIImage imageNamed:@"phone"];
        [self.contactInfoView addSubview: image2];
        
        UILabel *phoneTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 90 + 70 * i, 200, 40)];
        NSDictionary *phoneDict = [phoneList objectAtIndex:i];
        NSString *phonelabel = phoneDict[@"label"];
        phoneTypeLabel.text = [phonelabel capitalizedString];
        phoneTypeLabel.font = [UIFont boldSystemFontOfSize:myFont];
        phoneTypeLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0f/255.0f blue:195.0f/255.0f alpha:1.0f];
        [self.contactInfoView addSubview: phoneTypeLabel];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 130 + 70 * i, 200, 30)];
        phoneLabel.text = phoneDict[@"number"];
        phoneLabel.font = [UIFont systemFontOfSize:myFont];
        phoneLabel.textColor = [UIColor blackColor];
        [self.contactInfoView addSubview: phoneLabel];
        
        UIView *subline2 = [[UIView alloc] initWithFrame:CGRectMake(60, 158 + 70 * i, 200, 2)];
        subline2.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        [self.contactInfoView addSubview:subline2];
    }
    
    for(int j = 0; j < [addressList count]; j++)
    {
        UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 90 + 70 * [phoneList count] + 120 * j, 40, 40)];
        image3.image = [UIImage imageNamed:@"address"];
        [self.contactInfoView addSubview: image3];
        NSDictionary *addressDict = [addressList objectAtIndex:j];
        UILabel *addressTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 90 + 70 * [phoneList count] + 120 * j, 200, 40)];
        NSString *addresslabel = addressDict[@"label"];
        addressTypeLabel.text = [addresslabel capitalizedString];
        addressTypeLabel.font = [UIFont boldSystemFontOfSize:myFont];
        addressTypeLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0f/255.0f blue:195.0f/255.0f alpha:1.0f];
        //    addressTypeLabel.backgroundColor = [UIColor greenColor];
        [self.contactInfoView addSubview: addressTypeLabel];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 130 + 70 * [phoneList count] + 120 * j, 200, 80)];
        addressLabel.text = [NSString stringWithFormat:@"%@\n%@ %@ %@\n", addressDict[@"street"], addressDict[@"city"], addressDict[@"state"], addressDict[@"zipcode"]];
        addressLabel.font = [UIFont systemFontOfSize:myFont];
        addressLabel.textColor = [UIColor blackColor];
        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        addressLabel.numberOfLines = 0;
        //    addressLabel.backgroundColor = [UIColor blueColor];
        [self.contactInfoView addSubview: addressLabel];
        
        UIView *subline3 = [[UIView alloc] initWithFrame:CGRectMake(60, 208 + 70 * [phoneList count] + 120 * j, 200, 2)];
        subline3.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        [self.contactInfoView addSubview:subline3];
    }
    
    self.professionalInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contactInfoView.frame.origin.y + self.contactInfoView.frame.size.height + 20, 280, 560)];
    self.professionalInfoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.professionalInfoView];
    
    UILabel *professionalInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 140, 30)];
    professionalInfoLabel.text = @"Professional Information";
    professionalInfoLabel.font = [UIFont systemFontOfSize:12];
    [self.professionalInfoView addSubview: professionalInfoLabel];
    
    UIButton *editProfessionalInfoBt = [[UIButton alloc] initWithFrame:CGRectMake(220, 0, 50, 40)];
    [editProfessionalInfoBt setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.professionalInfoView addSubview:editProfessionalInfoBt];
    [editProfessionalInfoBt addTarget:self action:@selector(editProfessionalInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 280, 2)];
    line2.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.professionalInfoView addSubview:line2];
    
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 40, 40, 40)];
    image4.image = [UIImage imageNamed:@"npi"];
    [self.professionalInfoView addSubview: image4];
    UILabel *NPITypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 200, 40)];
    NPITypeLabel.text = @"National Provider Identifier (NPI)";
    NPITypeLabel.font = [UIFont boldSystemFontOfSize:12];
    NPITypeLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0f/255.0f blue:195.0f/255.0f alpha:1.0f];
    [self.professionalInfoView addSubview: NPITypeLabel];
    
    UILabel *NPILabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 200, 30)];
    NPILabel.text = npi;
    NPILabel.font = [UIFont systemFontOfSize:myFont];
    NPILabel.textColor = [UIColor blackColor];
    NPILabel.lineBreakMode = NSLineBreakByWordWrapping;
    NPILabel.numberOfLines = 0;
    [self.professionalInfoView addSubview: NPILabel];
    
    UIView *subline4 = [[UIView alloc] initWithFrame:CGRectMake(60, 108, 200, 2)];
    subline4.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.professionalInfoView addSubview:subline4];
    
    UIImageView *image5 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 120, 40, 40)];
    image5.image = [UIImage imageNamed:@"page"];
    [self.professionalInfoView addSubview: image5];
    UILabel *linkTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 120, 200, 40)];
    linkTypeLabel.text = @"Professional Page Link";
    linkTypeLabel.font = [UIFont boldSystemFontOfSize:12];
    linkTypeLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0f/255.0f blue:195.0f/255.0f alpha:1.0f];
    [self.professionalInfoView addSubview: linkTypeLabel];
    
    UITextView *linkLabel = [[UITextView alloc] initWithFrame:CGRectMake(60, 160, 200, 60)];
    linkLabel.text = url;
    linkLabel.font = [UIFont systemFontOfSize:myFont];
    linkLabel.textColor = [UIColor blackColor];
    linkLabel.editable = NO;
    linkLabel.selectable = NO;
    [self.professionalInfoView addSubview: linkLabel];
    
    UIView *subline5 = [[UIView alloc] initWithFrame:CGRectMake(60, 218, 200, 2)];
    subline5.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.professionalInfoView addSubview:subline5];
    
    UIImageView *image6 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 220, 40, 40)];
    image6.image = [UIImage imageNamed:@"spec"];
    [self.professionalInfoView addSubview: image6];
    UILabel *specialtyTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 220, 200, 40)];
    specialtyTypeLabel.text = @"Speciality";
    specialtyTypeLabel.font = [UIFont boldSystemFontOfSize:12];
    specialtyTypeLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0f/255.0f blue:195.0f/255.0f alpha:1.0f];
    [self.professionalInfoView addSubview: specialtyTypeLabel];
    
    UITextView *specialtyLabel = [[UITextView alloc] initWithFrame:CGRectMake(60, 260, 200, 60)];
    specialtyLabel.text = specialty;
    specialtyLabel.font = [UIFont systemFontOfSize:myFont];
    specialtyLabel.textColor = [UIColor blackColor];
    specialtyLabel.editable = NO;
    specialtyLabel.selectable = NO;
    [self.professionalInfoView addSubview: specialtyLabel];
    
    UIView *subline6 = [[UIView alloc] initWithFrame:CGRectMake(60, 318, 200, 2)];
    subline6.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.professionalInfoView addSubview:subline6];
    
    UIImageView *image7 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 320, 40, 40)];
    image7.image = [UIImage imageNamed:@"bg"];
    [self.professionalInfoView addSubview: image7];
    UILabel *bgTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 320, 200, 40)];
    bgTypeLabel.text = @"Background";
    bgTypeLabel.font = [UIFont boldSystemFontOfSize:12];
    bgTypeLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:138.0f/255.0f blue:195.0f/255.0f alpha:1.0f];
    [self.professionalInfoView addSubview: bgTypeLabel];
    
    UITextView *bgLabel = [[UITextView alloc] initWithFrame:CGRectMake(60, 360, 200, 200)];
    bgLabel.text = bio;
    bgLabel.font = [UIFont systemFontOfSize:myFont];
    bgLabel.textColor = [UIColor blackColor];
    bgLabel.editable = NO;
    bgLabel.selectable = NO;
    bgLabel.scrollEnabled = NO;
    [self textViewDidChange:bgLabel];
    [self.professionalInfoView addSubview: bgLabel];
    
    
    UIView *subline7 = [[UIView alloc] initWithFrame:CGRectMake(60, bgLabel.frame.origin.y + bgLabel.frame.size.height, 200, 2)];
    subline7.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.professionalInfoView addSubview:subline7];
    [self.professionalInfoView setFrame:CGRectMake(0, self.contactInfoView.frame.origin.y + self.contactInfoView.frame.size.height + 20, 280, subline7.frame.origin.y + 22)];
    
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

- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)editContactInfo:(id)sender
{
    [self performSegueWithIdentifier:@"contactInfoVC" sender:self];
}

- (void)editProfessionalInfo:(id)sender
{
    [self performSegueWithIdentifier:@"professionalInfoVC" sender:self];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (void)getDoctorProfile
{
    self.profile = [[NSDictionary alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/doctor/profile"]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:5];
    
    NSURLResponse *requestResponse;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSError *error = nil;
    if(jsonData != nil)
    {
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:jsonData
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            if ([jsonObject isKindOfClass:[NSDictionary class]]){
                self.profile = jsonObject;
                DoctorAppAppDelegate *appDelegate = (DoctorAppAppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.globalProfile = [self.profile mutableCopy];
            }
        }
    }
    else
        [self popNCError];
}

+ (void)setCirc:(UIImage *)image
{
    circ.image = image;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
