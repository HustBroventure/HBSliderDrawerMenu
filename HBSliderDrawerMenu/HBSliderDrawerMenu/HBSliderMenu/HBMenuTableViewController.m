//
//  HBMenuTableViewController.m
//  HBSliderDrawerMenu
//
//  Created by wangfeng on 15/11/8.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import "HBMenuTableViewController.h"

@interface HBMenuTableViewController ()
@property (nonatomic, strong) NSArray* data;
@end

@implementation HBMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = @[@"first",@"second",@"third"];
    self.tableView.tableFooterView = [UIView new];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.data[indexPath.row];

    return cell;
}



@end
