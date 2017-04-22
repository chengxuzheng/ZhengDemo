//
//  CXBaseTableViewController.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXBaseTableViewController.h"

@interface CXBaseTableViewController ()

@end

@implementation CXBaseTableViewController

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myTableView];
    
}

#pragma mark - Subviews
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - memory warning
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
