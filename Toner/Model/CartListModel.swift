//
//  CartListModel.swift
//  Toner
//
//  Created by Mona on 20/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation

struct CartListModel {
    var productDetailsModel : ProductDetailsModel!
    var size : String = ""
    var quantity : Double = 0 {
        didSet{
            totalamountOfEachItem = price * quantity
        }
    }
    var price : Double = 0
    var productName : String = ""
    var totalamountOfEachItem : Double = 0
    
    init (productDetailsModel : ProductDetailsModel,size : String , quantity : Double , price : Double , productName : String ){
        self.productDetailsModel = productDetailsModel
        self.size = size
        self.quantity = quantity
        self.price = price
        self.productName = productName
        self.totalamountOfEachItem = self.price * quantity
        
    }
}



extension UserDefaults {
    
    func syncCart(){
        /*do {
            var tempCartData = self.appD.cartListModel.map { (cartData) -> [String : Any] in
                return [
                    "productDetailsModel"   : cartData.productDetailsModel,
                    "size"                  : cartData.size,
                    "quantity"              : cartData.quantity,
                    "price"                 : cartData.price,
                    "productName"           : cartData.productName,
                    "totalamountOfEachItem" : cartData.totalamountOfEachItem
                ]
            }
//            let cartDataObject = ["cartData": self.appD.cartListModel]
            let data = try JSONSerialization.data(withJSONObject: tempCartData, options: [])
            UserDefaults.standard.set(data, forKey: UserDefaults.keys.cart.value)
            UserDefaults.standard.synchronize()
        }catch{
            print("Error: \(error.localizedDescription)")
        }*/
    
    }
    
    func fetchCartData(){
      
        /*guard let cartData = UserDefaults.standard.data(forKey: UserDefaults.keys.cart.value) else{
            print("Cart Data not found")
            return
        }
        do{
            let cartDataObject = try JSONSerialization.jsonObject(with: cartData, options: []) as? NSDictionary ?? NSDictionary()
            self.appD.cartListModel = cartDataObject["cartData"] as? [CartListModel] ?? [CartListModel]()
                
        }catch{
            print("Error: \(error.localizedDescription)")
        }
        print("self.appD.cartListModel\(self.appD.cartListModel)")*/
    }
}
