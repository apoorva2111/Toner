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
        tableView.dataSource = self
        tableView.delegate = self
        getPlanList()
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
        return section == 0 ? 0 : planList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTableViewCell", for: indexPath) as! SubscriptionTableViewCell
        cell.backView.layer.cornerRadius = 5
        cell.backView.clipsToBounds = true
        cell.data = planList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmSubscriptionViewController") as! ConfirmSubscriptionViewController
        let obj = planList[indexPath.row]
        destination.plan_id = obj.id
        self.navigationController!.pushViewController(destination, animated: true)
    }
}
