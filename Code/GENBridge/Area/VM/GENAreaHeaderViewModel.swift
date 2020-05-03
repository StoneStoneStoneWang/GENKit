//
//  GENAreaHeaderViewModel.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/19.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENViewModel
import RxCocoa
import RxSwift
import GENBean

@objc (GENAreaHeaderBean)
public class GENAreaHeaderBean: NSObject {
    
    @objc public var isSelected: Bool = false
    
    @objc public var areaBean: GENAreaBean!
}


struct GENAreaHeaderViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<GENAreaHeaderBean>
        
        let itemSelect: ControlEvent<IndexPath>
    }
    
    struct WLOutput {
        
        let zip: Observable<(GENAreaHeaderBean,IndexPath)>
        
        let tableData: BehaviorRelay<[GENAreaHeaderBean]> = BehaviorRelay<[GENAreaHeaderBean]>(value: [])
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let output = WLOutput(zip: zip)
        
        self.output = output
    }
}
