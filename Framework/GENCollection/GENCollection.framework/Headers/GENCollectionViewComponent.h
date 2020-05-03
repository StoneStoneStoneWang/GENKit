//
//  GENCollectionViewComponent.h
//  GENCollection
//
//  Created by 王磊 on 2020/4/23.
//  Copyright © 2020 王磊. All rights reserved.
//

@import UIKit;
NS_ASSUME_NONNULL_BEGIN

@interface GENBaseCollectionViewCell : UICollectionViewCell

- (void)commitInit;

@end

@interface GENCollectionFooterView : UICollectionReusableView

@end

@interface GENCollectionHeaderView : UICollectionReusableView

@end

@interface GENCollectionEmptyView : UIView

- (void)emptyShow;

- (void)emptyHidden;

@end

NS_ASSUME_NONNULL_END
