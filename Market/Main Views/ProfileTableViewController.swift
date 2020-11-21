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
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

   
    
    //Helper
    
    private func checkLoginStatus() {
        if MUsure.currentUser() == nil {
            createRightButton(title: "登入")
        } else {
            createRightButton(title: "返回")
        }
    }
    
    private func createRightButton(title: String) {
        editBtn = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = editButtonItem
    }

    @objc func rightBarBtnAction() {
        if editBtn.title == "登入" {
            //show loginView
        } else {
            //go to profile
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    

    
}
