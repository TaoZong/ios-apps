//
//  ActionsVC.m
//  DoctorApp
//
//  Created by Tao Zong on 11/19/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "ActionsVC.h"
#import "CommentVC.h"
#import "TeamVC.h"
#import "IssueVC.h"

@interface ActionsVC ()
@property (weak, nonatomic) NSString* tag;
@end

@implementation ActionsVC

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
    self.tag = @"";
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

- (IBAction)makeComment:(id)sender {
    self.tag = @"comment";
    [self performSegueWithIdentifier:@"commentVC" sender:self];
    
}
- (IBAction)leaveRequirement:(id)sender {
    self.tag = @"requirement";
    [self performSegueWithIdentifier:@"commentVC" sender:self];
    
}
- (IBAction)team:(id)sender {
    [self performSegueWithIdentifier:@"teamVC" sender:self];
}
- (IBAction)issue:(id)sender {
    [self performSegueWithIdentifier:@"issueVC" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"commentVC"]) {
        CommentVC *targetVC = (CommentVC*)segue.destinationViewController;
        targetVC.caseid = self.caseid;
        targetVC.tag = self.tag;
    }
    if ([[segue identifier] isEqualToString:@"teamVC"]) {
        TeamVC *targetVC = (TeamVC*)segue.destinationViewController;
        targetVC.caseid = self.caseid;
    }
    if ([[segue identifier] isEqualToString:@"issueVC"]) {
        IssueVC *targetVC = (IssueVC*)segue.destinationViewController;
        targetVC.caseid = self.caseid;
    }
}


@end
