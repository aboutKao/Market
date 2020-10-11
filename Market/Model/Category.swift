//
//  Category.swift
//  Market
//
//  Created by Kao on 2020/2/7.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import Foundation
import UIKit

class Category {
    var id : String
    var name : String
    var image : UIImage?
    var imageName : String?
    
    //初始化
    init(_name:String, _imageName:String) {
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary:NSDictionary){
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
    
}

//下載來自Firebase的category
func downloadCategoriesFromFirebase(completion:@escaping (_ categoryArray: [Category]) -> Void ){
    
    var categoryArray:[Category] = []
    FirebaseReference(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else{
            completion(categoryArray)
            return
        }
        
        //快照不為空
        if !snapshot.isEmpty{
            for categoryDict in snapshot.documents{
                print("已新增類別")
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
            
        }
        completion(categoryArray)
    }
}





//儲存類別功能
//初始化類別時，要先保存類別
func saveCatrgoryToFirebase(_ category: Category){
    
    let id = UUID().uuidString
    category.id = id
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
}




//Helpers
func categoryDictionaryFrom(_ category:Category) -> NSDictionary{
    
    
    //創建dictionary並返回所有內容
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
}



////只使用一次，建立firebase上的document
//func createCategorySet(){
//
//    let womenClothing = Category(_name: "女士服裝", _imageName: "womenCloth")
//    let footWear = Category(_name: "鞋類", _imageName: "footWear")
//    let electronics = Category(_name: "電器用品", _imageName: "electronics")
//    let menClothing = Category(_name: "男士服裝", _imageName: "menCloth")
//    let health = Category(_name: "健康用品", _imageName: "health")
//    let baby = Category(_name: "嬰兒用品", _imageName: "baby")
//    let home = Category(_name: "生活用品", _imageName: "home")
//    let car = Category(_name: "車用品", _imageName: "car")
//    let luggage = Category(_name: "行李箱及背包", _imageName: "luggage")
//    let jewelery = Category(_name: "飾品類", _imageName: "jewelery")
//    let hobby = Category(_name: "休閒愛好", _imageName: "hobby")
//    let pet = Category(_name: "寵物用品", _imageName: "pet")
//    let industry = Category(_name: "五金用品", _imageName: "industry")
//    let garden = Category(_name: "園藝用品", _imageName: "garden")
//    let camera = Category(_name: "相機用品", _imageName: "camera")
//
//    let arrayOfCategories = [womenClothing, footWear, electronics, menClothing, health, baby, home, car, luggage, jewelery, hobby, pet, industry, garden, camera]
//
//    for category in arrayOfCategories{
//        saveCatrgoryToFirebase(category)
//    }
//}
