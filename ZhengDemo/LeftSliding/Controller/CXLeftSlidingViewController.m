//
//  CXLeftSlidingViewController.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXLeftSlidingViewController.h"

#import "CXCuckoNavigtionController.h"
#import "CXCuckooHomeViewController.h"

@interface CXLeftSlidingViewController ()

@end

@implementation CXLeftSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableView Datasource Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = kRGB_COLOR(indexPath.row*10, indexPath.row*20, indexPath.row*25, 1);
    return cell;
}

#pragma mark - UITableView Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CXCuckooHomeViewController *chVC = [[CXCuckooHomeViewController alloc] init];
    CXCuckoNavigtionController *cNavVC = [[CXCuckoNavigtionController alloc] initWithRootViewController:chVC];
    [self presentViewController:cNavVC animated:YES completion:^{
        
    }];
    
}



@end
