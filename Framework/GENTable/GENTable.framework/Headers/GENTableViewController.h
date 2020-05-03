//
//  GENTableViewController.h
//  GENTable
//
//  Created by 王磊 on 2020/4/23.
//  Copyright © 2020 王磊. All rights reserved.
//

@import GENLoading;
@import MJRefresh;
#import "GENTableViewComponent.h"
NS_ASSUME_NONNULL_BEGIN

@interface GENTableLoadingViewController : GENLoadingViewController

@property (nonatomic ,strong) UITableView *tableView;

- (UITableViewCell *)configTableViewCell:(id)data forIndexPath:(NSIndexPath *)ip ;

- (UIView *)configTableViewSectionHeader:(id)data forSection:(NSInteger)section ;

- (CGFloat )caculateForCell:(id )data forIndexPath:(NSIndexPath *)ip ;

- (void)tableViewSelectData:(id)data forIndexPath:(NSIndexPath *)ip;

- (void)tableViewEmptyShow;

- (void)tableViewEmptyHidden;
@end

@interface GENTableNoLoadingViewController : GENTViewController

@property (nonatomic ,strong) UITableView *tableView;

- (UITableViewCell *)configTableViewCell:(id)data forIndexPath:(NSIndexPath *)ip ;

- (UIView *)configTableViewSectionHeader:(id)data forSection:(NSInteger)section ;

- (CGFloat )caculateForCell:(id )data forIndexPath:(NSIndexPath *)ip;

- (void)tableViewSelectData:(id)data forIndexPath:(NSIndexPath *)ip;

@property (nonatomic ,strong) GENTableHeaderView *headerView;

@end
NS_ASSUME_NONNULL_END
