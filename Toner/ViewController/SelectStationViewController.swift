//
//  SelectStationViewController.swift
//  Toner
//
//  Created by Mona on 17/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class SelectStationViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    static var selectedStationName:[String] = []
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUptableview()
        backView.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction(sender:)))
        tapGesture.numberOfTapsRequired = 1
        self.mainView.addGestureRecognizer(tapGesture)
        self.mainView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.doneButton.setTitle("Done", for: .normal)
        self.doneButton.setTitleColor(.white, for: .normal)
        self.doneButton.backgroundColor = ThemeColor.buttonColor
        self.doneButton.layer.cornerRadius = self.doneButton.frame.height / 2
        self.doneButton.clipsToBounds = true
        self.doneButton.titleLabel?.font = UIFont.montserratRegular.withSize(15)
        self.doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
    }
    
    fileprivate func dismissViewWithAnimation() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .fade
        transition.subtype = .fromBottom
        self.view.window!.layer.add(transition, forKey: nil)
    }
    
    @objc func doneButtonAction(){
        dismissViewWithAnimation()
        self.dismiss(animated: false, completion: nil)
        // self.dismiss(animated: true, completion: nil)
    }
    @objc func tapGestureAction(sender: UITapGestureRecognizer){
        self.backView.backgroundColor = UIColor.clear
        dismissViewWithAnimation()
        self.dismiss(animated: true, completion: nil)
        
    }

    fileprivate func setUptableview(){
        self.tableView.backgroundColor = .black
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.isEditing = false
//        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.allowsSelection = true
        self.tableView.separatorStyle = .none
    }

}
extension SelectStationViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appD.genreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = ThemeColor.backgroundColor
        cell.textLabel?.text = self.appD.genreData[indexPath.row].name
        cell.textLabel?.font = UIFont.montserratRegular.withSize(15)
        cell.imageView?.tintColor = ThemeColor.subHeadingColor
        cell.textLabel?.textColor = ThemeColor.subHeadingColor
        if SelectStationViewController.selectedStationName.contains(self.appD.genreData[indexPath.row].name) {
               cell.imageView?.image = UIImage(icon: .FACheckSquare, size: CGSize(width: 30, height: 30), textColor: .white)
        } else {
              cell.imageView?.image = UIImage(icon: .FASquare, size: CGSize(width: 30, height: 30), textColor: .white)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.didSelectStation(tableview: tableView, indexPath: indexPath)
    }
    
    
    
}

extension SelectStationViewController{
    
    func didSelectStation(tableview : UITableView, indexPath : IndexPath) {

        if SelectStationViewController.selectedStationName.contains(self.appD.genreData[indexPath.row].name) {
            let myIndex = SelectStationViewController.selectedStationName.firstIndex(of: self.appD.genreData[indexPath.row].name)
              SelectStationViewController.selectedStationName.remove(at: myIndex!)
            
            
        } else {
              SelectStationViewController.selectedStationName.append(self.appD.genreData[indexPath.row].name)
        }
         print("self.selectedStationName\(SelectStationViewController.selectedStationName)")
        self.tableView.reloadData()
    }
    
    
}
