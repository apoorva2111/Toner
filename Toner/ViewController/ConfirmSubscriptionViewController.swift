//
//  ConfirmSubscriptionViewController.swift
//  Toner
//
//  Created by Apoorva Gangrade on 22/04/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class ConfirmSubscriptionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtNameOnCard: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtcvv: UITextField!
    let thePicker = UIPickerView()
    let yearPicker = UIPickerView()
    let cardType = UIPickerView()
    var activityIndicator: NVActivityIndicatorView!
    var artistId:String!
    var plan_id = ""
    

    @IBOutlet weak var txtCard: UITextField!
    @IBAction func btnPayNowAction(_ sender: UIButton) {
        getMembership()
        
    }
    
    
    var arrYear = [String]()
    let arrMonth = ["January","February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let arrCard = ["Visa","Master Card", "Discover Card", "American Express", "Maestro", "SOLO"]

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.setNavigationBar(title: "Confirm Subscription", isBackButtonRequired: true, isTransparent: false)
        txtYear.delegate = self
        txtMonth.delegate = self
        txtCard.delegate = self
        txtcvv.delegate = self
        SetUI()
        
    }
    
    func SetUI(){
        txtMonth.inputView = thePicker
        txtYear.inputView = yearPicker
        txtCard.inputView = cardType
        thePicker.delegate = self
        yearPicker.delegate = self
        cardType.delegate = self
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let dateStr = formatter.string(from: NSDate() as Date)
        print(dateStr)
        var date : Int = Int(dateStr)!
        arrYear.append(dateStr)
        for _ in 0...10 {
            date += 1
            print(date)
            let strDate = String(date)
            arrYear.append(strDate)

        }
     
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = txtcvv.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 3
    }
    
    
    func getMembership() {
        self.activityIndicator.startAnimating()
        let userId:String = UserDefaults.standard.fetchData(forKey: .userId)
        let apiUrl = "https://tonnerumusic.com/api/v1/membersubscribtion"
        let urlConvertible = URL(string: apiUrl)!
        let param:[String:Any] = ["user_id": userId,
                                "plan_id": plan_id,
                                "payment_method":"Paypal"]
        
        Alamofire.request(urlConvertible,method: .post,parameters: param).validate().responseJSON { (response) in
                        print(response)
        
        
                    let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
        
                  print(resposeJSON)
                    self.activityIndicator.stopAnimating()
        
        
            }
    }
}

// MARK: UIPickerView Delegation

extension ConfirmSubscriptionViewController : UIPickerViewDelegate, UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == thePicker{
        return arrMonth.count
        }else if pickerView == yearPicker {
            return arrYear.count
        }else{
            return arrCard.count
        }
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == thePicker{
        return arrMonth[row]
        }else if pickerView == yearPicker {
        return arrYear[row]
        }else{
            return arrCard[row]
        }
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == thePicker{
        txtMonth.text = arrMonth[row]
        }else if pickerView == yearPicker {
            txtYear.text = arrYear[row]
        }else{
            txtCard.text = arrCard[row]
        }
    }
}
