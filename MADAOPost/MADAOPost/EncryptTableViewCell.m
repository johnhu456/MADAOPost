//
//  EncryptTableViewCell.m
//  MADAOPost
//
//  Created by MADAO on 16/2/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "EncryptTableViewCell.h"

@interface EncryptTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UIButton *btnMD5;

@property (weak, nonatomic) IBOutlet UIButton *btnDES;


@end

@implementation EncryptTableViewCell
- (void)setArgumentName:(NSString *)argumentName
{
    _argumentName = argumentName;
    self.lblName.text = _argumentName;
}
- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - WidgetsActions
- (IBAction)btnMD5OnClicked:(id)sender {
    self.btnMD5.selected = !self.btnMD5.selected;
}
- (IBAction)btnDESOnClicked:(id)sender {
    self.btnDES.selected = !self.btnDES.selected;
}

@end
