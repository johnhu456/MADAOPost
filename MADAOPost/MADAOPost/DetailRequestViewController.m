//
//  DetailRequestViewController.m
//  MADAOPost
//
//  Created by MADAO on 16/1/13.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "DetailRequestViewController.h"
#import "ParamsTableViewCell.h"
#import "DataManager.h"

#import "FHTool.h"

#import <YTKNetworkConfig.h>
#import <YTKRequest.h>
#import <MagicalRecord/MagicalRecord.h>

@interface DetailRequest : YTKRequest
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
    NSMutableDictionary *tempParams = [NSMutableDictionary new];
    for (int i = 0;i < self.requestModel.params.count;i ++) {
        NSDictionary *params = self.requestModel.params[i];
        [tempParams setValuesForKeysWithDictionary:params];
    }
    return tempParams;
}
@end


@interface DetailRequestViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UITextField *tfUrl;
@property (nonatomic, strong) NSNumber *method;

/**请求模型*/
@property (nonatomic, strong, readwrite) SingleRequest *request;
/**参数数组*/
@property (nonatomic, strong) NSMutableArray *argumentsMutaArray;
@end

@implementation DetailRequestViewController

static NSString *reuseID = @"paramsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRequest];
//    [SingleRequest MR_truncateAll];
    self.tfUrl.delegate = self;
    
    YTKNetworkConfig *networkConfig = [YTKNetworkConfig sharedInstance];
    [networkConfig setBaseUrl:@"https://192.168.0.12:8443"];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    networkConfig.securityPolicy = securityPolicy;
}
/**DataManager单例*/
- (DataManager *)dataManager
{
    return [DataManager sharedDataManager];
}
/**获取管理对象上下文*/
- (NSManagedObjectContext *)objectContext
{
    return [DataManager managedObjectContext];
}
/**获得当前的Request*/
#warning need to change
- (SingleRequest *)getCurrentRequest
{
    return [SingleRequest MR_findFirst];
}
/**request初始化*/
- (void)createRequest
{
    SingleRequest *request = [self getCurrentRequest];
    if (request == nil) {
#warning need to change
        NSDictionary *dic = @{@"baseUrl":@"https://192.168.0.12:8443",
                              @"method":@(0),
                              @"apiUrl":@"/api/user/login"
        };
        /**如果没有，则创建新的实体*/
        request = [SingleRequest MR_createEntity];
        request.baseUrl = [DataParser stringInDictionary:dic forKey:@"baseUrl"];
        request.method = dic[@"method"];
        request.apiUrl = [DataParser stringInDictionary:dic forKey:@"apiUrl"];
        [[self objectContext] MR_saveToPersistentStoreAndWait];
    }
    self.request = request;
    
    /**request 里参数集需要转换成array进行排序*/
    if(self.request.request_arguments)
    {
            /**排序*/
        NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:@"argumentID" ascending:YES];
        NSArray *sortArray = [NSArray arrayWithObject:sortDes];
        NSArray *argumentArray = [self.request.request_arguments sortedArrayUsingDescriptors:sortArray];
        self.argumentsMutaArray = [NSMutableArray new];
        for (Arguments *argument in argumentArray) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
            [dic setValue:argument.key forKey:@"key"];
            [dic setValue:argument.value forKey:@"value"];
            [dic setValue:argument.argumentID forKey:@"argumentID"];
            [self.argumentsMutaArray addObject:dic];
        }
    }
    else{
        self.argumentsMutaArray = [NSMutableArray new];
    }
    [self updateSubViews];
}
/**对视图进行更新*/
- (void)updateSubViews
{
    self.tfUrl.text = self.request.apiUrl;
    [self.typePicker selectRow:[self.request.method integerValue] inComponent:0 animated:YES];
    NSLog(@"%@",self.request.apiUrl);
    NSLog(@"=====%@",[SingleRequest MR_findAll]);
    [self.mainTableView reloadData];
}
/**对Request对象进行保存*/
- (void)saveRequestInData
{
    WEAK_SELF;
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        weakSelf.request.apiUrl = weakSelf.tfUrl.text;
        weakSelf.request.method = weakSelf.method;
    }];
    for (int i =0; i < self.argumentsMutaArray.count; i++) {
        Arguments *argument = [Arguments MR_findFirstByAttribute:@"argumentID" withValue:@(i)];
        NSDictionary *argumentDic = self.argumentsMutaArray[i];
        if (argument == nil) {
            argument = [Arguments MR_createEntity];
        }
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            argument.key = [DataParser stringInDictionary:argumentDic forKey:@"key"];
            argument.argumentID = [NSNumber numberWithInt:i];
            argument.value = [DataParser stringInDictionary:argumentDic forKey:@"value"];
        }];
        /**设置关联*/
        [[self getCurrentRequest] addRequest_argumentsObject:argument];
    };
    /**对结果进行保存*/
    [[self objectContext] MR_saveToPersistentStoreAndWait];
}
#pragma mark - UITableViewDataSource andDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.argumentsMutaArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParamsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[ParamsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.ptfKey.text = self.argumentsMutaArray[indexPath.row][@"key"];
        cell.ptfValue.text = self.argumentsMutaArray[indexPath.row][@"value"];
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
    self.method = [NSNumber numberWithInteger:row];
}
#pragma mark — Add Params
- (IBAction)addParamsButtonOnClicked:(UIBarButtonItem *)sender {

    [self.mainTableView beginUpdates];
    [self.mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.argumentsMutaArray.count
                                                                    inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    /**改变模型*/
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
    [self.argumentsMutaArray addObject:newDic];

    [self.mainTableView endUpdates];
    [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.argumentsMutaArray.count - 1
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (IBAction)saveButtonOnClicked:(id)sender {
    [self saveRequestInData];
}
- (IBAction)sendButtonOnClicked:(id)sender {
    for (int i = 0; i<self.argumentsMutaArray.count; i ++) {
        ParamsTableViewCell *paramsCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(paramsCell.ptfKey.text != nil){
            NSLog(@"%@",[self.argumentsMutaArray[i] class]);
            NSMutableDictionary *dic = self.argumentsMutaArray[i];
            [dic setValue:paramsCell.ptfKey.text forKey:@"key"];
            [dic setValue:paramsCell.ptfValue.text forKey:@"value"];
            [dic setValue:[NSNumber numberWithInt:i] forKey:@"argumentID"];
        }
    }
    [self saveRequestInData];
    NSLog(@"+++++%@",self.request);
    NSLog(@"======dic:%@",self.argumentsMutaArray);
    NSLog(@"!!!!!!%@",[Arguments MR_findAll]);
    NSLog(@"%@",[Arguments MR_findFirst]);
//    [self setupRequest];
}
- (void)setupRequest
{
//    DetailRequest *detailRequest = [[DetailRequest alloc] initWithRequestModel:self.requestModel];
//    [detailRequest startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        id response = [request responseJSONObject];
//        NSLog(@"%@",response);
//        NSLog(@"%@",response[@"errormsg"]);
//    } failure:^(YTKBaseRequest *request) {
//        NSLog(@"%@",(NSDictionary *)request);
//        NSLog(@"错误");
//    }];
}
#pragma mark - TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}
@end
