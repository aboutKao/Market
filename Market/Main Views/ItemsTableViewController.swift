//
//  ItemsTableViewController.swift
//  
//
//  Created by Kao on 2020/2/11.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    var category:Category?
    var itemArray: [Item] = []
    
    //View生命週期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.title = category?.name
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            loadItems()
            
        }
    }

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(itemArray[indexPath.row])


        return cell
    }
    


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemToAddItemSeg" {
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
        }
    }
    
    private func showItemView(_ item: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //載入Item
    private func loadItems() {
        downloadItemFromFirebase(withCategoryId: category!.id) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }

}
