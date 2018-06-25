//
//  AVViewController.swift
//  LearnRxSwift
//
//  Created by 123 on 2018/6/25.
//  Copyright © 2018年 NoName. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AVViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    func mySequence<E>(_ sequence: [E]) -> Observable<E> {
        return Observable.create { observer in
            for element in sequence {
                observer.on(.next(element))
            }
            
            observer.on(.completed)
            
            return Disposables.create()
        }
    }
    
    func myInterval(_ interval: TimeInterval) -> Observable<Int> {
        return Observable.create { observer in
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
            timer.schedule(deadline: DispatchTime.now() + interval, repeating: interval)
            
            let cancel = Disposables.create {
                timer.cancel()
            }
            
            var next = 0
            
            timer.setEventHandler{
                if cancel.isDisposed {
                    return
                }
                
                observer.on(.next(next))
                next += 1
            }
            
            timer.resume()
            
            return cancel
        }
    }

}


extension ObservableType {
    func myMap<R>(transform: @escaping(E) -> R) -> Observable<R> {
        return Observable.create{ observer in
            let subscription = self.subscribe{ e in
                switch e {
                case .next(let value):
                    let result = transform(value)
                    observer.on(.next(result))
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            }
            
            return subscription
        }
    }
}
