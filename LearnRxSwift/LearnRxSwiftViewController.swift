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


extension ObservableType {

    func addObserver(_ id: String) -> Disposable {
        return subscribe { print("Subscription:", id, "Event:", $0) }
    }

}

class LearnRxSwiftViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        play1()
//        play2()

//        play3()
//        play4()
        
//        play6()
        
//        play7()
//        play8()
        
//        play9()
        play10()
        
    }

    
    
    func play10() {
        var count = 1
        
        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("🍎")
            observer.onNext("🍐")
            observer.onNext("🍊")
            
            if count == 1 {
                observer.onError(TestError.test)
                print("Error encountered")
                count += 1
            }
            
            observer.onNext("🐶")
            observer.onNext("🐱")
            observer.onNext("🐭")
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        sequenceThatErrors
            .retry()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func play9() {
//        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//
//        _ = interval.subscribe(onNext:{
//            print("Subscription: 1, Envent: \($0)")
//        }).disposed(by: self.disposeBag)
        
//        delay(5) {
//            _ = interval
//                .subscribe(onNext: { print("Subscription: 2, Event: \($0)") })
//        }
        
        let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .publish()
        
        intSequence.subscribe(onNext:{
            print("Subscription: 2, Envent: \($0)")
        }).disposed(by: self.disposeBag)
        
        intSequence.connect().disposed(by: self.disposeBag)
    }
    
    
    func play8() {
//        Observable.range(start: 1, count: 10)
//            .toArray()
//            .subscribe( onNext:{ print($0)})
//            .disposed(by: self.disposeBag)
        
//        Observable.of(10, 100)
//            .reduce(1, accumulator: *)
//            .subscribe(onNext: {print($0)})
//            .disposed(by: self.disposeBag)
        
        let subject1 = BehaviorSubject(value: "🍎")
        let subject2 = BehaviorSubject(value: "🐶")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .concat()
            .subscribe{print($0)}
            .disposed(by: self.disposeBag)
        
        subject1.onNext("🍐")
        subject1.onNext("🍊")
        
        variable.value = subject2
        
        subject2.onNext("I dont ignore")
        subject2.onNext("🍊")
        subject2.onNext("hello")
        subject2.onNext("world")
        
        subject1.onCompleted()
        
        subject2.onNext("🐭")
    }
    
    func play7() {
//        Observable.of("🐱", "🐰", "🐶",
//                      "🐸", "🐱", "🐰",
//                      "🐹", "🐸", "🐱")
//            .filter{
//                $0 == "🐸"
//            }.subscribe(onNext: {
//                print($0)
//            }).disposed(by: self.disposeBag)
//
//        Observable.of("🐱", "🐰", "🐶",
//                      "🐸", "🐱", "🐰")
//            .elementAt(3)
//            .subscribe(onNext: {
//                print($0)
//            })
//            .disposed(by: self.disposeBag)
        
        
//        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
//            .single{ $0 == "🐶" }
//            .subscribe(onNext: { print($0) })
//            .disposed(by: self.disposeBag)
//
//        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
//            .takeLast(2)
//            .subscribe(onNext: { print($0) })
//            .disposed(by: self.disposeBag)
        
//        Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
//            .takeWhile{ $0 < 5}
//            .subscribe(onNext:{
//                print($0)
//            })
//            .disposed(by: self.disposeBag)
        
//        let sourceSequence = PublishSubject<String>()
//        let referenceSequence = PublishSubject<String>()
//
//        sourceSequence.takeUntil(referenceSequence)
//            .subscribe{
//                print($0)
//        }.disposed(by: self.disposeBag)
//
//        sourceSequence.onNext("🐱")
//        sourceSequence.onNext("🐰")
//        sourceSequence.onNext("🐶")
//
//        referenceSequence.onNext("🔴")
//
//        sourceSequence.onNext("🐸")
//        sourceSequence.onNext("🐷")
//        sourceSequence.onNext("🐵")
        
        Observable.of(10, 100, 100)
            .scan(1){
                aggregateValue, newValue in
                aggregateValue + newValue
            }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: self.disposeBag)
    }
    
    
    func play6() {
        Observable.of(1, 2, 3)
            .map{$0 * $0}
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: self.disposeBag)
        
        
        struct Player{
            var score: Variable<Int>
        }
        
        let man = Player(score: Variable(80))
        let woman = Player(score: Variable(90))
        
        let player = Variable(man)
        
        player.asObservable().flatMapLatest{ $0.score.asObservable()}
            .subscribe(onNext: {print($0)})
            .disposed(by: self.disposeBag)
        
        man.score.value = 85
        
        player.value = woman
        
        man.score.value = 95
        
        woman.score.value = 100
        
    }
    
    func play5() {
//        let subject = PublishSubject<String>()
//        subject.addObserver("1").disposed(by: self.disposeBag)
//
//        subject.onNext("🐶")
//        subject.onNext("🐱")
//
//        subject.addObserver("2").disposed(by: self.disposeBag)
//        subject.onNext("🅰️")
//        subject.onNext("🅱️")
//
//        let reSubject = ReplaySubject<String>.create(bufferSize: 2)
//        reSubject.addObserver("1").disposed(by: self.disposeBag)
//        reSubject.onNext("🐶")
//        reSubject.onNext("🐱")
//
//
//        reSubject.addObserver("2").disposed(by: self.disposeBag)
//        reSubject.onNext("🅰️")
//        reSubject.onNext("🅱️")
        
        let variable = Variable("🔴")
        
        variable.asObservable().addObserver("1").disposed(by: self.disposeBag)
        variable.value = "🐶"
        variable.value = "🐱"
        
        variable.asObservable().addObserver("2").disposed(by: self.disposeBag)
        variable.value = "🅰️"
        variable.value = "🅱️"
        
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
