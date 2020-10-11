//
//  FirebaseCollectionReference.swift
//  Market
//
//  Created by Kao on 2020/2/7.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String{
    case User
    case Category
    case Items
    case Basket
    
}


//可選擇FCollectionReference的類別
//且不用打一長串的Firestore.firestore().collection()才能取得
func FirebaseReference(_ collectionReference:FCollectionReference) -> CollectionReference{
    
    
    //rawValue原始值
    return Firestore.firestore().collection(collectionReference.rawValue)
}
