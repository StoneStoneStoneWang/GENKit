//
//  FBCarouselViewModel.swift
//  FBBridge
//
//  Created by three stone 王 on 2020/3/12.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import WLToolsKit
import ObjectMapper

@objc public final class FBCarouselBean: NSObject , Mappable{
    public init?(map: Map) {
        
        
    }
    
    @objc public static func createCarousel(_ title: String ,icon: String) -> FBCarouselBean {
        
        let carousel = FBCarouselBean()
        
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
    
    private override init() {
        
    }
}

struct FBCarouselViewModel: FBViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let contentoffSetX: Observable<CGFloat>
        
        let modelSelect: ControlEvent<FBCarouselBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let canTimerResp: Bool
        
        /* 定时器 序列*/
        let timer: Observable<Int> = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        
        let currentPage: BehaviorRelay<Int>
        
        let carouselCount: Int
    }
    
    struct WLOutput {
        
        let tableData: BehaviorRelay<[FBCarouselBean]>
        
        let timered: Observable<Int>
        
        let zip: Observable<(FBCarouselBean,IndexPath)>
        
        let currentPage: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    }
    
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let tableData: BehaviorRelay<[FBCarouselBean]> = BehaviorRelay<[FBCarouselBean]>(value: [])
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let timered: Observable<Int> = Observable<Int>
            .create({ (ob) -> Disposable in
                
                if input.canTimerResp {
                    
                    input
                    .timer
                    .subscribe(onNext: { (res) in
                        
                        ob.onNext(input.currentPage.value + 1)
                        
                    })
                    .disposed(by: disposed)
                }
                return Disposables.create { _ = input.timer.takeLast(tableData.value.count) }
            })
        
        let output = WLOutput(tableData: tableData, timered: timered, zip: zip)
        
        self.output = output
        
        input
            .contentoffSetX
            .subscribe(onNext: { (x) in
                
                input.currentPage.accept(Int(x / WL_SCREEN_WIDTH) )
                
                output.currentPage.accept(Int(x / WL_SCREEN_WIDTH) % input.carouselCount)
            })
            .disposed(by: disposed)
        
    }
}
