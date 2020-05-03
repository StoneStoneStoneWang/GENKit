//
//  FBWelcomViewModel.swift
//  ZUserKit
//
//  Created by three stone 王 on 2019/3/15.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import WLToolsKit

public struct FBWelcomViewModel: FBViewModel {
    
    public var input: WLInput
    
    public var output: WLOutput
    
    public struct WLInput {
        
        let contentoffSetX: Observable<CGFloat>
        
        let skipTap: Signal<Void>
        
        let welcomeImgs: [String]
        
        /* 定时器 序列*/
        let timer: Observable<Int> = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        
        let durationRelay: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 3)
    }
    
    public struct WLOutput {
        
        let tableData: BehaviorRelay<[String]>
        
        let numofpage: Observable<Int>
        
        let currentpage: Observable<Int>
        
        let pageHidden: Observable<Bool>
        
        let skipHidden: BehaviorRelay<Bool>
        
        let skiped: Driver<Void>
        
        let timered: Observable<String>
        
    }
    public init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let tableData: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: input.welcomeImgs)
        
        let numofpage: Observable<Int> = Observable<Int>.just(tableData.value.count)
        
        let currentpage: Observable<Int> = input.contentoffSetX.map { Int($0 / WL_SCREEN_WIDTH) }
        
        let pageHidden: Observable<Bool> = input.contentoffSetX.map { Int($0 / WL_SCREEN_WIDTH) == (tableData.value.count - 1) }
        
        let combine = Observable.combineLatest(input.contentoffSetX, currentpage)
        
        let skipHidden: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
        
        input
            .contentoffSetX
            .subscribe(onNext: { skipHidden.accept(input.durationRelay.value != 0 ? Int($0 / WL_SCREEN_WIDTH) != (tableData.value.count - 1) : false) })
            .disposed(by: disposed)
        
        let timered: Observable<String> = Observable<String>
            .create({ (ob) -> Disposable in
                
                combine.subscribe(onNext: { (x,p) in
                    
                    if p == tableData.value.count - 1 {
                        
                        let duration = input.durationRelay.value
                        
                        if duration != 0 {
                            
                            input
                                .timer
                                .map({ duration - $0 })
                                .take(duration + 1)
                                .map({ $0 })
                                .subscribe(onNext: {
                                    
                                    input.durationRelay.accept($0)
                                    
                                    if $0 == 0 {
                                        
                                        skipHidden.accept(false)
                                        
                                        ob.onNext("立即体验")
                                        
                                        ob.onCompleted()
                                        
                                    } else {
                                        
                                        ob.onNext("\($0)s 跳过")
                                    }
                                })
                                .disposed(by: disposed)
                            
                        }
                    }
                    
                })
                    .disposed(by: disposed)
                
                return Disposables.create { }
            })
        
        let skiped: Driver<Void> = input.skipTap.flatMap { Driver.just($0) }
        
        self.output = WLOutput(tableData: tableData, numofpage: numofpage, currentpage: currentpage, pageHidden: pageHidden, skipHidden: skipHidden, skiped: skiped, timered: timered)
    }
}
