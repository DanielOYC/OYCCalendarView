//
//  ViewController.m
//  OYCCalendarView
//
//  Created by cao on 16/10/14.
//  Copyright © 2016年 OYC. All rights reserved.
//

#import "ViewController.h"
#import "OYCCalendarView.h"

#define OYCScreenWidth [UIScreen mainScreen].bounds.size.width
#define OYCMargin 5
#define OYCCalendarWidth (OYCScreenWidth - OYCMargin * 2)
#define OYCCalendarHeight (OYCCalendarWidth * 1.1)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    OYCCalendarView *calendarView = [OYCCalendarView sharedCalendar];
    calendarView.frame = CGRectMake(OYCMargin, 100, OYCCalendarWidth, OYCCalendarHeight);
    [self.view addSubview:calendarView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
