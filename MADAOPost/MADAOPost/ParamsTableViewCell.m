//
//  ParamsTableViewCell.m
//  MADAOPost
//
//  Created by MADAO on 16/1/13.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "ParamsTableViewCell.h"
#import "ParamsTextField.h"
#import <Masonry.h>


@interface ParamsTableViewCell ()
{
    
}
@property (nonatomic, strong) UILabel *lblKey;
@property (nonatomic, strong) UILabel *lblValue;
@property (nonatomic, strong) ParamsTextField *ptfKey;
@property (nonatomic, strong) ParamsTextField *ptfValue;
@end
@implementation ParamsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.ptfKey = [[ParamsTextField alloc] initWithLabelText:@"Key:" andPlaceHolder:@"请输入参数名"];
        self.ptfValue = [[ParamsTextField alloc] initWithLabelText:@"Value:" andPlaceHolder:@"请输入值"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self masonryLayout];
    }
    return self;
}
- (void)masonryLayout
{
    [self.contentView addSubview:self.ptfKey];
    [self.ptfKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.contentView);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.contentView addSubview:self.ptfValue];
    [self.ptfValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(30.f);
        make.top.equalTo(self.ptfKey.mas_bottom).with.offset(5.f);
    }];
}
- (void)drawRect:(CGRect)rect
{
    
}

@end
