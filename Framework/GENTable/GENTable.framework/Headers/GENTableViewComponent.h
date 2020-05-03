//
//  GENTableView.h
//  GENTable
//
//  Created by 王磊 on 2020/4/23.
//  Copyright © 2020 王磊. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface GENEmptyView : UIView

- (void)emptyShow;

- (void)emptyHidden;

@end


typedef NS_ENUM(NSInteger ,GENBottomLineType) {
    
    GENBottomLineTypeNormal NS_SWIFT_NAME(normal),
    
    GENBottomLineTypeNone NS_SWIFT_NAME(none) ,
    
    GENBottomLineTypeCustom NS_SWIFT_NAME(custom)
};

@interface GENBaseTableViewCell : UITableViewCell

@property (nonatomic ,strong ,readonly) UIImageView *bottomView;

@property (nonatomic ,assign) GENBottomLineType bottomLineType;

- (void)commitInit;
@end

@interface GENTableHeaderView : UIView

- (void)commitInit;

@end
NS_ASSUME_NONNULL_END
