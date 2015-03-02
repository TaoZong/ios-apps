//
//  NoteVC.m
//  DoctorApp
//
//  Created by Tao Zong on 10/24/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "NoteVC.h"

@interface NoteVC ()
@property (weak, nonatomic) IBOutlet UITextView *bodyText;
@property UIBarButtonItem *doneBt;
@end

@implementation NoteVC

static int myFont = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(self.keyString);
    // Do any additional setup after loading the view.
    
    // load user font
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userFont.xml"];
    NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
    if(readData)
    {
        NSString *fontString = readData[@"fontsize"];
        myFont = [fontString intValue];
    }
    
    if(![self.keyString isEqualToString:@"-1"])
    {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/doctorNotes.xml"];
        NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
        if(readData)
        {
            NSDictionary *d = [readData objectForKey:self.keyString];
            self.bodyText.text = d[@"text"];
        }
    }
        
    self.bodyText.font = [UIFont systemFontOfSize:myFont];
    [self.bodyText becomeFirstResponder];
    
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
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"NOTE";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
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
    if(self.bodyText.text.length > 0)
    {
        int temp = 0;
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/doctorNotes.xml"];
        NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
        NSMutableDictionary *writeData;
        if(readData)
        {
            temp = [readData count];
            writeData = [readData mutableCopy];
        }
        else
            writeData = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        NSDate *currentDate = [[NSDate alloc] init];
        
        [tmpDict setValue:self.bodyText.text forKey:@"text"];
        [tmpDict setValue:[NSString stringWithFormat:@"%@",currentDate] forKey:@"time"];
        
        if(![self.keyString isEqualToString:@"-1"])
        {
            [writeData setValue:[tmpDict copy] forKey:self.keyString];
            NSLog(@"%@",writeData);
            BOOL result = [[writeData copy] writeToFile: path atomically:YES];
            NSLog(@"%@", result ? @"modify note saved" : @"modify note not saved");
        }
        else{
            [writeData setValue:[tmpDict copy] forKey:[NSString stringWithFormat:@"%d",temp]];
            NSLog(@"%@",writeData);
            BOOL result = [[writeData copy] writeToFile: path atomically:YES];
            NSLog(@"%@", result ? @"new note saved" : @"new note not saved");
        }
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
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
