//
//  ParamsTableViewCell.m
//  MADAOPost
//
//  Created by MADAO on 16/1/13.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "ParamsTableViewCell.h"
#import "FHTool.h"
#import <Masonry.h>


@interface ParamsTableViewCell ()
{
    
}
@property (nonatomic, strong) UILabel *lblKey;
@property (nonatomic, strong) UILabel *lblValue;

@end
@implementation ParamsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.ptfKey = [[ParamsTextField alloc] initWithLabelText:@"Key:" andPlaceHolder:@"请输入参数名"];
//        self.ptfValue = [[ParamsTextField alloc] initWithLabelText:@"Value:" andPlaceHolder:@"请输入值"];
        UIWindow *window = [FHTool getCurrentWindow];
        self.ftfKey = [[FHTextView alloc] initWithLineTypeTip:@"Key:" placeHolder:@"请输入参数名" lineColor:FH_ColorWith(188,187,193,1) size:CGSizeMake(window.width, 30) type:FHTextKeyboardTypeDefault];
        self.ftfValue = [[FHTextView alloc] initWithLineTypeTip:@"Value:" placeHolder:@"请输入值" lineColor: FH_ColorWith(188,187,193,1) size:CGSizeMake(window.width, 30) type:FHTextKeyboardTypeDefault];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self masonryLayout];
    }
    return self;
}
- (void)masonryLayout
{
    [self.contentView addSubview:self.ftfKey];
    [self.ftfKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.contentView);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.contentView addSubview:self.ftfValue];
    [self.ftfValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(30.f);
        make.top.equalTo(self.ftfKey.mas_bottom).with.offset(5.f);
    }];
}
- (void)drawRect:(CGRect)rect
{
    
}

@end
