//
//  SearchViewController.swift
//  Market
//
//  Created by KaoChe on 2020/11/28.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchOptionView: UIView!
    
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    var searchResults: [Item] = []
    
    var activityIndicator: NVActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), padding: nil)
    }
    

    @IBAction func showSearchBarBtnAction(_ sender: UIBarButtonItem) {
        
        dismissKeyboard()
        showSearchField()
    }
    
    
    @IBAction func SearchBtnAction(_ sender: UIButton) {
     
        if searchTF.text != "" {
            
            searchInFirebase(forName: searchTF.text!)
            emptyTextField()
            animateSearchOptionsIn()
            dismissKeyboard()
        }
    }
    
    //搜尋資料庫
    private func searchInFirebase(forName: String) {
        
        showLoadingIndicator()
        searchAlgolia(searchString: forName) { (itemIds) in
            downloadItems(itemIds) { (allItems) in
                self.searchResults = allItems
                self.tableView.reloadData()
                self.hideLoadingIndicator()
            }
        }
    }
    
    //Helper
    
    private func emptyTextField() {
        searchTF.text = ""
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        searchBtn.isEnabled = textField.text != ""
        
        if searchBtn.isEnabled {
            searchBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        } else {
            disableSearchButton()
        }
    }
    
    private func disableSearchButton() {
        searchBtn.isEnabled = false
        searchBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.3)
    }
    
    private func showSearchField() {
        disableSearchButton()
        emptyTextField()
        animateSearchOptionsIn()
    }
    
    //動畫
    
    private func animateSearchOptionsIn() {
        UIView.animate(withDuration: 0.5) {
            self.searchOptionView.isHidden = !self.searchOptionView.isHidden
        }
    }
    //載入選轉
    private func showLoadingIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    private func showItemView(withItem: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
}




extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(searchResults[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: searchResults[indexPath.row])
    }
}

extension SearchViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "未搜尋到相關商品")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptydata")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "敬請期待未來有更多商品")
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return UIImage(named: "search")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        showSearchField()
    }
}
