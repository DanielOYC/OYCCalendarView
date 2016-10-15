//
//  OYCCalendarView.m
//  OYCCalendarView
//
//  Created by cao on 16/10/14.
//  Copyright © 2016年 OYC. All rights reserved.
//

#import "OYCCalendarView.h"
#import "OYCCalendarViewCell.h"

@interface OYCCalendarView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UILabel *titleLabel; //日历头部视图的日期标签
@property(nonatomic,strong)NSArray *weekArray; //日历上的周几数组
@property(nonatomic,strong)UICollectionView *collectionView; //日历主视图
@property(nonatomic,strong)NSDate *currentDate;  //当前日期
@property(nonatomic,strong)NSCalendar *currentCalendar;

@end

@implementation OYCCalendarView

static NSString *const cellID = @"calendar";

static OYCCalendarView *_calendarView;
+(instancetype)sharedCalendar{
    if (!_calendarView) {
        _calendarView = [[OYCCalendarView alloc]init];
    }
    return _calendarView;
}

-(NSArray *)weekArray{
    return self.weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置日历头部视图
    [self setupTitleView];
    
    //设置日历主体视图
    [self setupCalenderView];
}

/**
 *  设置日历头部视图
 */
-(void)setupTitleView{
    
    CGFloat viewWidth = self.frame.size.width;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(25, 10, viewWidth - 2 * 25, 40)];
    [self addSubview:titleView];
    
    UIButton *previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    previousBtn.frame = CGRectMake(0, 0, 25, 40);
    [previousBtn setImage:[UIImage imageNamed:@"calendar_left"] forState:UIControlStateNormal];
    [previousBtn addTarget:self action:@selector(previousBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:previousBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(CGRectGetMaxX(titleView.frame) - 50, 0, 25, 40);
    [nextBtn setImage:[UIImage imageNamed:@"calendar_right"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:nextBtn];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(previousBtn.frame), 0, titleView.frame.size.width - 25 * 2, 40)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = [self getCurrentDate];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    [titleView addSubview:self.titleLabel];
}

-(NSDate *)currentDate{
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}

-(NSCalendar *)currentCalendar{
    if (!_currentCalendar) {
        _currentCalendar = [NSCalendar currentCalendar];
    }
    return _currentCalendar;
}

/**
 *  获取当前的日期
 */
-(NSString *)getCurrentDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM";
    return [formatter stringFromDate:self.currentDate];
}

/**
 *  设置日历主体视图
 */
-(void)setupCalenderView{
    
    CGFloat calendarViewWidth = self.frame.size.width;
    CGFloat calendarViewHeight = self.frame.size.height - CGRectGetMaxY(self.titleLabel.frame) - 5 * 2;
    
    UICollectionViewFlowLayout *calendarViewLayout = [[UICollectionViewFlowLayout alloc]init];
    calendarViewLayout.itemSize = CGSizeMake(calendarViewWidth / 7, calendarViewHeight / 7);
    calendarViewLayout.minimumInteritemSpacing = 0;
    calendarViewLayout.minimumLineSpacing = 0;
    
    UICollectionView *calendarView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 5, calendarViewWidth, calendarViewHeight) collectionViewLayout:calendarViewLayout];
    calendarView.backgroundColor = [UIColor whiteColor];
    [calendarView registerClass:[OYCCalendarViewCell class] forCellWithReuseIdentifier:cellID];
    calendarView.dataSource = self;
    calendarView.delegate = self;
    self.collectionView = calendarView;
    [self addSubview:calendarView];
}

#pragma mark -dataSouce
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
    }else{
        return 42;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OYCCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.title = self.weekArray[indexPath.item];
    }else{
        
        NSUInteger firstDay = [self.currentCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self.currentDate];
        
        if (indexPath.item < firstDay - 1) {
            cell.title = @"";
        }else{
            NSInteger lengtOfMonth = [self.currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.currentDate].length;
            if ((indexPath.item - (firstDay - 1) + 1) > lengtOfMonth) {
                cell.title = @"";
            }else
            cell.title = [NSString stringWithFormat:@"%ld",indexPath.item - (firstDay - 1) + 1];
        }
    }
    return cell;
}

/**
 *  向前按钮点击事件
 */
-(void)previousBtnClick{
    
    NSDateComponents *componets = [[NSDateComponents alloc]init];
    componets.month = -1;
    self.currentDate = [self.currentCalendar dateByAddingComponents:componets toDate:self.currentDate options:0];
    
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [self.collectionView reloadData];
    } completion:^(BOOL finished) {
        self.titleLabel.text = [self getCurrentDate];
    }];
    
}

/**
 *  向后按钮点击事件
 */
-(void)nextBtnClick{
    
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.month = +1;
    self.currentDate = [self.currentCalendar dateByAddingComponents:components toDate:self.currentDate options:0];
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [self.collectionView reloadData];
    } completion:^(BOOL finished) {
        self.titleLabel.text = [self getCurrentDate];
    }];
}

@end
