//
//  DotViewModel.swift
//  swiftRxColourDot
//
//  Created by Martin Conklin on 2016-08-21.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import ChameleonFramework
import RxSwift
import RxCocoa

class DotViewModel
{
    var centerVariable = Variable<CGPoint?>(CGPointZero)
    var backgroundColourObservable: Observable<UIColor>!
    
    init() {
        setup()
    }
    
    func setup() {
        backgroundColourObservable = centerVariable.asObservable()
            .map { center in
                guard let center = center else { return UIColor.flatten(UIColor.blackColor())() }
                
                let red: CGFloat = ((center.x + center.y) % 255.0) / 255.0
                let green: CGFloat = 0.0
                let blue: CGFloat = 0.0
                
                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        }
    }
}
