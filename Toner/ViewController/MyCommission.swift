//
//  MyCommission.swift
//  Toner
//
//  Created by Muvi on 17/03/21.
//  Copyright © 2021 Users. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire
class MyCommission: UIViewController{
    var activityIndicator: NVActivityIndicatorView!
    var artistId:String!
    var arrArtist = [NSDictionary]()
    
    @IBOutlet weak var viewSearch: UIView!
    
    @IBOutlet weak var tableCommision: UITableView!
    @IBOutlet weak var searchTextFeild: UITextField!
    @IBOutlet weak var artistCommission: UILabel!
    
    
    override func viewDidLoad() {
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.setNavigationBar(title: "Artist Commission", isBackButtonRequired: true, isTransparent: false)
        self.view.backgroundColor = ThemeColor.backgroundColor
      
        self.tableCommision.register(UINib(nibName:"MyCommissionTVCell", bundle: nil), forCellReuseIdentifier: "MyCommissionTVCell")
        self.tableCommision.delegate = self
        self.tableCommision.dataSource = self
        self.viewSearch.layer.borderWidth = 1
        self.viewSearch.layer.cornerRadius = 4
        self.viewSearch.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.viewSearch.layer.masksToBounds = true
        
        getArtistCommision()
    }
    func getArtistCommision(){
        self.activityIndicator.startAnimating()
        self.artistId = UserDefaults.standard.fetchData(forKey: .userId) //"53"
        
        let apiURL = "https://tonnerumusic.com/api/v1/arist_commision"
        let urlConvertible = URL(string: apiURL)!
        Alamofire.request(urlConvertible,
                      method: .post,
                      parameters: [
                        "artist_id": artistId ?? ""
            ] as [String: String])
        .validate().responseJSON { (response) in
                print(response)

                
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            if let arrObject = resposeJSON["commisions"] as? NSArray{
            for obj in arrObject{
                self.arrArtist.append(obj as! NSDictionary)
            }
                
            }
            let commission = resposeJSON["total_commisions"] as? String ?? ""
         self.artistCommission.text = commission
            self.tableCommision.reloadData()
            self.activityIndicator.stopAnimating()
            
            
    }
}
}
extension MyCommission : UITableViewDelegate ,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrArtist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableCommision.dequeueReusableCell(withIdentifier: "MyCommissionTVCell", for: indexPath) as! MyCommissionTVCell
        let objArtist = arrArtist[indexPath.row]
    
        cell.lblBalance.text = objArtist["balance"] as? String
        cell.lblDate.text = objArtist["date_added"] as? String
        cell.lblPayment.text = objArtist["total_payment"] as? String
        cell.lblDiscription.text = objArtist["description"] as? String
        cell.lblTotalCommision.text = objArtist["total_commission"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
