//
//  ViewController.swift
//  swiftRxColourDot
//
//  Created by Martin Conklin on 2016-08-21.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ChameleonFramework

class ViewController: UIViewController {
    
    var dotView: UIView!
    private var dotViewModel: DotViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        dotView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        dotView.layer.cornerRadius = dotView.frame.width / 2.0
        dotView.center = view.center
        dotView.backgroundColor = UIColor.greenColor()
        view.addSubview(dotView)
        
        dotViewModel = DotViewModel()
        
        dotView
            .rx_observe(CGPoint.self, "center")
            .bindTo(dotViewModel.centerVariable)
            .addDisposableTo(disposeBag)
        
        dotViewModel.backgroundColourObservable
            .subscribeNext { [weak self] (backgroundColor) in
                UIView.animateWithDuration(0.05) {
                    self?.dotView.backgroundColor = backgroundColor
                    
                    let viewBackgroundColor = UIColor.init(complementaryFlatColorOf:backgroundColor, withAlpha: 1.0)
                    
                    if viewBackgroundColor != backgroundColor {
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                }
            }
            .addDisposableTo(disposeBag)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.dotMoved(_:)))
        dotView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func dotMoved(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.locationInView(view)
        UIView.animateWithDuration(0.05) {
            self.dotView.center = location
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

