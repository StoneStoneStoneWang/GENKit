//
//  GENCarouselViewModel.swift
//  GENBridge
//
//  Created by three stone 王 on 2020/3/12.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENViewModel
import RxCocoa
import RxSwift
import WLToolsKit
import ObjectMapper

@objc public final class GENCarouselBean: NSObject , Mappable{
    public init?(map: Map) {
        
        
    }
    
    @objc public static func createCarousel(_ title: String ,icon: String) -> GENCarouselBean {
        
        let carousel = GENCarouselBean()
        
        carousel.title = title
        
        carousel.icon = icon
        
        return carousel
    }
    
    public func mapping(map: Map) {
        
        title <- map["title"]
        
        icon <- map["icon"]
    }
    
    @objc public var title: String = ""
    
    @objc public var icon: String = ""
    
    private override init() { }
}

struct GENCarouselViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<GENCarouselBean>
        
        let itemSelect: ControlEvent<IndexPath>
    }
    
    struct WLOutput {
        
        let tableData: BehaviorRelay<[GENCarouselBean]>
    
        let zip: Observable<(GENCarouselBean,IndexPath)>
        
        let currentPage: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    }
    
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let tableData: BehaviorRelay<[GENCarouselBean]> = BehaviorRelay<[GENCarouselBean]>(value: [])
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
//        let timered: Observable<Int> = Observable<Int>
//            .create({ (ob) -> Disposable in
//
//                if input.canTimerResp {
//
//                    input
//                    .timer
//                    .subscribe(onNext: { (res) in
//
//                        ob.onNext(input.currentPage.value + 1)
//
//                    })
//                    .disposed(by: disposed)
//                }
//                return Disposables.create { _ = input.timer.takeLast(tableData.value.count) }
//            })
        
        let output = WLOutput(tableData: tableData, zip: zip)
        
        self.output = output
        
    }
}
