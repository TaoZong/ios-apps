//
//  FirstLaunchVC.m
//  DoctorApp
//
//  Created by Tao Zong on 8/9/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "FirstLaunchVC.h"


@interface FirstLaunchVC ()

@end

@implementation FirstLaunchVC

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

//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index"ofType:@"html"];
//    UITextView *body = [[UITextView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,8000)];
//    NSError *error = nil;
//    NSString* str = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
//    [body setText:[self stringByConvertingHTMLToPlainText:str]];
//    [body setEditable: NO];
//    [body setSelectable:NO];
//    [body setScrollEnabled:NO];
//
//    [self.scrollView addSubview:body];
    
    self.scrollView.layer.borderWidth = 1;
    self.scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,280,14500)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index"ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [webView.scrollView setScrollEnabled:NO];
    [self.scrollView addSubview:webView];
    
    self.scrollView.contentSize = CGSizeMake(280, 14500);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)acceptTerms:(id)sender {
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:YES forKey:@"iHaveAcceptedTheTerms"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInVC *svc = [storyboard instantiateViewControllerWithIdentifier:@"SignInVC"];
    [self presentViewController:svc animated:YES completion:nil];
}


- (NSString *)stringByConvertingHTMLToPlainText: (NSString *)myHTML
{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:[myHTML dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    return [attrString string];
}

@end
