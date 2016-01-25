//
//  CollectionSetViewController.m
//  MADAOPost
//
//  Created by MADAO on 16/1/20.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "CollectionSetViewController.h"
#import "DetailRequestViewController.h"

#import "DataManager.h"
#import "FHTool.h"
#import "FHTextView.h"

#import <Masonry.h>
#import <MagicalRecord/MagicalRecord.h>

@interface CollectionSetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    /**首页数据是否需要更新*/
    BOOL _reload;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
/**名字输入框*/
@property (nonatomic, strong) FHTextView *ftfName;
/**baseUrl输入框*/
@property (nonatomic, strong) FHTextView *ftfBaseUrl;
/**Requests数组*/
@property (nonatomic, strong) NSMutableArray *requestsMutaArray;

@end

@implementation CollectionSetViewController
- (DataManager *)dataManager
{
    return [DataManager sharedDataManager];
}
- (NSManagedObjectContext *)objectContext
{
    return [DataManager managedObjectContext];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _reload = NO;
    [self getCollectionRequest];
    [self setupComponent];
    [self setNavigationItem];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.delegate mainVCNeedReload:_reload];
}
- (void)setupComponent
{
    UIWindow *window = [FHTool getCurrentWindow];
    self.ftfName = [[FHTextView alloc] initWithLineTypeTip:@"Name:" placeHolder:@"请输入合集名称" lineColor:[UIColor blackColor] size:CGSizeMake(window.width, 45.f) type:FHTextKeyboardTypeDefault];
    [self.view addSubview:self.ftfName];
    self.ftfName.y = 64.f + 5.f;
    
    self.ftfBaseUrl = [[FHTextView alloc] initWithLineTypeTip:@"BaseUrl:" placeHolder:@"请输入BaseUrl" lineColor:[UIColor blackColor] size:CGSizeMake(window.width, 45.f) type:FHTextKeyboardTypeDefault];
    [self.view addSubview:self.ftfBaseUrl];
    self.ftfBaseUrl.width = [FHTool getCurrentWindow].width;
    self.ftfBaseUrl.y = self.ftfName.maxY + 15.f;
    
    self.ftfBaseUrl.textField.text = self.collection.collectionBaseUrl;
    self.ftfName.textField.text = self.collection.collectionName;
}
- (void)setNavigationItem
{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonOnClicked:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}
- (void)getCollectionRequest
{
    self.requestsMutaArray = [[DataManager sortedArrayBySortNSSet:self.collection.collection_requests withKeys:@[@"requestID"] ascending:YES] mutableCopy];
}
#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.requestsMutaArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *requestCell = [tableView dequeueReusableCellWithIdentifier:@"requestCell"];
    if (requestCell == nil) {
        requestCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"requestCell"];
    }
    SingleRequest *currentRequest = self.requestsMutaArray[indexPath.row];
    requestCell.textLabel.text = [NSString stringWithFormat:@"%@",currentRequest.requestID];
    return requestCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleRequest *selectedRequest = self.requestsMutaArray[indexPath.row];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailRequestViewController *requestDetailVC = [board instantiateViewControllerWithIdentifier:@"DetailRequestVC"];
    requestDetailVC.request = selectedRequest;
    [self.navigationController pushViewController:requestDetailVC animated:YES];
}
#pragma mark - WidgetsAction
- (IBAction)addRequestButtonOnClicked:(UIBarButtonItem *)sender {

    [self.mainTableView beginUpdates];
    
    /**增加模型*/
    SingleRequest *request = [SingleRequest MR_createEntityInContext:[self objectContext]];
    request.baseUrl = self.ftfBaseUrl.textField.text;
    request.requestID = [NSNumber numberWithInteger:self.requestsMutaArray.count];
    [self.collection addCollection_requestsObject:request];
    [[self objectContext] MR_saveToPersistentStoreAndWait];
    self.requestsMutaArray = [[DataManager sortedArrayBySortNSSet:self.collection.collection_requests withKeys:@[@"requestID"] ascending:YES] mutableCopy];
  
    [self.mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.requestsMutaArray.count - 1
                                                                    inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    [self.mainTableView endUpdates];
    
    
    [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.requestsMutaArray.count - 1
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)saveButtonOnClicked:(UIBarButtonItem *)button
{
    WEAK_SELF;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        RequestCollection *collection = [weakSelf.collection MR_inContext:localContext];
        collection.collectionName = weakSelf.ftfName.textField.text;
        collection.collectionBaseUrl = weakSelf.ftfBaseUrl.textField.text;
    }];
    _reload = YES;
}


@end
