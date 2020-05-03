//
//  GENAnimationSetionModel.swift
//  ZCocoa
//
//  Created by three stone 王 on 2019/8/29.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import RxDataSources

public struct GENAnimationSetionModel<ItemType: IdentifiableType & Equatable> {
    public var header: String
    public var items: [Item]
    
    public init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}

extension GENAnimationSetionModel : AnimatableSectionModelType {
    public typealias Item = ItemType
    
    public var identity: String {
        return header
    }
    
    public init(original: GENAnimationSetionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
