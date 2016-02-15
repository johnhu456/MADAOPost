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
#import <SWTableViewCell.h>

@interface DetailRequest : YTKRequest
@property (nonatomic, weak) SingleRequest *request;
- (instancetype)initWithRequestModel:(SingleRequest *)request;
@end
@implementation DetailRequest
- (instancetype)initWithRequestModel:(SingleRequest *)request
{
    if(self = [super init])
    {
        self.request = request;
    }
    return self;
}
- (NSString *)requestUrl {
    return self.request.apiUrl;
}
- (YTKRequestMethod)requestMethod
{
    if ([self.request.method integerValue] == 1) {
        return YTKRequestMethodPost;
    }
    return YTKRequestMethodGet;
}
- (id)requestArgument
{
    return [self getArgumentsDicWithRequest:self.request];
}
- (NSDictionary *)getArgumentsDicWithRequest:(SingleRequest *)request
{
    if(request.request_arguments)
    {
        /**排序*/
        NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:@"argumentID" ascending:YES];
        NSArray *sortArray = [NSArray arrayWithObject:sortDes];
        NSArray *argumentArray = [self.request.request_arguments sortedArrayUsingDescriptors:sortArray];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:argumentArray.count];
        for (Arguments *argument in argumentArray) {
            [tempDic setValue:argument.value forKey:argument.key];
        }
        return tempDic;
    }
    return nil;
}
@end


@interface DetailRequestViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    BOOL _reload;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UITextField *tfUrl;
@property (nonatomic, strong) NSNumber *method;


/**参数数组*/
@property (nonatomic, strong) NSMutableArray *argumentsMutaArray;
@end

@implementation DetailRequestViewController

static NSString *reuseID = @"paramsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRequest];
    self.tfUrl.delegate = self;
    _reload = NO;
    
    YTKNetworkConfig *networkConfig = [YTKNetworkConfig sharedInstance];
    [networkConfig setBaseUrl:self.request.request_collection.collectionBaseUrl];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    networkConfig.securityPolicy = securityPolicy;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate collectionVCNeedReload:_reload];
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
- (SingleRequest *)getCurrentRequest
{
    return self.request;
}
/**request初始化*/
- (void)createRequest
{
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
    [self.mainTableView reloadData];
}
/**对Request对象进行保存*/
- (void)saveRequestInData
{
    /**设置本地字典数组内容*/
    for (int i = 0; i<self.argumentsMutaArray.count; i ++) {
        ParamsTableViewCell *paramsCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(paramsCell.ftfKey.textField.text != nil){
            NSMutableDictionary *dic = self.argumentsMutaArray[i];
            [dic setValue:paramsCell.ftfKey.textField.text forKey:@"key"];
            [dic setValue:paramsCell.ftfValue.textField.text forKey:@"value"];
            [dic setValue:[NSNumber numberWithInt:i] forKey:@"argumentID"];
        }
    }
    WEAK_SELF;
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        weakSelf.request.apiUrl = weakSelf.tfUrl.text;
        weakSelf.request.method = weakSelf.method;
    }];

    NSArray *argumentArray = [DataManager sortedArrayBySortNSSet:self.request.request_arguments withKeys:@[@"argumentID"] ascending:YES];
    for (int i =0; i < self.argumentsMutaArray.count; i++) {
        NSDictionary *argumentDic = self.argumentsMutaArray[i];
        Arguments *argument;
        if (argumentArray.count >= (i + 1)) {
            //防止越界
            argument= argumentArray[i];
        }else
            argument = [Arguments MR_createEntity];
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            argument.key = [DataParser stringInDictionary:argumentDic forKey:@"key"];
            argument.argumentID = [NSNumber numberWithInt:i];
            argument.value = [DataParser stringInDictionary:argumentDic forKey:@"value"];
        }];
        /**设置关联*/
        [[self getCurrentRequest] addRequest_argumentsObject:argument];
    };
    [[self objectContext] MR_saveToPersistentStoreAndWait];
    _reload = YES;
}
- (void)noSaveRequestInCoreData
{
    /**设置本地字典数组内容*/
    for (int i = 0; i<self.argumentsMutaArray.count; i ++) {
        ParamsTableViewCell *paramsCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(paramsCell.ftfKey.textField.text != nil){
            NSMutableDictionary *dic = self.argumentsMutaArray[i];
            [dic setValue:paramsCell.ftfKey.textField.text forKey:@"key"];
            [dic setValue:paramsCell.ftfValue.textField.text forKey:@"value"];
            [dic setValue:[NSNumber numberWithInt:i] forKey:@"argumentID"];
        }
    }
    self.request.apiUrl = self.tfUrl.text;
    self.request.method = self.method;
    NSArray *argumentArray = [DataManager sortedArrayBySortNSSet:self.request.request_arguments withKeys:@[@"argumentID"] ascending:YES];
    NSLog(@"%@",argumentArray);
    for (int i =0; i < self.argumentsMutaArray.count; i++) {
        NSDictionary *argumentDic = self.argumentsMutaArray[i];
        Arguments *argument;
        if (argumentArray.count >= (i + 1)) {
            //防止越界
            argument= argumentArray[i];
        }else
            argument = [Arguments MR_createEntity];
        argument.key = [DataParser stringInDictionary:argumentDic forKey:@"key"];
        argument.argumentID = [NSNumber numberWithInt:i];
        argument.value = [DataParser stringInDictionary:argumentDic forKey:@"value"];
        /**设置关联*/
        [[self getCurrentRequest] addRequest_argumentsObject:argument];
    };
    /**不在CoreData中进行保存*/
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
    }
    cell.ftfKey.textField.text = self.argumentsMutaArray[indexPath.row][@"key"];
    cell.ftfValue.textField.text = self.argumentsMutaArray[indexPath.row][@"value"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAK_SELF;
    /**先对本地字典进行修改*/
    /**解除关联*/
    Arguments *reomveArgument = self.argumentsMutaArray[indexPath.row];
    [self.argumentsMutaArray removeObjectAtIndex:indexPath.row];
    
    if(reomveArgument != nil)
    {
        [weakSelf.request removeRequest_argumentsObject:reomveArgument];
        [reomveArgument MR_deleteEntity];
        [[self objectContext] MR_saveToPersistentStoreAndWait];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - WidgetsAction
- (IBAction)saveButtonOnClicked:(id)sender {
    if ([self checkUrl]) {
        [self saveRequestInData];
    }
}
- (IBAction)sendButtonOnClicked:(id)sender {
    if ([self checkUrl]) {
        [self noSaveRequestInCoreData];
        [self setupRequest];
    }
}
- (BOOL)checkUrl
{
    /**判断URL是否含有空格*/
    if([self.tfUrl.text containsString:@" "])
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"Api Url不能包含空格" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}
- (void)setupRequest
{
    DetailRequest *detailRequest = [[DetailRequest alloc] initWithRequestModel:self.request];
    [detailRequest startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        id response = [request responseJSONObject];
        NSLog(@"%@",response);
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"错误");
    }];
}
#pragma mark - TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}
@end
