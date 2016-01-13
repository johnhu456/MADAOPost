//
//  DetailRequestViewController.m
//  MADAOPost
//
//  Created by MADAO on 16/1/13.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "DetailRequestViewController.h"
#import "ParamsTableViewCell.h"

@interface DetailRequestViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGFloat _count;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;

@end

@implementation DetailRequestViewController

static NSString *reuseID = @"paramsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 5;
}
#pragma mark - UITableViewDataSource andDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParamsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[ParamsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}
#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"GET";
    }
    else
        return @"POST";
}
#pragma mark — Add Params
- (IBAction)addParamsButtonOnClicked:(UIBarButtonItem *)sender {
    [self.mainTableView beginUpdates];
    
    [self.mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_count
                                                                    inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    _count++;
    [self.mainTableView endUpdates];
    [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_count - 1
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end
