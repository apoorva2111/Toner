//
//  ItemModel.swift
//  Toner
//
//  Created by Users on 10/04/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation

struct ItemModel {
    
    var id: String = ""
    var name: String = ""
    var image: String = ""
    
}

struct ProductList{
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var slug: String = ""
    var quantity: String = ""
    var image: String = ""
    var price: String = ""
    var subtract: String = ""
    var sort_order: String = ""
    var status: String = ""
    var viewed: String = ""
}

struct PrintfulProducts{
    var id: Int64 = 0
    var external_id: String = ""
    var name: String = ""
    var variants: Int = 0
    var synced: Int = 0
    var thumbnail_url = ""
}

struct ProductDetailsModel {
    var id: String = ""
    var product_name = ""
    var images = [ProductImages]()
    var price: String = ""
    var description: String = ""
    var model: String = ""
    var options = [ProductOptions]()
}
struct ProductImages {
    var popup: String = ""
    var thumb: String = ""
}

struct ProductOptions {
    var name: String = ""
    var type: String = ""
    var options: [String] = [String]()
    
}

struct ProductCategory{
    var id: String = ""
    var image: String = ""
    var name: String = ""
    var slug: String = ""
}
