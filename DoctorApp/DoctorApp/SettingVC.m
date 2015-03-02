//
//  SettingVC.m
//  DoctorApp
//
//  Created by Tao Zong on 10/24/14.
//  Copyright (c) 2014 MoreHealth. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC () <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *changeFontBt;

@end

@implementation SettingVC

NSArray *pickerArray, *fontArray;
UIPickerView *myPickerView;
static int myFont;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"SETTINGS";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    // load user font
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userFont.xml"];
    NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
    if(readData)
    {
        NSString *fontString = readData[@"fontsize"];
        myFont = [fontString intValue];
    }
    
    [self.changeFontBt addTarget:self action:@selector(changeFont) forControlEvents:UIControlEventTouchUpInside];
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

-(void)changeFont
{
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViews:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    pickerArray = [[NSArray alloc]initWithObjects:@"Small",@"Middle",
                   @"Large",nil];
    fontArray = [[NSArray alloc]initWithObjects:[UIFont systemFontOfSize:12], [UIFont systemFontOfSize:16], [UIFont systemFontOfSize:20], nil];
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 162)];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.tag = 10;
    myPickerView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    int selectedRow = 0;
    if(myFont == 16)
        selectedRow = 1;
    if(myFont == 20)
        selectedRow = 2;
    [myPickerView selectRow:selectedRow inComponent:0 animated:YES];
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-162-44, 320, 44);
    CGRect fontPickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-162, 320, 162);

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done)];
    doneButton.tintColor = [UIColor blackColor];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    toolBar.tag = 11;
    NSArray *toolbarItems = [NSArray arrayWithObjects: 
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    
    [self.view addSubview:myPickerView];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    darkView.alpha = 0.5;
    [myPickerView setFrame:fontPickerTargetFrame];
    [toolBar setFrame:toolbarTargetFrame];
    [UIView commitAnimations];
    
    
}

- (void)done {
    NSMutableDictionary *writeData = [[NSMutableDictionary alloc] init];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userFont.xml"];
    
    [writeData setValue:[NSString stringWithFormat:@"%d", myFont] forKey:@"fontsize"];
    BOOL result = [[writeData copy] writeToFile: path atomically:YES];
    NSLog(@"%@", result ? @"modify font saved" : @"modify font not saved");
    
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 162);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}


#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if(row == 0)
        myFont = 12;
    else if(row == 1)
        myFont = 16;
    else
        myFont = 20;
}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
//(NSInteger)row forComponent:(NSInteger)component{
//    return [pickerArray objectAtIndex:row];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        tView.text = [pickerArray objectAtIndex:row];
        tView.font = [fontArray objectAtIndex:row];
        tView.textAlignment = NSTextAlignmentCenter;
    }
    
    return tView;
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
