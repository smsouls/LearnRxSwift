//
//  ViewController.swift
//  LearnRxSwift
//
//  Created by 123 on 2018/6/5.
//  Copyright © 2018年 NoName. All rights reserved.
//


import UIKit
import RxCocoa
import RxSwift


class ViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var warnMessage = NSMutableDictionary()
    
    let disposeBag = DisposeBag()
    var loginVM = LoginViewModel()
    
    var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:这种组合在一起比较简便,但是对于每个输入有特别的要求的话则不能满足
//        textFields = [nameField, passwordField, phoneNumField, emailField]
//        let validTextFieldCollection = textFields.map{textField in
//            textField.rx.text.filter{$0 != nil
//                }.map{$0!.count > 0
//            }
//        }
//        let validText = Observable.combineLatest(validTextFieldCollection) { filters in
//            return filters.filter { $0 }.count == filters.count
//        }


//        let stringSubject = PublishSubject<String>()
//        let intSubject = PublishSubject<Int>()
//
//
//        Observable.combineLatest(stringSubject, intSubject){ stringElement, intElement in
//            "\(stringElement)\(intElement)"
//            }.subscribe(onNext: {
//                print($0)
//            }).disposed(by: self.disposeBag)
//
//
//        stringSubject.onNext("🅰️")
//        stringSubject.onNext("🅱️")
//        intSubject.onNext(1)
//        intSubject.onNext(2)
//        stringSubject.onNext("🆎")
        
//        let stringObservable = Observable.just("❤️")
//        let fruitObservable = Observable.from(["🍎", "🍐", "🍊"])
//        let animalObservable = Observable.of("🐶", "🐱", "🐭", "🐹")
//
//        Observable.combineLatest([stringObservable, fruitObservable, animalObservable]){
//            "\($0[0]) \($0[1]) \($0[2])"
//            }.subscribe(onNext: {
//                print($0)
//            }).disposed(by: self.disposeBag)
        
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

        
        
        let validName = nameField.rx.text.filter{$0 != nil
            }.map{
                return $0!.count > 3
        }
        
        validName.subscribe(onNext: {[weak self]text in
            if !text{
                self?.warnMessage.setValue("用户名不合乎格则", forKey: "userName")
            }else{
                self?.warnMessage.setValue(nil, forKey: "userName")
            }
        }).disposed(by: self.disposeBag)
        
        let validPassword = passwordField.rx.text.filter{$0 != nil
            }.map{$0!.count > 0}
        
        
        passwordField.rx.text.filter{$0 != nil
        }.subscribe(onNext: {[weak self] text in
            self?.warnMessage.setValue(text, forKey: "passWord")
        }).disposed(by: self.disposeBag)
        
        
        let validPhoneNumber = phoneNumField.rx.text.filter{$0 != nil
            }.map({
                RegularExpressionValidate.phoneNum($0!).isRight
            })
        
        phoneNumField.rx.text.filter{$0 != nil
        }.subscribe(onNext: {[weak self] text in
            self?.warnMessage.setValue(self?.loginVM.phoneNumberMessage(text!), forKey: "phoneNumber")
        }).disposed(by: self.disposeBag)
        
        let validEmail = emailField.rx.text.filter{$0 != nil
        }.map({
            RegularExpressionValidate.email($0!).isRight
        })
        
        emailField.rx.text.filter{$0 != nil
        }.subscribe(onNext: {[weak self] text in
            self?.warnMessage.setValue(self?.loginVM.eMailMessage(text!), forKey: "eMail")
        }).disposed(by: self.disposeBag)
        
//        let validText = Observable.combineLatest(validName.asObservable(), validPassword.asObservable(), validPhoneNumber.asObservable(), validEmail.asObservable()){
//
//        }
//
//        validText.asObservable().subscribe(onNext: {[weak self] enable in
//            self?.loginButton.isEnabled = enable
//        }).disposed(by: self.disposeBag)
        
    }

    
    @IBAction func loginClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Wooo!", message: "Registration completed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}

