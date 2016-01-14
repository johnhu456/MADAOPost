//
//  DetailRequestViewController.m
//  MADAOPost
//
//  Created by MADAO on 16/1/13.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "DetailRequestViewController.h"
#import "ParamsTableViewCell.h"

#import <YTKNetworkConfig.h>
#import <YTKBaseRequest.h>

@interface DetailRequest : YTKBaseRequest
@property (nonatomic, weak) RequestModel *requestModel;
- (instancetype)initWithRequestModel:(RequestModel *)model;
@end
@implementation DetailRequest
- (instancetype)initWithRequestModel:(RequestModel *)model
{
    if(self = [super init])
    {
        self.requestModel = model;
    }
    return self;
}
- (NSString *)requestUrl {
    return self.requestModel.apiUrl;
//    return @"/api/user/login";
}
- (YTKRequestMethod)requestMethod
{
    if (self.requestModel.isPost) {
        return YTKRequestMethodPost;
    }
    return YTKRequestMethodGet;
}
- (id)requestArgument
{
    return self.requestModel.paramsDic;
}
@end


@interface DetailRequestViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSInteger _count;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UITextField *tfUrl;

@end

@implementation DetailRequestViewController

static NSString *reuseID = @"paramsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tfUrl.delegate = self;
    
    YTKNetworkConfig *networkConfig = [YTKNetworkConfig sharedInstance];
    [networkConfig setBaseUrl:@"http://192.168.0.12:8080"];
    self.requestModel = [[RequestModel alloc] init];
}
#pragma mark - UITableViewDataSource andDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    _count = self.requestModel.paramsDic.allKeys.count;
    if (_count == 0) {
        _count = 1;
//        [self.requestModel.paramsDic setValue:@"123" forKey:[NSString stringWithFormat:@"%ld",(long)_count]];
    }
    return _count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParamsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[ParamsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.ptfValue.tag = 0;
        cell.ptfKey.tag = 1;
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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        self.requestModel.isPost = NO;
    }
    else
        self.requestModel.isPost = YES;
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
- (IBAction)sendButtonOnClicked:(id)sender {
    for (int i = 0; i<_count; i ++) {
        ParamsTableViewCell *paramsCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(paramsCell.ptfKey.text != nil){
            [self.requestModel.paramsDic setObject:paramsCell.ptfValue.text forKey:paramsCell.ptfKey.text];
        }
    }
    [self setupRequest];
}
- (void)setupRequest
{
    DetailRequest *detailRequest = [[DetailRequest alloc] initWithRequestModel:self.requestModel];
    [detailRequest startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        id response = [request responseJSONObject];
        NSLog(@"%@",response);
    } failure:^(YTKBaseRequest *request) {
        
    }];
}
#pragma mark - TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.requestModel.apiUrl = textField.text;
}
@end
