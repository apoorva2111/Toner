//
//  ProductDetailsViewController.swift
//  Toner
//
//  Created by User on 09/07/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Kingfisher

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtons: UIStackView!
    @IBOutlet weak var productDetailsView: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var valueStepper: ValueStepper!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var sizePicker: APJTextPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var banners: ZKCarousel!
    @IBOutlet weak var productBanners: UICollectionView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    var productName: String = ""
    var productID: String = ""
    var activityIndicator: NVActivityIndicatorView!
    var productDetails: ProductDetailsModel!
    var isPrintful = false
    let cartButton = BadgedButtonItem(with: UIImage(named: "merchandise"))
    static var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(itemsAdded), name: NSNotification.Name(rawValue: "itemCount"), object: nil)
        // Do any additional setup after loading the view.
        self.cartButton.setBadge(with: ProductDetailsViewController.count)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.view.backgroundColor = ThemeColor.backgroundColor
        
        self.setNavigationBar(title: "", isBackButtonRequired: true)
        cartButton.badgeTextColor = .black
        cartButton.badgeTintColor = ThemeColor.buttonColor
        cartButton.position = .left
        cartButton.hasBorder = true
        //cartButton.borderColor = .red
        cartButton.badgeSize = .medium
        cartButton.badgeAnimation = true
        
        self.navigationItem.rightBarButtonItem = cartButton
        cartButton.tapAction = {
            ProductDetailsViewController.count = 0
            self.cartButton.setBadge(with: 0)
            let destination = CartDetailsViewController(nibName: "CartDetailsViewController", bundle: nil)
            self.navigationController!.pushViewController(destination, animated: true)
        }
        self.setNeedsStatusBarAppearanceUpdate()
        bannerHeight.constant = UIScreen.main.bounds.width * (9/16)
        priceLabel.font = UIFont.montserratMedium.withSize(16)
        priceLabel.text = ""
        priceLabel.textColor = ThemeColor.buttonColor
        productDescriptionLabel.font = UIFont.montserratRegular
        self.productDetailsView.isHidden = true
        self.bottomButtons.alpha = 0
        if isPrintful{
            getPrintfulProductDetails(productId: productID)
        }else{
            getProductDetails(productId: productID)
        }
        
        
        
        self.addToCartButton.setTitleColor(.black, for: .normal)
        self.addToCartButton.backgroundColor = .white
        self.addToCartButton.titleLabel?.font = UIFont.montserratMedium
        self.addToCartButton.addTarget(self, action: #selector(self.addToCartAction), for: .touchUpInside)
        self.addToCartButton.setTitle("Go To Cart", for: .selected)
        
        self.buyNowButton.setTitleColor(.black, for: .normal)
        self.buyNowButton.backgroundColor = ThemeColor.buttonColor
        self.buyNowButton.titleLabel?.font = UIFont.montserratMedium
        self.buyNowButton.addTarget(self, action: #selector(self.buyNowAction), for: .touchUpInside)
        
//         productBanners.register(UINib(nibName: "ProductBannersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductBannersCollectionViewCell")
//        productBanners.dataSource = self
//        productBanners.delegate = self
//        self.banners.backgroundColhemeColor.backgroundColor
        
        self.banners.layer.cornerRadius = 2
        self.banners.clipsToBounds = true
        
    }
    @objc func itemsAdded(){
        self.cartButton.setBadge(with: self.appD.cartListModel.count)
    }
    override func viewWillAppear(_ animated: Bool) {
        if (TonneruMusicPlayer.player?.isPlaying ?? false){
            self.bottomConstraint.constant = 106
        }else{
            self.bottomConstraint.constant = 50
        }
    }
    
    func getProductDetails(productId id: String){
        self.activityIndicator.startAnimating()
        let apiURL = "http://www.tonnerumusic.com/api/v1/productdetails?product_id=\(id)"
        let urlConvertible = URL(string: apiURL)!
        Alamofire.request(urlConvertible,
                          method: .get,
                          parameters: nil)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
               
                self.productDetails = ProductDetailsModel()
                self.productDetails.description =  resposeJSON["description"] as? String ?? ""
                self.productDetails.price = resposeJSON["price"] as? String ?? "$0.00"
                self.productDetails.id = resposeJSON["product_id"] as? String ?? ""
                self.productDetails.model = resposeJSON["model"] as? String ?? ""
                let productImages = resposeJSON["images"] as? NSArray ?? NSArray()
                self.productDetails.images.removeAll()
                for index in 0..<productImages.count{
                    let currentItem = productImages[index] as? NSDictionary ?? NSDictionary()
                    var currentTopItems = ProductImages()
                    currentTopItems.thumb = currentItem["thumb"] as? String ?? ""
                    currentTopItems.popup = currentItem["popup"] as? String ?? ""
                    self.productDetails.images.append(currentTopItems)
                }
                
                let productOptions = resposeJSON["options"] as? NSArray ?? NSArray()
                for index in 0..<productOptions.count{
                    let currentOption = productOptions[index] as? NSDictionary ?? NSDictionary()
                    let currentProductOptions = currentOption["product_option_value"] as? NSArray ?? NSArray()
                    let optionName = currentOption["name"] as? String ?? ""
                    let optionType = currentOption["type"] as? String ?? ""
                    var options = [String]()
                    for ind in 0..<currentProductOptions.count{
                        let currentOp = currentProductOptions[ind] as? NSDictionary ?? NSDictionary()
                        let option = currentOp["name"] as? String ?? ""
                        options.append(option)
                    }
                    let productOP = ProductOptions(name: optionName, type: optionType, options: options)
                     self.productDetails.options.append(productOP)
                }
                self.setData()
        }
    }
    
    func getPrintfulProductDetails(productId id: String){
        self.activityIndicator.startAnimating()
        let apiURL = "http://www.tonnerumusic.com/api/v1/pproductdetails?product_id=\(id)"
        let urlConvertible = URL(string: apiURL)!
        Alamofire.request(urlConvertible,
                          method: .get,
                          parameters: nil)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                self.productDetails = ProductDetailsModel()
                self.productDetails.product_name = resposeJSON["product_name"] as? String ?? ""
                self.productDetails.model = resposeJSON["model"] as? String ?? ""
                self.productDetails.id = resposeJSON["product_id"] as? String ?? ""
                self.productDetails.description =  resposeJSON["description"] as? String ?? ""
                self.productDetails.price = resposeJSON["price"] as? String ?? "$0.00"
                self.productDetails.images.removeAll()
                let productImagePopUp = resposeJSON["popup"] as? String ?? ""
                let productImageThumb = resposeJSON["thumb"] as? String ?? ""
                let productImage = ProductImages(popup: productImagePopUp, thumb: productImageThumb)
                self.productDetails.images.append(productImage)
                self.productDetails.price = resposeJSON["price"] as? String ?? "$0.00"
                self.setData()
        }
    }
    
    @objc func buyNowAction(){
        
        
    }
    
    @objc func addToCartAction(){
        let actualAmount = self.productDetails.price.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
        let price = Double(actualAmount) ?? 0
        let cartData = CartListModel(productDetailsModel: productDetails,
                                                size: self.sizePicker.text ?? "",
                                                quantity: self.valueStepper.value,
                                                price: price,
                                                productName: self.productName
                                                )
       self.appD.cartListModel.append(cartData)
//       destination.totalAmount = self.appD.cartListModel.reduce(0){
//           return ($0 + $1.price)
//       }
        if self.addToCartButton.isSelected {
            self.addToCartButton.isSelected = false
            let destination = CartDetailsViewController(nibName: "CartDetailsViewController", bundle: nil)
            self.navigationController!.pushViewController(destination, animated: true)
        }else{
            self.addToCartButton.isSelected = true
            //self.navigationController?.tabBarItem.badgeValue = "1"
            ProductDetailsViewController.count = ProductDetailsViewController.count + 1
            self.cartButton.setBadge(with: self.appD.cartListModel.count)
        }
       
        
        
    }
    
    fileprivate func setData(){
       
        self.productDetailsView.isHidden = false
        self.productDetailsView.alpha = 0
        UIView.animate(withDuration: 0.35, delay: 0.1, options: .curveEaseIn, animations: {
            self.productDetailsView.alpha = 1.0
            self.bottomButtons.alpha = 1.0
        }, completion: nil)
       
        let _ = self.productDetails.images.map { (productImages) -> Void in
            let slide1 = ZKCarouselSlide(image: productImages.popup)
            self.banners.slides.append(slide1)
        }
        if isPrintful{
            self.leftConstraint.constant = 0
        }
        
        self.productNameLabel.text = self.productName
        self.productNameLabel.textColor = .white
        self.productNameLabel.font = UIFont.montserratMedium.withSize(17)
        self.productNameLabel.numberOfLines =  2
//        self.productBanners.reloadData()
//        Set Data for Product Desccription
        let productDescription = (self.productDetails.description.replacingOccurrences(of: "<br />", with: ""))
        self.productDescriptionLabel.text = productDescription
        self.productDescriptionLabel.textColor = ThemeColor.subHeadingColor
       
        self.priceLabel.text = "Price: \(self.productDetails.price)"
        self.qualityLabel.text = "Quantity"
        self.sizeLabel.isHidden = isPrintful
        self.sizePicker.isHidden = isPrintful
        self.sizeLabel.text = (self.productDetails.options.count > 0) ? self.productDetails.options[0].name : ""
        self.sizePicker.dataSource = self
        self.sizePicker.pickerDelegate = self
        self.sizePicker.currentIndexSelected = 0
        self.sizePicker.type = .strings
        self.sizePicker.layer.cornerRadius = 3
        self.sizePicker.layer.borderColor = ThemeColor.subHeadingColor.cgColor
        self.sizePicker.layer.borderWidth = 1.0
        self.sizePicker.clipsToBounds = true
        self.sizePicker.backgroundColor = ThemeColor.backgroundColor
        self.sizePicker.textColor = ThemeColor.subHeadingColor
        self.sizePicker.font = UIFont.montserratMedium
        self.sizePicker.setRightViewFAIcon(icon: .FAAngleDown, textColor: ThemeColor.subHeadingColor)
        self.sizePicker.textAlignment = .center
        self.sizePicker.text = (self.productDetails.options.count > 0) ? self.productDetails.options[0].options[0] : ""
        self.sizeLabel.textColor = ThemeColor.subHeadingColor
        self.sizeLabel.font = UIFont.montserratMedium
        
        self.qualityLabel.textColor = ThemeColor.subHeadingColor
        self.qualityLabel.font = UIFont.montserratMedium
        
        self.valueStepper.valueLabel.font = .montserratRegular
        self.valueStepper.tintColor = ThemeColor.subHeadingColor
        self.valueStepper.minimumValue = 1
        self.valueStepper.layer.borderWidth = 1.0
        self.valueStepper.layer.borderColor = ThemeColor.subHeadingColor.cgColor
        self.valueStepper.layer.cornerRadius = 2
        self.valueStepper.clipsToBounds = true
        self.valueStepper.addTarget(self, action: #selector(self.quantityValueChanged), for: .valueChanged)
        
    }

    @objc func quantityValueChanged(){
        print(self.valueStepper.value)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProductDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDetails?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductBannersCollectionViewCell", for: indexPath) as! ProductBannersCollectionViewCell
        cell.bannerImage = self.productDetails.images[indexPath.item].popup
        cell.productBannerImageView.contentMode = .scaleAspectFit
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width * (9/16)))
    }
}


extension ProductDetailsViewController: APJTextPickerViewDataSource, APJTextPickerViewDelegate{
    func numberOfRows(in pickerView: APJTextPickerView) -> Int {
        return (self.productDetails.options.count > 0) ? self.productDetails.options[0].options.count : 0
    }
    func textPickerView(_ textPickerView: APJTextPickerView, titleForRow row: Int) -> String? {
        return self.productDetails.options[0].options[row]
    }
    
    
}
