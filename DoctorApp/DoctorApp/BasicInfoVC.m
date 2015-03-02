//
//  BasicInfoVC.m
//  DoctorApp
//
//  Created by Tao Zong on 10/24/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "BasicInfoVC.h"
#import "DoctorAppAppDelegate.h"
#import "ProfileVC.h"
#import "LeftVC.h"
#import "Reachability.h"

@interface BasicInfoVC () <FDTakeDelegate>
@property UIBarButtonItem *doneBt;
@property (weak, nonatomic) IBOutlet UIView *basicInfoView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxt;
@property (weak, nonatomic) IBOutlet UILabel *maleLabel;
@property (weak, nonatomic) IBOutlet UILabel *femaleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *maleSeleted;
@property (weak, nonatomic) IBOutlet UIImageView *femaleSelected;
@property (strong, nonatomic) UIImage* profileImage;
@property (strong, nonatomic) NSMutableDictionary *profile;
@property (weak, nonatomic) NSString *sex;


@end

@implementation BasicInfoVC

static UIImageView *circ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DoctorAppAppDelegate *appDelegate = (DoctorAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.profile = appDelegate.globalProfile;
    
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    
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

    
    self.basicInfoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.basicInfoView.layer.borderWidth = 1.0;
    
    self.maleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.maleLabel.layer.borderWidth = 1.0;
    self.femaleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.femaleLabel.layer.borderWidth = 1.0;
    self.maleLabel.userInteractionEnabled = YES;
    self.femaleLabel.userInteractionEnabled = YES;
    
    circ = [[UIImageView alloc] initWithFrame:CGRectMake(140, 90, 0, 0)];
    circ.clipsToBounds = YES;
    [self setRoundedView:circ toDiameter:70.0];
    [circ setBackgroundColor:[UIColor lightGrayColor]];
    [self.basicInfoView addSubview:circ];
    
    UILabel *editLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 70, 10)];
    editLabel.text = @"Edit";
    editLabel.textColor = [UIColor whiteColor];
    editLabel.font = [UIFont boldSystemFontOfSize:8];
    editLabel.textAlignment = NSTextAlignmentCenter;
    
    [editLabel setBackgroundColor:[UIColor colorWithRed:96.0f/255.0f green:118.0f/255.0f blue:143.0f/255.0f alpha:1.0f]];
    [circ addSubview:editLabel];
    
    UITapGestureRecognizer *tapMale =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(selectMale)];
    [self.maleLabel addGestureRecognizer:tapMale];
    
    UITapGestureRecognizer *tapFemale =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(selectFemale)];
    [self.femaleLabel addGestureRecognizer:tapFemale];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(changeProfilePicture)];
    singleFingerTap.numberOfTapsRequired = 1;
    [circ setUserInteractionEnabled:YES];
    [circ addGestureRecognizer:singleFingerTap];
    
    self.firstNameTxt.delegate = self;
    self.lastNameTxt.delegate = self;
    
    // set data
    self.firstNameTxt.text = self.profile[@"user_info"][@"firstname"][@"en_us"];
    self.lastNameTxt.text = self.profile[@"user_info"][@"lastname"][@"en_us"];
    UIImage *profileImage = [UIImage imageNamed:@"user"];
    NSString *photoPath = self.profile[@"user_info"][@"avatar"];
    if(photoPath.length > 0)
    {
        profileImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: photoPath]]];
    }
    [circ setImage:profileImage];
    NSString *gender = self.profile[@"profile"][@"gender"];
    if([gender isEqualToString:@"male"]) {
        self.femaleSelected.image = nil;
        self.sex = @"male";
    }
    else {
        self.maleSeleted.image = nil;
        self.sex = @"female";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    NSMutableDictionary *d = [self.profile[@"user_info"] mutableCopy];
    NSMutableDictionary *dd = [d[@"firstname"] mutableCopy];
    [dd setObject:self.firstNameTxt.text forKey:@"en_us"];
    [d setObject:dd forKey:@"firstname"];
    dd = [d[@"lastname"] mutableCopy];
    [dd setObject:self.lastNameTxt.text forKey:@"en_us"];
    [d setObject:dd forKey:@"lastname"];
    [self.profile setObject:d forKey:@"user_info"];
    
    d = [self.profile[@"profile"] mutableCopy];
    [d setObject:self.sex forKey:@"gender"];
    [self.profile setObject:d forKey:@"profile"];
    
    [self updateProfile];
    [self updateUserInfo];
}

- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)selectMale
{
    self.maleSeleted.image = [UIImage imageNamed:@"selected"];
    self.femaleSelected.image = nil;
    self.sex = @"male";
}
- (void)selectFemale
{
    self.maleSeleted.image = nil;
    self.femaleSelected.image = [UIImage imageNamed:@"selected"];
    self.sex = @"female";
}

- (void)changeProfilePicture
{
    //Do stuff here...
    NSLog(@"changing profile pic !!!");
    [self.takeController takePhotoOrChooseFromLibrary];
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    self.profileImage = photo;
    [self scaleAndRotateImage];
    [self updateProfilePic];
}

- (void)updateProfilePic
{
    [self startLoadingIndicator];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/sign_s3?s3_object_type=image/jpeg&s3_object_dest=profile&s3_object_name=1.jpg"]];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *requestResponse;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    if(jsonData)
    {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:jsonData
                         options:NSJSONReadingAllowFragments
                         error:&error];
        NSString *url, *awsAccessKey, *expires, *signature, *newurl;
        if (jsonObject != nil && error == nil){
            if ([jsonObject isKindOfClass:[NSDictionary class]]){
                url  = [jsonObject objectForKey:@"url"];
                awsAccessKey = [[[jsonObject objectForKey:@"AWS_ACCESS_KEY"] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                expires = [jsonObject objectForKey:@"expires"];
                signature = [[[jsonObject objectForKey:@"signature"] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                newurl = [NSString stringWithFormat:@"%@?AWSAccessKeyId=%@&Expires=%@&Signature=%@", url,awsAccessKey, expires, signature];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:[NSURL URLWithString:newurl]];
                [request setHTTPMethod:@"PUT"];
                [request setTimeoutInterval:5.0f];
                NSData *imageData = UIImageJPEGRepresentation(self.profileImage, 0.1);
                [request setHTTPBody:imageData];
                [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"public-read" forHTTPHeaderField:@"x-amz-acl"];
                [request setValue:[NSString stringWithFormat:@"%d", [imageData length]] forHTTPHeaderField:@"Content-Length"];
                
                NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
                if(jsonData)
                {
                    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         url, @"avatar",
                                         nil];
                    NSError *error = nil;
                    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/user/update_avatar"]];
                    [request setHTTPMethod:@"POST"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                    [request setHTTPBody:postData];
                    [request setTimeoutInterval:5];
                    
                    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
                    if(jsonData)
                    {
                        [circ setImage:self.profileImage];
                        [ProfileVC setCirc:self.profileImage];
                        [LeftVC setCirc:self.profileImage];
                        [BasicInfoVC setCirc:self.profileImage];
                    }
                    else
                        [self popError];
                    
                }
                else
                    [self popError];
            }
        }
    }
    else
        [self popError];
    [self stopLoadingIndicator];
}

- (void)scaleAndRotateImage {
    int kMaxResolution = 320;
    CGImageRef imgRef = self.profileImage.CGImage;
    UIImageOrientation orient = self.profileImage.imageOrientation;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    if (width <= kMaxResolution && height <= kMaxResolution && orient == UIImageOrientationUp) {
        return;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.profileImage = imageCopy;
}

+ (void)setCirc:(UIImage *)image
{
    circ.image = image;
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

- (void)updateProfile
{
    [self startLoadingIndicator];
    NSError *error = nil;
    NSLog(@"%@",self.profile);
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
    {
        
        [LeftVC setName:[NSString stringWithFormat:@"Dr. %@",self.lastNameTxt.text]];
        [self popBack];
    }
    else
        [self popNCError];

}

- (void)updateUserInfo
{
    [self startLoadingIndicator];
    NSMutableDictionary *d = [NSMutableDictionary new];
    NSMutableDictionary *dd = [NSMutableDictionary new];
    NSMutableDictionary *ddd = [NSMutableDictionary new];
    [ddd setObject:self.firstNameTxt.text forKey:@"en_us"];
    [dd setObject:ddd forKey:@"firstname"];
    
    ddd = [NSMutableDictionary new];
    [ddd setObject:self.lastNameTxt.text forKey:@"en_us"];
    [dd setObject:ddd forKey:@"lastname"];
    
    [d setObject:dd forKey:@"user_info"];
    
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:d options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/user/update_user_info"]];
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

- (void)popError
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return true;
}

-(void) slideFrame:(BOOL) up
{
    int movementDistance = 100;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
