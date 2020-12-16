//
//  EditProfileViewController.swift
//  Market
//
//  Created by KaoChe on 2020/11/28.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var surnameTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserInfo()

    }
    
    @IBAction func saveBarBtnAction(_ sender: UIButton) {
        dismissKeyboard()
        if textFirldHaveText() {
            let withValue = [kFIRSTNAME: nameTF.text!, kLASTNAME: surnameTF.text!, kFULLNAME: (nameTF.text! + " " + surnameTF.text!), kFULLADDRESS: addressTF.text!]
            updateCurrentUserInFirestore(withValues: withValue) { (error) in
                if error == nil {
                    self.hud.textLabel.text = "更新成功"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                } else {
                    print("更新使用者資訊失敗：\(error?.localizedDescription)")
                    self.hud.textLabel.text = error?.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
            
        } else {
            hud.textLabel.text = "所有欄位需填寫完成"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
        
    }
    
  
    @IBAction func logOutBtnAction(_ sender: UIButton) {
        logOutUser()
    }
    
    
    //更新UI
    
    private func loadUserInfo() {
        if MUser.currentUser() != nil {
            let currentUser = MUser.currentUser()!
            
            nameTF.text = currentUser.firstName
            surnameTF.text = currentUser.lastName
            addressTF.text = currentUser.fullAddress
        }
    }
    
    //Helper
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func textFirldHaveText() -> Bool {
        return (nameTF.text != "" && surnameTF.text != "" && addressTF.text != "")
    }
    
    private func logOutUser() {
        MUser.logOutCurrentUser { (error) in
            if error == nil {
                print("登出成功")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("登出失敗：\(error!.localizedDescription)")
            }
        }
    }
}
