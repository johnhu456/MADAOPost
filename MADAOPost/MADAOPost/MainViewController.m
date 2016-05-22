//
//  MainViewController.m
//  MADAOPost
//
//  Created by MADAO on 16/1/20.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "MainViewController.h"
#import "DetailRequestViewController.h"
#import "CollectionSetViewController.h"
#import "RequestCollection+CoreDataProperties.h"
#import "FHExpandTableView.h"

#import "FHTool.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DataManager.h"

@interface MainViewController ()<FHExpandTableViewDelegate,CollectionSetVCDelegate>
{
    NSArray *_collections;
}
/**数据数组(用来Expand)*/
@property (nonatomic, strong) NSMutableArray *collectionArray;
/**TableView*/
@property (nonatomic, strong) FHExpandTableView *expandTableView;
@end

@implementation MainViewController
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
//    [RequestCollection MR_truncateAll];
    [self findRequestCollection];
    [self setupExpandTableView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.expandTableView reloadData];
}
- (void)findRequestCollection
{   /**从数据库中查找请求合集,按升序排列*/
    _collections = [[RequestCollection MR_findAllSortedBy:@"collectionID" ascending:YES] copy];
    self.collectionArray = [[NSMutableArray alloc] initWithCapacity:_collections.count];
    /**为空情况下*/
    if (_collections.count == 0) {
        self.collectionArray = [NSMutableArray new];
        /**创建一个空的Collection*/
        RequestCollection *newCollection = [RequestCollection MR_createEntity];
        newCollection.collectionName = @"New Collection";
        newCollection.collectionID = [NSNumber numberWithInt:0];
//==========================================================
#warning todo
        [[self objectContext] MR_saveToPersistentStoreAndWait];
        
        /**数据包装*/
        NSArray *tempArray = [DataManager sortedArrayBySortNSSet:newCollection.collection_requests withKeys:@[@"requestID"] ascending:YES];
        tempArray = [DataManager expendArray:tempArray withObject:newCollection atIndex:0];
        [self.collectionArray addObject:tempArray];
        _collections = [NSArray arrayWithObject:newCollection];
    }
    else
    {
        for (RequestCollection *collection in _collections) {
            /**获取Collection下Request数组*/
            NSArray *requestArray = [DataManager sortedArrayBySortNSSet:collection.collection_requests withKeys:@[@"requestID"] ascending:YES];
            /**数据包装*/
            NSArray *newRequestArray = [DataManager expendArray:requestArray withObject:collection atIndex:0];
            [self.collectionArray addObject:newRequestArray];
        }
    }
}
- (void)setupExpandTableView
{
    self.expandTableView = [[FHExpandTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.expandTableView.expandDelegate = self;
    self.expandTableView.dataArray = self.collectionArray;
    [self.view addSubview:self.expandTableView];
}
#pragma mark - FHExpandTableViewDelegate
- (void)expandTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return;
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailRequestViewController *detailRequestVC = [board instantiateViewControllerWithIdentifier:@"DetailRequestVC"];
    RequestCollection *collection = _collections[indexPath.section];
    SingleRequest *request = [DataManager sortedArrayBySortNSSet:collection.collection_requests withKeys:@[@"requestID"] ascending:YES][indexPath.row - 1];
    detailRequestVC.request = request;
    [self.navigationController pushViewController:detailRequestVC animated:YES];
    
}
- (void)expandTableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CollectionSetViewController *collectionSetVC = [board instantiateViewControllerWithIdentifier:@"CollectionSetVC"];
        collectionSetVC.delegate = self;
        collectionSetVC.collection = _collections[indexPath.section];
        [self.navigationController pushViewController:collectionSetVC animated:YES];
    }
}
/**每一个Cell的标题描述*/
- (NSString *)descriptionForRowAtIndexPath:(NSIndexPath *)indexPath withObj:(id)obj;
{
    if(indexPath.row == 0)
    {
        if ([obj isKindOfClass:[RequestCollection class]]) {
            RequestCollection *collection = obj;
            return collection.collectionName;
        }
    }
    else
    {
        if ([obj isKindOfClass:[SingleRequest class]]) {
                SingleRequest *request = obj;
                return request.apiUrl;
        }
    }
    return [NSString stringWithFormat:@"%@",[obj class]];
}
#pragma mark - CollectionVCDelegate
- (void)mainVCNeedReload:(BOOL)reload
{
    if (reload) {
        [self findRequestCollection];
        [self.expandTableView updateDataWithArray:self.collectionArray];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
