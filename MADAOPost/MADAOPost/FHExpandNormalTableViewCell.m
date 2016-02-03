//
//  FHExpandNormalTableViewCell.m
//  MADAOPost
//
//  Created by MADAO on 16/2/3.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHExpandNormalTableViewCell.h"

@implementation FHExpandNormalTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
