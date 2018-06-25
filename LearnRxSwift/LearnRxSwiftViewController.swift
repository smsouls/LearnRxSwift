//
//  LearnRxSwiftViewController.swift
//  LearnRxSwift
//
//  Created by 123 on 2018/6/11.
//  Copyright © 2018年 NoName. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class LearnRxSwiftViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        play1()
        play2()
        
    }

    

    func play1() {
        let helloSequence = Observable.of(["H","e","l","l","o"])
        helloSequence.subscribe { event in
            switch event {
            case .next(let value):
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }.disposed(by: self.disposeBag)
        
        let publishSubject = PublishSubject<String>()
        publishSubject.onNext("Hello")
        publishSubject.onNext("world")
        
        publishSubject.subscribe(onNext: {print("subscription1:", $0)}).disposed(by: self.disposeBag)
        
        publishSubject.onNext("Hello")
        publishSubject.onNext("Again")
        
        publishSubject.subscribe(onNext:{
            print(#line,$0)
        }).disposed(by: self.disposeBag)
        
        publishSubject.onNext("Both Subscriptions receive this message")
        
        Observable<Int>.of(1,2,3,4).map({
            return $0 * 10
        }).subscribe(onNext: {print($0)}).disposed(by: self.disposeBag)
    }
    
    
    func play2() {
        _ = Observable<String>.create { observerOfString -> Disposable in
            print("This will never be printed")
            observerOfString.on(.next("smile"))
            observerOfString.on(.completed)
            return Disposables.create()
        }
        
        _ = Observable<String>.create{ observerOfString -> Disposable in
            print("Observable created")
            observerOfString.on(.next("smile"))
            observerOfString.on(.completed)
            return Disposables.create()
            }.subscribe{ event in
                print(event)
        }
        
        Observable<String>.never().subscribe{ _ in
            print("This will never be printed")
        }.disposed(by: self.disposeBag)
        
        
        Observable<Int>.empty().subscribe{ event in
            print(event)
        }.disposed(by: self.disposeBag)
        
        
        Observable.just("smile").subscribe{ event in
            print(event)
        }.disposed(by: self.disposeBag)
        
        Observable.of("🤠", "😎", "😇", "🐯").subscribe(onNext:{ element in
            print(element)
        }).disposed(by: self.disposeBag)
        
        Observable.from(["🤠", "😎", "😇", "🐯"]).subscribe(onNext: { print($0)
        }).disposed(by: self.disposeBag)
        
        
        
    }
    
    func play3() {
        
        Observable.of("🐶", "🐱", "🐭", "🐹").startWith("1")
            .startWith("2")
            .startWith("3", "4", "5")
            .subscribe(onNext: {
                print($0)
            }).disposed(by: self.disposeBag)
        
        
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext:{
                print($0)
            }).disposed(by: self.disposeBag)
        
        subject1.onNext("🅰️")
        subject1.onNext("🅱️")
        subject2.onNext("①")
        subject2.onNext("②")
        subject1.onNext("🆎")
        subject2.onNext("③")
        
        
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject, intSubject){ stringElement, intElement in
            "\(stringElement)  \(intElement)"
            }.subscribe(onNext: {print( $0)})
            .disposed(by: self.disposeBag)
        
        stringSubject.onNext("🅰️")
        stringSubject.onNext("🅱️")
        intSubject.onNext(1)
        intSubject.onNext(2)
        stringSubject.onNext("🆎")
        intSubject.onNext(3)
        
        
    }
    
    func play4() {
        
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        
        Observable.combineLatest(stringSubject, intSubject){ stringElement, intElement in
            "\(stringElement)\(intElement)"
            }.subscribe(onNext: {
                print($0)
            }).disposed(by: self.disposeBag)
        
        
        stringSubject.onNext("🅰️")
        stringSubject.onNext("🅱️")
        intSubject.onNext(1)
        intSubject.onNext(2)
        stringSubject.onNext("🆎")
        
        let stringObservable = Observable.just("❤️")
        let fruitObservable = Observable.from(["🍎", "🍐", "🍊"])
        let animalObservable = Observable.of("🐶", "🐱", "🐭", "🐹")
        
        Observable.combineLatest([stringObservable, fruitObservable, animalObservable]){
            "\($0[0]) \($0[1]) \($0[2])"
            }.subscribe(onNext: {
                print($0)
            }).disposed(by: self.disposeBag)
        
        
        let subject1 = BehaviorSubject(value: "🐶")
        let subject2 = BehaviorSubject(value: "🐱")
        
        let variable = Variable(subject1)
        
        variable.asObservable().switchLatest()
            .subscribe(onNext: {
                print($0)
            }).disposed(by: self.disposeBag)
        
        subject1.onNext("🐭")
        subject1.onNext("🐹")
        
        variable.value = subject2
        subject1.onNext("🍎")
        subject2.onNext("🍊")
        

        
    }

}
