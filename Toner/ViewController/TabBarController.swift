//
//  TabBarController.swift
//  Toner
//
//  Created by Users on 07/11/19.
//  Copyright © 2019 Users. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    private let playerViewController = PlayerViewController()
    private var coordinator: TransitionCoordinator!
    let myTabBarItem3 = UITabBarItem()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().tintColor = ThemeColor.buttonColor
        NotificationCenter.default.addObserver(self, selector: #selector(itemsAdded), name: NSNotification.Name(rawValue: "itemCount"), object: nil)
        add(playerViewController)
        view.bringSubviewToFront(self.tabBar)
        
        let myTabBarItem1 = UITabBarItem()
        myTabBarItem1.image = UIImage(named: "home")
        var myTabBarItem1Selected = UIImage(named: "home")
        myTabBarItem1Selected = myTabBarItem1Selected!.withRenderingMode(.alwaysTemplate)
        myTabBarItem1.selectedImage = myTabBarItem1Selected
        myTabBarItem1.title = "Home"
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navBar1 = UINavigationController(rootViewController: firstViewController)
        navBar1.tabBarItem = myTabBarItem1
        navBar1.title = "Home"
        
        
        
        let myTabBarItem2 = UITabBarItem()
        myTabBarItem2.image = UIImage(named: "search")
        var myTabBarItem2Selected = UIImage(named: "search")
        myTabBarItem2Selected = myTabBarItem2Selected!.withRenderingMode(.alwaysTemplate)
        myTabBarItem2.selectedImage = myTabBarItem2Selected
        myTabBarItem2.title = "Search"
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let navigationBar2 = UINavigationController(rootViewController: secondViewController)
        navigationBar2.tabBarItem = myTabBarItem2

        let myTabBarItem4 = UITabBarItem()
        myTabBarItem4.image = UIImage(named: "for-you")
        var myTabBarItem4Selected = UIImage(named: "for-you")
        myTabBarItem4Selected = myTabBarItem4Selected!.withRenderingMode(.alwaysTemplate)
        myTabBarItem4.selectedImage = myTabBarItem4Selected
        myTabBarItem4.title = "My Library"
        myTabBarItem4.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let fourthViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayListViewController") as! PlayListViewController
        let navigationBar4 = UINavigationController(rootViewController: fourthViewController)
        navigationBar4.tabBarItem = myTabBarItem4
        
        
       //Apoorva
//        myTabBarItem3.image = UIImage(named: "merchandise")
//        var myTabBarItem3Selected = UIImage(named: "merchandise")
//        myTabBarItem3Selected = myTabBarItem3Selected!.withRenderingMode(.alwaysTemplate)
//        myTabBarItem3.selectedImage = myTabBarItem3Selected
//        myTabBarItem3.title = "Shop"
//
//        myTabBarItem3.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        let thirdViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MerchandiseViewController") as! MerchandiseViewController
//        let navigationBar3 = UINavigationController(rootViewController: thirdViewController)
//
//        navigationBar3.tabBarItem = myTabBarItem3
        
        //Apoorva
        let myTabBarItem5 = UITabBarItem()
        myTabBarItem5.image = UIImage(named: "settings")
        var myTabBarItem5Selected = UIImage(named: "settings")
        myTabBarItem5Selected = myTabBarItem5Selected!.withRenderingMode(.alwaysTemplate)
        myTabBarItem5.selectedImage = myTabBarItem5Selected
        myTabBarItem5.title = "Settings"
        myTabBarItem5.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let fifthViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let navigationBar5 = UINavigationController(rootViewController: fifthViewController)
                
        navigationBar5.tabBarItem = myTabBarItem5
//Apoorva 
//        let tabBarList = [navBar1, navigationBar2, navigationBar4, navigationBar3, navigationBar5]
        let tabBarList = [navBar1, navigationBar2, navigationBar4, navigationBar5]

        viewControllers = tabBarList
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideMiniView), name: Notification.Name("hideMiniView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showMiniView), name: Notification.Name("showMiniView"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let additionalBottomInset = tabBar.bounds.height
        playerViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: additionalBottomInset, right: 0)
        coordinator = TransitionCoordinator(tabBarViewController: self, playerViewController: playerViewController)
        view.bringSubviewToFront(self.playerViewController.miniPlayerView)
        hideMiniView()
        
        
    }
    
    public func showTabBar(){
        view.bringSubviewToFront(self.tabBar)
    }
    
    public func hideTabBar(){
        view.sendSubviewToBack(self.tabBar)
    }
    
    @objc public func showMiniView(){
        
//        let additionalBottomInset = tabBar.bounds.height
//        playerViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: additionalBottomInset, right: 0)
//        view.bringSubviewToFront(self.playerViewController.miniPlayerView)
        coordinator.updateUI(with: .closed)
        
    }
    @objc func itemsAdded(){
        self.myTabBarItem3.badgeValue = String(self.appD.cartListModel.count)
    }
    @objc public func hideMiniView(){
        coordinator.updateUI(with: .closed)
//        let additionalBottomInset = tabBar.bounds.height
//        playerViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -additionalBottomInset, right: 0)
//        view.sendSubviewToBack(self.playerViewController.miniPlayerView)
//        playerViewController.view.frame = CGRect(x: 0, y: playerViewController.miniPlayerView.frame.height, width: playerViewController.miniPlayerView.frame.width, height: playerViewController.miniPlayerView.frame.height)
    }
}
