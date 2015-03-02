//
//  LeftVC.m
//  DoctorApp
//
//  Created by Tao Zong on 7/29/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "LeftVC.h"
#import "ShowVC.h"
#import "DoctorAppAppDelegate.h"
#import "ProfileVC.h"
#import "BasicInfoVC.h"
#import "Reachability.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>

@interface LeftVC () <FDTakeDelegate>

@end

@implementation LeftVC

static UIImageView *circ;
static UILabel *titleLabel;

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
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    [self showView];
}

- (void)showView
{
    [self getDoctorProfile];
//    NSLog(@"%@",self.profile);
    if([self.profile objectForKey:@"user_info"])
    {
        id p = self.profile[@"user_info"];
        if([p isKindOfClass:[NSDictionary class]])
        {
            if([p objectForKey:@"avatar"] != [NSNull null])
            {
                NSString *picURL = p[@"avatar"];
                //        NSLog(picURL);
                if(picURL)
                {
                    self.profileImage = [UIImage imageWithData:
                                         [NSData dataWithContentsOfURL:
                                          [NSURL URLWithString: picURL]]];
                }
            }
        }
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 5)
        return [UIScreen mainScreen].bounds.size.height - 470;
    else if(indexPath.row == 0)
        return 200;
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell setBackgroundColor:[UIColor colorWithRed:24.0f/255.0f green:48.0f/255.0f blue:66.0f/255.0f alpha:1.0f]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0) {
        circ = [[UIImageView alloc] initWithFrame:CGRectMake(125, 80, 0, 0)];
        circ.clipsToBounds = YES;
        [self setRoundedView:circ toDiameter:80.0];
        [circ setBackgroundColor:[UIColor lightGrayColor]];
        if(self.profileImage) {
            circ.image = self.profileImage;
        }
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(changeProfilePicture)];
        singleFingerTap.numberOfTapsRequired = 1;
        [circ setUserInteractionEnabled:YES];
        [circ addGestureRecognizer:singleFingerTap];
        [cell addSubview:circ];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 140, 150, 40)];
        titleLabel.text = [NSString stringWithFormat:@"Dr. %@", self.profile[@"user_info"][@"lastname"][@"en_us"]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:titleLabel];
        
    }
    else if(indexPath.row == 1) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 40)];
        [titleLabel setText:@"Profile"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:titleLabel];
        
    }
    else if(indexPath.row == 2) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 40)];
        [titleLabel setText:@"Cases"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:titleLabel];
        
    }
    else if(indexPath.row == 3) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 40)];
        [titleLabel setText:@"Settings"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:titleLabel];
        
    }
    else if(indexPath.row == 4) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 40)];
        [titleLabel setText:@"Terms & Privacies"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:titleLabel];
        
    }
    else if(indexPath.row == 6) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 40)];
        [titleLabel setText:@"Log out"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:titleLabel];
        
    }
//    NSLog(@"%f", cell.frame.size.width);
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row == 5) {
//        NSLog(@"Log Out !!!");
////        DoctorAppAppDelegate *appDelegate = (DoctorAppAppDelegate *)[[UIApplication sharedApplication] delegate];
////        [appDelegate.showVC.timeCount pause];
////        NSTimeInterval time = [appDelegate.showVC.timeCount getTimeCounted];
//        
////        NSString *inStr = [NSString stringWithFormat: @"%d", (int)time];
////        NSLog(inStr);
////        [appDelegate.showVC.timeCount reset];
//    }
//}

- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
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

- (void)getDoctorProfile
{
    self.profile = [[NSDictionary alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://ehr-v1-beta.herokuapp.com/api/v1/doctor/profile"]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:5];
    
    NSURLResponse *requestResponse;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    if(jsonData)
    {
        NSError *error = nil;
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
    
    else {
        [self popNCError];
    }
    
    
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
                        [BasicInfoVC setCirc:self.profileImage];
                        [LeftVC setCirc:self.profileImage];
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

+ (void)setName:(NSString *)name
{
    titleLabel.text = name;
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

- (void)popError
{
    NSString *errorMessage = @"Please check your internet connnection then try again.";
    if([self currentNetworkStatus])
    {
        errorMessage = @"Sorry for the inconvenience that our service is currently under maintainance. Please retry after a while. Thank you.";
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
        errorMessage = @"Sorry for the inconvenience that our service is currently under maintainance. Please retry after a while. Thank you.";
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
