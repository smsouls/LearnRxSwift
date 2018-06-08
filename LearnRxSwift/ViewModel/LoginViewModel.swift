//
//  LoginViewModel.swift
//  LearnRxSwift
//
//  Created by 123 on 2018/6/6.
//  Copyright © 2018年 NoName. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    func passwordMessage(_ password: String) -> String? {
        if password.count < 6{
            return "长度不够,必须要达到六位数"
        }
        
        return nil
    }
    
    func phoneNumberMessage(_ phoneNumber: String) -> String? {
        if RegularExpressionValidate.phoneNum(phoneNumber).isRight{
            return nil
        }
        return "电话号码输入有误"
    }
    
    func eMailMessage(_ eMail: String) -> String? {
        if RegularExpressionValidate.email(eMail).isRight{
            return nil
        }
        return "电子邮件输入有误"
    }
}



