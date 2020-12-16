//
//  ProfileTableViewController.swift
//  Market
//
//  Created by KaoChe on 2020/11/21.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var finishRegistrationBtn: UIButton!
    
    @IBOutlet weak var purchaseHistoryBtn: UIButton!
    
    var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //確認狀態紀錄
        checkLoginStatus()
        
        checkOnboardingStatus()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    
    //Helper
    
    private func checkOnboardingStatus() {
        if MUser.currentUser() != nil {
            if MUser.currentUser()!.onBoard {
                finishRegistrationBtn.setTitle("帳號有效", for: .normal)
                finishRegistrationBtn.isEnabled = false
            } else {
                finishRegistrationBtn.setTitle("完成註冊", for: .normal)
                finishRegistrationBtn.isEnabled = true
                finishRegistrationBtn.tintColor = .red
            }
            purchaseHistoryBtn.isEnabled = true
            
        } else {
            finishRegistrationBtn.setTitle("登出", for: .normal)
            finishRegistrationBtn.isEnabled = false
            purchaseHistoryBtn.isEnabled = false
        }
    }
    
    private func checkLoginStatus() {
        if MUser.currentUser() == nil {
            createRightButton(title: "登入")
        } else {
            createRightButton(title: "編輯")
        }
    }
    
    private func createRightButton(title: String) {
        editBtn = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = editBtn
    }

    @objc func rightBarBtnAction() {
        if editBtn.title == "登入" {
            showLoginView()
        } else {
           goToEditProfile()
        }
    }
    
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true, completion: nil)
    }
    

    private func goToEditProfile() {
        performSegue(withIdentifier: "profileToEditSeg", sender: self)
    }
    
}
