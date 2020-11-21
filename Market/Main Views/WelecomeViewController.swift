//
//  WelecomeViewController.swift
//  Market
//
//  Created by KaoChe on 2020/11/21.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class WelecomeViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var resendBtn: UIButton!
    
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), padding: nil)
    }
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        dismisView()
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        print("登入")
        
        if textFieldsHaveText() {
            loginUser()
        } else {
            hud.textLabel.text = "需填寫所有欄位"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        
    }
    
    
    @IBAction func registerBtnAction(_ sender: Any) {
        print("註冊")
        
        if textFieldsHaveText() {
            registerUser()
            
        } else {
            hud.textLabel.text = "需填寫所有欄位"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        
    }
    
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        print("忘記密碼")
        if emailTextField.text != "" {
            resetThePassword()
        } else {
            hud.textLabel.text = "需填寫email欄位"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        
    }
    @IBAction func resendEmailBtnAction(_ sender: Any) {
        print("重新發送")
        MUsure.resendVerificationonEmail(email: emailTextField.text!) { (error) in
            print("發送email錯誤", error?.localizedDescription)
        }
        
    }
    
    //會員登入
    private func loginUser() {
        showLoadingIdicator()
        MUsure.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                if isEmailVerified {
                    self.dismisView()
                    print("此Email已驗證通過")
                } else {
                    self.hud.textLabel.text = "請確認您的Email"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
                
            } else {
                print("user 登入錯誤", error?.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideLoadingIdicator()
        }
    }
    
    
    //user註冊
    private func registerUser() {
        showLoadingIdicator()
        MUsure.registerUserWithWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error == nil {
                self.hud.textLabel.text = "驗證email已發送"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                self.resendBtn.isHidden = false
            } else {
                print("註冊失敗", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideLoadingIdicator()
        }
    }
    
    //Helpers
    
    private func resetThePassword() {
        MUsure.resetPasswordFor(email: emailTextField.text!) { (error) in
            if error == nil {
                self.hud.textLabel.text = "密碼已發送至email"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            } else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    private func dismisView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //選轉圖示動作
    private func showLoadingIdicator() {
        if activityIdicator != nil {
            self.view.addSubview(activityIdicator!)
            activityIdicator!.startAnimating()
        }
    }
    
    private func hideLoadingIdicator() {
        if activityIdicator != nil {
            activityIdicator!.removeFromSuperview()
            activityIdicator?.stopAnimating()
        }
    }
}
