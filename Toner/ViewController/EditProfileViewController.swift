//
//  EditProfileViewController.swift
//  Toner
//
//  Created by User on 26/09/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var datePicker: APJTextPickerView!
    @IBOutlet weak var tagLineText: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var genderPicker: APJTextPickerView!
    @IBOutlet weak var paypalID: UITextField!
    @IBOutlet weak var btnOutletChangeAvtar: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var selectStation: UITextField!
    @IBAction func btnChangeAvtarAction(_ sender: UIButton) {
        presentPhoto()

    }
    
    
    var imagData =  Data()
    var activityIndicator: NVActivityIndicatorView!
    var genderData = ["Male", "Female"]
    var selectedGender = "male"
    var selectedDate = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "Edit Profile", isBackButtonRequired: true, isTransparent: false)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        initialSetUp()
        self.emailTextField.isEnabled = false
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = #colorLiteral(red: 0.9253032804, green: 0.7255734801, blue: 0.146667093, alpha: 1)

        profileImage.clipsToBounds = true
        btnOutletChangeAvtar.layer.cornerRadius = 5
        btnOutletChangeAvtar.layer.borderWidth = 1
        btnOutletChangeAvtar.layer.borderColor = #colorLiteral(red: 0.9253032804, green: 0.7255734801, blue: 0.146667093, alpha: 1)
        btnOutletChangeAvtar.layer.masksToBounds = true
        getProfileDetails()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectStation.text = SelectStationViewController.selectedStationName.joined(separator: ",")
        
        
    }
    fileprivate func initialSetUp(){
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        profileImage.kf.setImage(with: URL(string: UserDefaults.standard.fetchData(forKey: .userImage)))
        
        setUpTextFields(firstName, value: UserDefaults.standard.fetchData(forKey: .userFirstName), placeHolder: "First Name")
        setUpTextFields(lastName, value: UserDefaults.standard.fetchData(forKey: .userLastName), placeHolder: "Last Name")
        setUpTextFields(emailTextField, value: UserDefaults.standard.fetchData(forKey: .userEmail), placeHolder: "Email Address")
        setUpTextFields(phoneText, value: UserDefaults.standard.fetchData(forKey: .userPhone), placeHolder: "Phone Number")
        setUpTextFields(paypalID, value: "", placeHolder: "Paypal ID")
        setUpTextFields(tagLineText, value: "", placeHolder: "Tag Line")
        
        if UserDefaults.standard.fetchData(forKey: .userGroupID) == "3" {
             selectStation.isHidden = false
             setUpTextFields(selectStation, value: SelectStationViewController.selectedStationName.joined(separator: ","), placeHolder: "Station Prefered")
        }else{
            selectStation.isHidden = true
        }
        let textViewRecognizer = UITapGestureRecognizer()
        textViewRecognizer.addTarget(self, action: #selector(textFieldTouched(_:)))
        selectStation.addGestureRecognizer(textViewRecognizer)

        selectStation.inputView = UIView()
        selectStation.inputAccessoryView = UIView()
        selectStation.tintColor = .white
        
        genderPicker.dataSource = self
        genderPicker.pickerDelegate = self
        genderPicker.setPlaceholder(placeholder: "Select Gender", color: .gray)
        genderPicker.type = .strings
        genderPicker.pickerTitle = "Select Gender"
        genderPicker.currentIndexSelected = 0
        genderPicker.backgroundColor = .clear
        genderPicker.textColor = .white
        genderPicker.font = .montserratRegular
        genderPicker.addButtomBorder(color: UIColor.darkGray.cgColor)
        
        
        datePicker.dataSource = self
        datePicker.pickerDelegate = self
        datePicker.setPlaceholder(placeholder: "Date Of Birth", color: .gray)
        datePicker.type = .date
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        datePicker.dateFormatter = df
        datePicker.datePicker?.maximumDate = Date()
        datePicker.currentIndexSelected = 0
        datePicker.backgroundColor = .clear
        datePicker.textColor = .white
        datePicker.font = .montserratRegular
        datePicker.addButtomBorder(color: UIColor.darkGray.cgColor)
        
        self.submitButton.backgroundColor = ThemeColor.buttonColor
        self.submitButton.layer.cornerRadius = 10//self.submitButton.frame.height / 2
        self.submitButton.clipsToBounds = true
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.setTitle("UPDATE", for: .normal)
        self.submitButton.addTarget(self, action: #selector(self.updateButtonAction), for: .touchUpInside)
        
       
    }
    
    fileprivate func setUpTextFields(_ textField: UITextField, value: String, placeHolder: String){
        textField.text = value
        textField.setPlaceholder(placeholder: placeHolder, color: .gray)
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.font = .montserratRegular
        textField.tintColor = ThemeColor.buttonColor
        textField.addButtomBorder(color: UIColor.darkGray.cgColor)
    }
    
    @objc func textFieldTouched(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
               let destination = SelectStationViewController(nibName: "SelectStationViewController", bundle: nil)
               destination.modalPresentationStyle = .overCurrentContext
               destination.modalTransitionStyle = .crossDissolve
               self.present(destination, animated: true, completion: nil)
           }, completion: nil)
        
    }
    
    @objc func updateButtonAction(){
        
        if (firstName.text?.isBlank ?? true){
            self.tabBarController?.view.makeToast(message: "Please enter first name.")
            return
        }else if !(emailTextField.text?.isValidEmail ?? true){
            self.tabBarController?.view.makeToast(message: "Please enter valid email address.")
            return
        }
        
    
        var parameters : [String: Any] = [
            "email": emailTextField.text ?? "",
            "firstname": self.firstName.text ?? "",
            "lastname": self.firstName.text ?? "",
            "phone": self.phoneText.text ?? "",
            "gender": self.selectedGender,
            "paypal": self.paypalID.text ?? "",
            "dob": self.selectedDate,
            "tagline": self.tagLineText.text ?? "",
        ]
        
        self.activityIndicator.startAnimating()
        var reuestURL = "https://tonnerumusic.com/api/v1/artist_profile_edit"
        if UserDefaults.standard.fetchData(forKey: .userGroupID) == "4"{
            reuestURL = "https://tonnerumusic.com/api/v1/profile_edit"
            parameters["member_id"] = UserDefaults.standard.string(forKey: "userId")
        }else{
            parameters["user_id"] = UserDefaults.standard.string(forKey: "userId")
            parameters["genre_id"] = SelectStationViewController.selectedStationName
        }
        Alamofire.request(reuestURL, method: .post, parameters: parameters)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                let message = resposeJSON["message"] as? String ?? "Profile Updated Successfully."
                self.showAlert(message: message)
                
        }
    }
    
    fileprivate func getProfileDetails(){
        let parameters = [
            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
            ] as [String: String]
        
        self.activityIndicator.startAnimating()
        let reuestURL = "https://www.tonnerumusic.com/api/v1/member_profile"
        
        Alamofire.request(reuestURL, method: .post, parameters: parameters)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                print(resposeJSON)
                self.activityIndicator.stopAnimating()
                let memberJSON = resposeJSON["memberinfo"] as? NSDictionary ?? NSDictionary()
                self.firstName.text = memberJSON["firstname"] as? String ?? ""
                self.lastName.text = memberJSON["lastname"] as? String ?? ""
                self.emailTextField.text = memberJSON["email"] as? String ?? ""
                self.phoneText.text = memberJSON["phone"] as? String ?? ""
                self.genderPicker.currentIndexSelected = ((memberJSON["gender"] as? String ?? "male") == "male" ? 0 : 1)
                let dateText = memberJSON["dob"] as? String ?? "1970-01-01"
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.datePicker.currentDate = formatter.date(from: dateText)
                self.datePicker.text = formatter.string(from: self.datePicker.currentDate ?? Date())
                self.selectedDate = dateText
                self.paypalID.text = memberJSON["paypal"] as? String ?? ""
                self.tagLineText.text = memberJSON["tagline"] as? String ?? ""
                self.lblUserName.text = memberJSON["username"] as? String ?? ""
                
        }
    }

}


extension EditProfileViewController: APJTextPickerViewDataSource, APJTextPickerViewDelegate{
    func numberOfRows(in pickerView: APJTextPickerView) -> Int {
        return genderData.count
    }
    func textPickerView(_ textPickerView: APJTextPickerView, titleForRow row: Int) -> String? {
        return genderData[row]
    }
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectString row: Int) {
        selectedGender = genderData[row]
    }
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectDate date: Date?) {
        self.selectedDate = self.datePicker.text ?? ""
    }
}

//MARK:- Change Image
extension EditProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhoto() {
        let actionSheet = UIAlertController(title: "Add Image",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentCamera1()
                                                
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                //   self?.presentPhotoPicker1()
                                                let photoPicker = UIImagePickerController()
                                                photoPicker.delegate = self
                                                photoPicker.sourceType = .photoLibrary
                                                self!.present(photoPicker, animated: true, completion: nil)
                                                
                                            }))
        self.present(actionSheet, animated: true)
        actionSheet.view.superview?.isUserInteractionEnabled = true
        actionSheet.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
    }
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
    func presentCamera1() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
            imagData = selectedImage.jpegData(compressionQuality: 0.5)!
        }
        
        //dismiss(animated: true, completion: nil)
        dismiss(animated: true) {
            self.uploadImage()
            
        }
    }
   
    func uploadImage()
    {
        self.activityIndicator.startAnimating()

        if !NetworkReachabilityManager()!.isReachable{
                  return
        }
        let url = "https://tonnerumusic.com/api/v1/profile_image_edit"
       
        var headers = HTTPHeaders()

        
        headers = ["Content-type": "multipart/form-data"]

        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            multipartFormData.append(self.imagData, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
         
            let userID:String = UserDefaults.standard.fetchData(forKey: .userId) //"53"

            multipartFormData.append(userID.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"user_id")

        }, to: url,method:HTTPMethod.post,
           headers:headers,
           encodingCompletion: { encodingResult in
            DispatchQueue.main.async {
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        self.activityIndicator.stopAnimating()
                    }
                case .failure(let error):
                    print(error)
                    self.activityIndicator.stopAnimating()

                }
            }
        })
      

    }
}
