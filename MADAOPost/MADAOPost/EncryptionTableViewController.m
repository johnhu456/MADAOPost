//
//  EncryptionTableViewController.m
//  MADAOPost
//
//  Created by MADAO on 16/2/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "EncryptionTableViewController.h"
#import "EncryptTableViewCell.h"

#import "Arguments.h"

@interface EncryptionTableViewController ()

@property (nonatomic, strong) NSArray *argumentArray;

@end

@implementation EncryptionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EncryptTableViewCell" bundle:nil] forCellReuseIdentifier:@"encryptCell"];
    self.argumentArray = [self getArgumentsArrayWithRequest:self.request];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Model
/**获取参数数组*/
- (NSArray *)getArgumentsArrayWithRequest:(SingleRequest *)request
{
    if(request.request_arguments)
    {
        /**排序*/
        NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:@"argumentID" ascending:YES];
        NSArray *sortArray = [NSArray arrayWithObject:sortDes];
        NSArray *argumentArray = [self.request.request_arguments sortedArrayUsingDescriptors:sortArray];
        return argumentArray;
    }
    return nil;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.argumentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EncryptTableViewCell *encryptCell = [tableView dequeueReusableCellWithIdentifier:@"encryptCell"];
    Arguments *currentArgu = self.argumentArray[indexPath.row];
    [encryptCell setArgumentName:currentArgu.key];
    return encryptCell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
