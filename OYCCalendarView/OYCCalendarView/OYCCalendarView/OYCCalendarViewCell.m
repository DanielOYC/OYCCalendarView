//
//  OYCCalendarViewCell.m
//  OYCCalendarView
//
//  Created by cao on 16/10/14.
//  Copyright © 2016年 OYC. All rights reserved.
//

#import "OYCCalendarViewCell.h"

@interface OYCCalendarViewCell()

@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation OYCCalendarViewCell

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLabel.text = title;
}

@end
