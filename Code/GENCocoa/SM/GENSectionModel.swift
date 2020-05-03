//
//  SectionModel.swift
//  ZCocoa
//
//  Created by three stone 王 on 2019/8/29.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import RxDataSources

public struct GENSectionModel<Section, ItemType> {
    public var model: Section
    public var items: [Item]
    
    public init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
}

extension GENSectionModel: SectionModelType {
    public typealias Identity = Section
    public typealias Item = ItemType
    
    public var identity: Section {
        return model
    }
}

extension GENSectionModel: CustomStringConvertible {
    
    public var description: String {
        return "\(self.model) -> \(items)"
    }
}

extension GENSectionModel {
    public init(original: GENSectionModel<Section, Item>, items: [Item]) {
        self.model = original.model
        self.items = items
    }
}
