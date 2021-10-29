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
//import Stripe
//var stripToken =  ""

protocol ConfirmSubscriptionDelegate {
    func backWithData(param : [String:Any])
}

class ConfirmSubscriptionViewController: UIViewController, UITextFieldDelegate {
    var delegate : ConfirmSubscriptionDelegate?
    @IBOutlet weak var txtNameOnCard: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtcvv: UITextField!
    @IBOutlet weak var viewHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    
    let thePicker = UIPickerView()
    let yearPicker = UIPickerView()
    let cardType = UIPickerView()
    var activityIndicator: NVActivityIndicatorView!
    var artistId:String!
    var plan_id = ""
    var isPaypal = false
    var isFromCheckSub = false
    var monthIndex = 1
    @IBOutlet weak var imgRadioPaypal: UIImageView!
    @IBOutlet weak var imgRadioCoin: UIImageView!
   
    @IBOutlet weak var txtCard: UITextField!
    @IBAction func btnPayNowAction(_ sender: UIButton) {
validation()
    }
    @IBOutlet weak var imgSong: UIImageView!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblSongAmount: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    var subArtistName = ""
    var subArtistAmount = ""
    var subArtistSongName = ""
    var subArtistDuration = ""
    var subArtistImage = ""
    var arrYear = [String]()
    let arrMonth = ["January","February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let arrCard = ["Visa","Master Card", "Discover Card", "American Express", "Maestro", "SOLO"]

    @IBOutlet weak var viewSong: UIView!
    @IBOutlet weak var viewSongHeight: NSLayoutConstraint!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        if subArtistName != "" {
            viewSongHeight.constant = 300
            viewSong.isHidden = false
            lblDuration.text = "Duration: " + subArtistDuration
            lblSongName.text = subArtistSongName
            lblSongAmount.text = "$ " + subArtistAmount
            lblArtistName.text = "Artist: " + subArtistName
         let artistURL = URL(string: subArtistImage)
            imgSong.kf.setImage(with: artistURL)
            imgSong.contentMode = .scaleToFill

        }else{
            viewSongHeight.constant = 0
            viewSong.isHidden = true
        }
        
        //Subscription
        if  UserDefaults.standard.value(forKey: "userSubscribed") as! Int == 0{
            viewHeaderHeightConstraint.constant = 70.5
            self.setNavigationBar(title: "Confirm Subscription", isBackButtonRequired: true, isTransparent: false)
            btnBackOutlet.isHidden = false
        }else{
            viewHeaderHeightConstraint.constant = 0
            btnBackOutlet.isHidden = false
            self.setNavigationBar(title: "Confirm Subscription", isBackButtonRequired: true, isTransparent: false)
        }
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
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let textFieldText = txtcvv.text,
//            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//                return false
//        }
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
//        let count = textFieldText.count - substringToReplace.count + string.count
//        return count <= 3
//    }
    func validation(){
        if txtNameOnCard.text == "" && txtCardNumber.text == "" && txtCard.text == "" && txtcvv.text == "",txtYear.text == "" && txtMonth.text == ""{
            showAlert(message: "All feilds are required")
        }else if  txtNameOnCard.text == ""{
        showAlert(message: "Please Enter Card Name")

        }else if txtCardNumber.text == ""{
            showAlert(message: "Please Enter Card Number")

        }else if txtCard.text == ""{
            showAlert(message: "Please Select Card Type")

        }else if txtcvv.text == ""{
            showAlert(message: "Please Enter Card CVV")

        }else if txtYear.text == ""{
            showAlert(message: "Please Select Card Expire Year")

        }else if txtMonth.text == ""{
            showAlert(message: "Please Select Card Expire Month")

        }
        else if txtCardNumber.text!.count < 12 {
            showAlert(message: "Card Number Should be greater than 12")
        }
        else{
            paypalToken()
        }
    }
    
    func paypalToken(){
        if self.plan_id != ""{
            if UserDefaults.standard.fetchData(forKey: .userGroupID) == "3" {
                self.getMembershipForArtist()
            }else{
                self.getMembership()
            }
        }else{
            let userId:String = UserDefaults.standard.fetchData(forKey: .userId)
            let param:[String:Any] = ["user_id": Int(userId) ?? 0,
                                      "payment_method": isPaypal ? "paypal" : "coinpayment",
                                      "card_type": txtCard.text ?? "",
                                      "card_number": txtCardNumber.text ?? "",
                                      "cc_expire_date_month": String(monthIndex),
                                      "cc_expire_date_year": txtYear.text ?? "",
                                      "cc_cvv2": txtcvv.text ?? "",
            ]
            delegate?.backWithData(param: param)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    func getStripToken(){
//        //card parameters
//        self.activityIndicator.startAnimating()
//
//        let stripeCardParams = STPCardParams()
//        stripeCardParams.number = txtCardNumber.text
//        let df = DateFormatter()
//        df.locale = Locale(identifier: "en_US_POSIX")
//        df.dateFormat = "LLLL"  // if you need 3 letter month just use "LLL"
//        if let date = df.date(from: txtMonth.text!) {
//            let month = Calendar.current.component(.month, from: date)
//            print(month)  // 5
//
//            stripeCardParams.expMonth = UInt(month) //UInt(expiryParameters?.first ?? "0") ?? 0
//        }
//        stripeCardParams.expYear = UInt(txtYear.text ?? "0") ?? 0//UInt(expiryParameters?.last ?? "0") ?? 0
//        stripeCardParams.cvc = txtcvv.text
//        stripeCardParams.name = txtNameOnCard.text!
//
//        //converting into token
//        let config = STPPaymentConfiguration.shared
//        let stpApiClient = STPAPIClient.init(configuration: config)
//        stpApiClient.createToken(withCard: stripeCardParams) { (token, error) in
//            if error == nil {
//
//                //Success
//                DispatchQueue.main.async {
//
//                    stripToken = token!.tokenId
//                    if self.plan_id != ""{
//                        if UserDefaults.standard.fetchData(forKey: .userGroupID) == "3" {
//                            self.getMembershipForArtist()
//                        }else{
//                            self.getMembership()
//                        }
//                    }else{
//                        self.navigationController?.popViewController(animated: true)
//                    }
////
//                }
//
//            } else {
//
//                //failed
//                self.activityIndicator.stopAnimating()
//                self.showAlert(message: "Please check your Card Detail")
//                print("Failed")
//            }
//        }
//    }
    func getMembership(){
        //            self.activityIndicator.startAnimating()
        
        let userId:String = UserDefaults.standard.fetchData(forKey: .userId)
        let apiUrl = "https://tonnerumusic.com/api/v1/membersubscribtion"
        let urlConvertible = URL(string: apiUrl)!
        let param:[String:Any] = ["user_id": Int(userId) ?? 0,
                                  "plan_id": Int(plan_id)!,
                                  "payment_method": isPaypal ? "paypal" : "coinpayment",
                                  "card_type": txtCard.text ?? "",
                                  "card_number": txtCardNumber.text ?? "",
                                  "cc_expire_date_month": String(monthIndex),
                                  "cc_expire_date_year": txtYear.text ?? "",
                                  "cc_cvv2": txtcvv.text ?? "",
//                                  "stripe_token":stripToken
        ]
        print(param)
        
        Alamofire.request(urlConvertible,method: .post,parameters: param).validate().responseJSON { (response) in
            print(response)
            
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            
            print(resposeJSON)
            if let status = resposeJSON["status"]{
                if status as! Int == 0 {
                    self.activityIndicator.stopAnimating()
                }else{
                    //                        UserDefaults.standard.setValue(1, forKey: "userSubscribed")
                    //                        UserDefaults.standard.synchronize()
                    //
                    //                        self.navigationController?.popViewController(animated: true)
                    
                    if UserDefaults.standard.value(forKey: "userSubscribed")as! Int == 0 {
                        UserDefaults.standard.setValue(1, forKey: "userSubscribed")
                        UserDefaults.standard.synchronize()
                        self.activityIndicator.stopAnimating()
                        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                        self.appD.window?.rootViewController = destination
                        
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    self.activityIndicator.stopAnimating()
                }
            }
            self.activityIndicator.stopAnimating()
        }
    }

    
    func getMembershipForArtist(){
        
        let userId:String = UserDefaults.standard.fetchData(forKey: .userId)
        let apiUrl = "https://tonnerumusic.com/api/v1/artistsubscription"
        let urlConvertible = URL(string: apiUrl)!
        let param:[String:Any] = ["user_id": Int(userId) ?? 0,
                                  "plan_id": Int(plan_id)!,
                                  "payment_method": isPaypal ? "paypal" : "coinpayment",
                                  "card_type": txtCard.text ?? "",
                                  "card_number": txtCardNumber.text ?? "",
                                  "cc_expire_date_month": String(monthIndex),
                                  "cc_expire_date_year": txtYear.text ?? "",
                                  "cc_cvv2": txtcvv.text ?? "",
//                                  "stripe_token":stripToken
        ]
        print(param)
        
        Alamofire.request(urlConvertible,method: .post,parameters: param).validate().responseJSON { (response) in
            print(response)
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            print(resposeJSON)
            if let status = resposeJSON["status"]{
                if status as! Int == 0 {
                    self.showAlert(message: "Something went Wrong")
                    self.activityIndicator.stopAnimating()
                }else{
                    if UserDefaults.standard.value(forKey: "userSubscribed")as! Int == 0 {
                        UserDefaults.standard.setValue(1, forKey: "userSubscribed")
                        UserDefaults.standard.synchronize()
                        self.activityIndicator.stopAnimating()
                        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                        self.appD.window?.rootViewController = destination
                        
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            self.activityIndicator.stopAnimating()
        }
    }
    @IBAction func btnRadioAction(_ sender: UIButton) {
        if sender.tag == 10{
            imgRadioPaypal.image = #imageLiteral(resourceName: "radioSelect")
            imgRadioCoin.image = #imageLiteral(resourceName: "radioUnselect")
            isPaypal = true
            
        }else{
            imgRadioCoin.image = #imageLiteral(resourceName: "radioSelect")
            imgRadioPaypal.image = #imageLiteral(resourceName: "radioUnselect")
            isPaypal = false
        }
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            monthIndex = row + 1
        }else if pickerView == yearPicker {
            txtYear.text = arrYear[row]
        }else{
            txtCard.text = arrCard[row]
        }
    }
}
