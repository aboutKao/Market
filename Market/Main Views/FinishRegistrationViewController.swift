//
//  FinishRegistrationViewController.swift
//  Market
//
//  Created by KaoChe on 2020/11/28.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit
import JGProgressHUD

class FinishRegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var surnameTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    let hud = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        surnameTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        addressTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    

    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        finishOnboarding()
    }
    
   
    @IBAction func CancleBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateDoneButtonStatus()
    }
    
    //Helper
    
    private func updateDoneButtonStatus() {
        if nameTF.text != "" && surnameTF.text != "" && addressTF.text != "" {
            doneBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            doneBtn.isEnabled = true
        } else {
            doneBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.2997217466)
            doneBtn.isEnabled = false
        }
    }
    
    private func finishOnboarding() {
        let withValues = [kFIRSTNAME: nameTF.text!, kLASTNAME: surnameTF.text!, kONBOARD: true, kFULLADDRESS: addressTF.text, kFULLNAME: (nameTF.text! + " " + surnameTF.text!)] as [String: Any]
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            if error == nil {
                self.hud.textLabel.text = "更新使用者成功"
                self.hud.indicatorView = JGProgressHUDIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                self.dismiss(animated: true, completion: nil)
            } else {
                print("更新使用者失敗：\(error?.localizedDescription)")
                self.hud.textLabel.text = error?.localizedDescription
                self.hud.indicatorView = JGProgressHUDIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
}
