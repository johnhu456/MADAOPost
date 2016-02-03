//
//  FHExpandTableViewCell.m
//  FHExpandTableView
//
//  Created by MADAO on 16/1/19.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHExpandTableViewCell.h"
#import "FHExpandCellIndicatorView.h"

@interface FHExpandTableViewCell ()

@property (nonatomic, strong) FHExpandCellIndicatorView *fhIndicatorView;
@end

@implementation FHExpandTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    _expand = NO;
    [self setupIndicatorView];

    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setExpand:(BOOL)expand
{
    _expand = expand;
    [self.fhIndicatorView setHidden:!expand];
}
- (void)setupIndicatorView
{
    const CGFloat width = 30.f;
    const CGFloat rightInsides = 15.f;
    self.fhIndicatorView = [[FHExpandCellIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame) - rightInsides, self.contentView.frame.size.height - width, width, width)];
    self.fhIndicatorView.indicatorColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.fhIndicatorView];
    if (self.expand) {
        self.fhIndicatorView.hidden = NO;
    }
    else
    {
        self.fhIndicatorView.hidden = YES;
    }
}
@end
