//
//  SubscriptionViewController.swift
//  Toner
//
//  Created by User on 22/08/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class SubscriptionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgBG: UIImageView!
    
    var activityIndicator: NVActivityIndicatorView!
    var planList = [SubscriptionPlanModel]()
    var myPlanList = [MyPlanModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.fetchData(forKey: .userGroupID) == "4"{
            imgBG.image = UIImage.init(named: "member-subscription-bg")
            imgBG.contentMode = .scaleToFill
        }else{
            imgBG.image = UIImage.init(named: "artist-subscription-bg")
            imgBG.contentMode = .scaleToFill

        }
        // Do any additional setup after loading the view.
        self.view.backgroundColor = ThemeColor.backgroundColor
        //Subscription
        self.setNavigationBar(title: "SUBSCRIPTION", isBackButtonRequired: true, isTransparent: false)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        tableView.register(UINib(nibName: "SubscriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "SubscriptionTableViewCell")
        tableView.register(UINib.init(nibName: "MyPlanTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPlanTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        getPlanList()
        myplans()
//        getArtisPlantList()
    }
    
    fileprivate func getPlanList(){
        self.activityIndicator.startAnimating()
        planList = [SubscriptionPlanModel]()
        let reuestURL = "https://tonnerumusic.com/api/v1/memberplan"
        let urlConvertible = URL(string: reuestURL)!
        Alamofire.request(urlConvertible,
                          method: .get,
                          parameters: nil)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
            
                if(resposeJSON["status"] as? Bool ?? false){
                    let allPlans = resposeJSON["plans"] as? NSArray ?? NSArray()
                    print(allPlans)
                    allPlans.forEach { (plan) in
                        let currentPlan = plan as? NSDictionary ?? NSDictionary()
                        var currentPlanData = SubscriptionPlanModel()
                        currentPlanData.id = currentPlan["id"] as? String ?? ""
                        currentPlanData.name = currentPlan["name"] as? String ?? ""
                        currentPlanData.price = currentPlan["price"] as? String ?? ""
                        currentPlanData.description = currentPlan["description"] as? String ?? ""
                        currentPlanData.frequency = currentPlan["frequency"] as? String ?? ""
                        currentPlanData.duration = currentPlan["duration"] as? String ?? ""
                        currentPlanData.cycle = currentPlan["cycle"] as? String ?? ""
                        currentPlanData.status = currentPlan["status"] as? String ?? ""
                        currentPlanData.sort_order = currentPlan["sort_order"] as? String ?? ""
                        self.planList.append(currentPlanData)
                    }
                }
                self.tableView.reloadData()
        }
    }
    
    fileprivate func myplans(){
        self.activityIndicator.startAnimating()
        planList = [SubscriptionPlanModel]()
        let reuestURL = "https://tonnerumusic.com/api/v1/myplans"
        let urlConvertible = URL(string: reuestURL)!
        Alamofire.request(urlConvertible,
                          method: .post,
                          parameters: [
                            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
            ] as [String: String])
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                print(resposeJSON)
                self.activityIndicator.stopAnimating()
            
                if(resposeJSON["status"] as? Bool ?? false){
                    let allPlans = resposeJSON["subscriptions"] as? NSArray ?? NSArray()
                    allPlans.forEach { (plan) in
                        let currentPlan = plan as? NSDictionary ?? NSDictionary()
                        var currentPlanData = MyPlanModel()
                        currentPlanData.address = currentPlan["address"] as? String ?? ""
                        currentPlanData.artist_package_status_id = currentPlan["artist_package_status_id"] as? String ?? ""
                        currentPlanData.city = currentPlan["city"] as? String ?? ""
                        currentPlanData.comment = currentPlan["comment"] as? String ?? ""
                        currentPlanData.country = currentPlan["country"] as? String ?? ""
                        currentPlanData.date_added = currentPlan["date_added"] as? String ?? ""
                        currentPlanData.email = currentPlan["email"] as? String ?? ""
                        currentPlanData.firstname = currentPlan["firstname"] as? String ?? ""
                        currentPlanData.id = currentPlan["id"] as? String ?? ""
                        currentPlanData.lastname = currentPlan["lastname"] as? String ?? ""
                        currentPlanData.package_description = currentPlan["package_description"] as? String ?? ""
                        currentPlanData.package_id = currentPlan["package_id"] as? String ?? ""
                        currentPlanData.package_name = currentPlan["package_name"] as? String ?? ""
                        currentPlanData.phone = currentPlan["phone"] as? String ?? ""
                        currentPlanData.state = currentPlan["state"] as? String ?? ""
                        currentPlanData.status = currentPlan["status"] as? String ?? ""
                        currentPlanData.user_id = currentPlan["user_id"] as? String ?? ""
                        currentPlanData.zip = currentPlan["zip"] as? String ?? ""
                        currentPlanData.package_no_of_songs = currentPlan["package_no_of_songs"] as? String ?? ""

                        self.myPlanList.append(currentPlanData)
                    }
                }
                self.tableView.reloadData()
        }
    }

    fileprivate func getArtisPlantList(){
        self.activityIndicator.startAnimating()
        planList = [SubscriptionPlanModel]()
        let reuestURL = "https://tonnerumusic.com/api/v1/artist_subscription"
        let urlConvertible = URL(string: reuestURL)!
        Alamofire.request(urlConvertible,
                          method: .post,
                          parameters: [
                            "artist_id": UserDefaults.standard.fetchData(forKey: .userId)
            ] as [String: String])
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
            
                if(resposeJSON["status"] as? Bool ?? false){
                    let allPlans = resposeJSON["subscriptions"] as? NSArray ?? NSArray()
                    allPlans.forEach { (plan) in
                        let currentPlan = plan as? NSDictionary ?? NSDictionary()
                        var currentPlanData = SubscriptionPlanModel()
                        currentPlanData.id = currentPlan["package_id"] as? String ?? ""
                        currentPlanData.name = currentPlan["package_name"] as? String ?? ""
                        currentPlanData.price = currentPlan["package_price"] as? String ?? ""
                        currentPlanData.description = currentPlan["package_description"] as? String ?? ""
                        currentPlanData.status = currentPlan["artist_package_status_id"] as? String ?? ""
                        currentPlanData.package_no_of_songs = currentPlan["package_no_of_songs"] as? String ?? ""
                        self.planList.append(currentPlanData)
                    }
                }
                self.tableView.reloadData()
        }
    }
}


extension SubscriptionViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return myPlanList.count
        }else{
            return planList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlanTableViewCell", for: indexPath) as! MyPlanTableViewCell
            cell.data = myPlanList[indexPath.row]
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTableViewCell", for: indexPath) as! SubscriptionTableViewCell
            cell.backView.layer.cornerRadius = 5
            cell.backView.clipsToBounds = true
            cell.data = planList[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.section == 0 {
            return 257
        }else{
            return 180
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmSubscriptionViewController") as! ConfirmSubscriptionViewController
        let obj = planList[indexPath.row]
        destination.plan_id = obj.id
        self.navigationController!.pushViewController(destination, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView:UIView =  UIView()
            headerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            let label = UILabel(frame: CGRect(x: 16, y: 15, width: 300, height: 20))
            label.text = "YOUR CURRENT PACKAGE"
            label.textColor = #colorLiteral(red: 0.8838357329, green: 0.72747159, blue: 0.3263035417, alpha: 1)
            label.font = UIFont.boldSystemFont(ofSize: 22)
            headerView.addSubview(label)
            return headerView
        }else{
            let headerView:UIView =  UIView()
            headerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            let label = UILabel(frame: CGRect(x: 16, y: 15, width: 200, height: 20))
            label.text = "CHANGE PACKAGE"
            label.textColor = #colorLiteral(red: 0.8838357329, green: 0.72747159, blue: 0.3263035417, alpha: 1)
            label.font = UIFont.boldSystemFont(ofSize: 22)
            headerView.addSubview(label)
            return headerView
        }
        
    }
}
