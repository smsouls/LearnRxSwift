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
    
    let disposeBag = DisposeBag()
    
    var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [nameField, passwordField, phoneNumField, emailField]
        
        
        let validTextFieldCollection = textFields.map{textField in
            textField.rx.text.filter{$0 != nil
                }.map{$0!.count > 0
            }
        }
        
        //$0 代表 return $0,
        let validText = Observable.combineLatest(validTextFieldCollection) { filters in
            return filters.filter { $0 }.count == filters.count
        }
        
        
        validText.asObservable().subscribe(onNext: {[weak self] enable in
            self?.loginButton.isEnabled = enable
        }).disposed(by: self.disposeBag)
        
    }

    
    @IBAction func loginClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Wooo!", message: "Registration completed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}

