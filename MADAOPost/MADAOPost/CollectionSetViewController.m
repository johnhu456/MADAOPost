//
//  CollectionSetViewController.m
//  MADAOPost
//
//  Created by MADAO on 16/1/20.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "CollectionSetViewController.h"

#import "FHTool.h"
#import "FHTextView.h"

#import <Masonry.h>
@interface CollectionSetViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
/**名字输入框*/
@property (nonatomic, strong) FHTextView *ftfName;
/**baseUrl输入框*/
@property (nonatomic, strong) FHTextView *ftfBaseUrl;
@end

@implementation CollectionSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
}
- (void)setupComponent
{
    self.ftfName = [[FHTextView alloc] initWithLineTypeTip:@"Name:" placeHolder:@"请输入合集名称" lineColor:[UIColor blackColor] type:FHTextKeyboardTypeDefault];
    [self.view addSubview:self.ftfName];
    self.ftfName.y = 64.f + 5.f;
    
    self.ftfBaseUrl = [[FHTextView alloc] initWithLineTypeTip:@"BaseUrl:" placeHolder:@"请输入BaseUrl" lineColor:[UIColor blackColor] type:FHTextKeyboardTypeDefault];
    [self.view addSubview:self.ftfBaseUrl];
    self.ftfBaseUrl.width = [FHTool getCurrentWindow].width;
    self.ftfBaseUrl.x = 15.f;
    self.ftfBaseUrl.y = self.ftfName.maxY + 15.f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
