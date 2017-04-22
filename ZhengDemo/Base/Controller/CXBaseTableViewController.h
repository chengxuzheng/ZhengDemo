//
//  CXBaseTableViewController.h
//  ZhengDemo
//
//  Created by Zheng on 2017/4/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXBaseViewController.h"

@interface CXBaseTableViewController : CXBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;


@end
