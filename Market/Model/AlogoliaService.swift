//
//  AlogoliaService.swift
//  Market
//
//  Created by KaoChe on 2020/11/28.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
    static let shared = AlgoliaService()
    let client = Client(appID: KALGFOLIA_APP_ID, apiKey: KALGOIA_ADMIN_KEY)
    let index = Client(appID: KALGFOLIA_APP_ID, apiKey: KALGOIA_ADMIN_KEY).index(withName: "item_Name")
    
    private init() {}
}

