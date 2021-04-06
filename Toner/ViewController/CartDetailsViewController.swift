//
//  CartDetailsViewController.swift
//  Toner
//
//  Created by Mona on 19/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CartDetailsViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutButton: UIButton!
    var cartListModel = [CartListModel]()
    var totalAmount:Double = 0
    var CollectionOfCell = [CartListCell]()
    var subTotalAmountText: UILabel!
    
    fileprivate func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "CartListCell", bundle: nil), forCellReuseIdentifier: "CartListCell")
        tableView.register(UINib(nibName: "CartAmountFooterCell", bundle: nil), forCellReuseIdentifier: "CartAmountFooterCell")
        self.tableView.backgroundColor = ThemeColor.backgroundColor
        self.updateCartPrice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "Shopping Cart", isBackButtonRequired: true , isTransparent: false)
        self.setNeedsStatusBarAppearanceUpdate()
        
        setUpTableView()
        checkOutButton.setTitleColor(.black, for: .normal)
        checkOutButton.backgroundColor = ThemeColor.buttonColor
        checkOutButton.setTitle("CheckOut", for: .normal)
        checkOutButton.titleLabel?.font = UIFont.montserratMedium.withSize(18)
       // self.appD.cartListModel[0].productDetailsModel.price
        print("self.appD.cartListModel\(self.appD.cartListModel)")
        

    }
    
    @IBAction func checkOutButtonClicked(_ sender: Any) {
        let destination = AddressViewController(nibName: "AddressViewController", bundle: nil)
       
        self.navigationController!.pushViewController(destination, animated: true)
    }
  
   
}

extension CartDetailsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appD.cartListModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
        setUpCellElements(cell, indexPath)
        CollectionOfCell.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            // remove the item from the data model
            let alert = UIAlertController(
                title: "Remove Item!",
                message: "Are you sure want to remove this item?",
                preferredStyle: UIAlertController.Style.alert
            )

            alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in
                self.appD.cartListModel.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.updateCartPrice()
            })

            
            alert.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel
            ))
            
            self.present(
                alert,
                animated: true,
                completion: nil
            )
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: CartAmountFooterCell = tableView.dequeueReusableCell(withIdentifier: "CartAmountFooterCell") as! CartAmountFooterCell
        
        footerView.backgroundColor = ThemeColor.backgroundColor
        footerView.contentView.backgroundColor = ThemeColor.backgroundColor
        
        footerView.subTotalAmountText.text = "$" + String(totalAmount)
        subTotalAmountText = footerView.subTotalAmountText
        footerView.subTotalAmountText.setNeedsDisplay()
        return footerView.contentView

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    fileprivate func setUpCellElements(_ cell: CartListCell, _ indexPath: IndexPath) {
        cell.productSizeField.pickerDelegate = self
        cell.delegate = self
        cell.productSizeField.dataSource = self
        let imageUrl = self.appD.cartListModel[indexPath.row].productDetailsModel.images[0].thumb
        cell.posterImage.kf.setImage(with:  URL(string: imageUrl))
        cell.noOfProduct.value = self.appD.cartListModel[indexPath.row].quantity
        cell.price.text = "$" + String(self.appD.cartListModel[indexPath.row].price)
        cell.productSizeField.isHidden = self.appD.cartListModel[indexPath.row].size != "" ? false : true
        cell.productSizeField.text = self.appD.cartListModel[indexPath.row].size
        cell.productName.text = self.appD.cartListModel[indexPath.row].productName
        cell.noOfProduct.tag = indexPath.row
        cell.noOfProduct.addTarget(self, action: #selector(self.quantityValueChanged(_:)), for: .valueChanged)
    }
    
    @objc fileprivate func quantityValueChanged(_ sender: ValueStepper){
        self.appD.cartListModel[sender.tag].quantity = sender.value
        updateCartPrice()
    }
    fileprivate func updateCartPrice(){
        totalAmount = 0.0
        self.appD.cartListModel.forEach { (cartData) in
            totalAmount = totalAmount + cartData.totalamountOfEachItem
        }
        self.subTotalAmountText?.text = "$" + String(totalAmount)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "itemCount"), object: nil)
    }
    
}


extension CartDetailsViewController: APJTextPickerViewDataSource, APJTextPickerViewDelegate{
    func numberOfRows(in pickerView: APJTextPickerView) -> Int {
        return self.appD.cartListModel[0].productDetailsModel.options[0].options.count
    }
    func textPickerView(_ textPickerView: APJTextPickerView, titleForRow row: Int) -> String? {
        return self.appD.cartListModel[0].productDetailsModel.options[0].options[row]
    }
    
    
}

extension CartDetailsViewController : CartListCellDelegate {
func didSelectStepperValue(value: Double, index: Int) {
    return
    switch self.appD.getStepperUpdate {
        
        case .increaseValue:
            totalAmount = self.appD.cartListModel[index].price + totalAmount
            self.appD.cartListModel[index].quantity = value
            tableView.reloadData()
            print("totalAmount\(totalAmount)")
        
        case .decreaseValue:
            totalAmount =  totalAmount - self.appD.cartListModel[index].price
            self.appD.cartListModel[index].quantity = value
            tableView.reloadData()
            print("totalAmount123\(totalAmount)")
        
        case .none:
            
            print("totalAmount")
      }
    
    }
}
