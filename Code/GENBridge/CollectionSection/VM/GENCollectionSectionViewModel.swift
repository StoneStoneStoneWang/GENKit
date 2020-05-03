//
//  GENCollectionSectionViewModel.swift
//  GENBridge
//
//  Created by 王磊 on 2020/3/31.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import GENViewModel
import RxSwift
import RxCocoa

@objc (GENCollectionSectionBean)
public final class GENCollectionSectionBean: NSObject {
    
    @objc public var sTag: Int = 0
    
    @objc public var items: [GENCollectionItemBean] = []
    
    @objc public var title: String = ""
    
    @objc public static func createSection(_ sTag: Int,title: String ,items: [GENCollectionItemBean]) -> GENCollectionSectionBean {
        
        let section = GENCollectionSectionBean()
        
        section.sTag = sTag
        
        section.title = title
        
        section.items += items
        
        return section
    }
    private override init() { }
}

@objc (GENCollectionItemBean)
public final class GENCollectionItemBean: NSObject {
    
    @objc public var iTag: Int = 0
    
    @objc public var title: String = ""
    
    @objc public var icon: String = ""
    
    @objc public var isSelected: Bool = false
    
    @objc public var placeholder: String = ""
    
    @objc public var image: String = ""
    
    @objc public var value: String = ""
    
    @objc public static func createItem(_ iTag: Int,title: String ,icon: String) -> GENCollectionItemBean {
        
        return GENCollectionItemBean .createItem(iTag, title: title, icon: icon, isSelected: false, placeholder: "")
    }
    @objc public static func createItem(_ iTag: Int,title: String ,icon: String,isSelected: Bool ,placeholder: String) -> GENCollectionItemBean {
        
        let item = GENCollectionItemBean()
        
        item.iTag = iTag
        
        item.title = title
        
        item.icon = icon
        
        item.placeholder = placeholder
        
        item.isSelected = isSelected
        
        return item
    }
    
    private override init() { }
}

struct GENCollectionSectionViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<GENCollectionItemBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let sections: [GENCollectionSectionBean]
    }
    
    struct WLOutput {
        // 获取轮播图序列
        let zip: Observable<(GENCollectionItemBean,IndexPath)>
        
        let collectionData: BehaviorRelay<[GENCollectionSectionBean]> = BehaviorRelay<[GENCollectionSectionBean]>(value:[])
    }
    
    init(_ input: WLInput ) {
        
        self.input = input
        
        output = WLOutput(zip: Observable.zip(input.modelSelect,input.itemSelect))
        
        output.collectionData.accept(input.sections)
    }
}
