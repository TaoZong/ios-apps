//
//  TermsAndPrivaciesVC.m
//  DoctorApp
//
//  Created by Tao Zong on 11/20/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "TermsAndPrivaciesVC.h"

@interface TermsAndPrivaciesVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation TermsAndPrivaciesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,13080)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index"ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [webView.scrollView setScrollEnabled:NO];
    [self.scrollView addSubview:webView];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 13100);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
