//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import UIKit

class ProductsVC: UIViewController {

    var arrProducts = [AnyObject]()
    
    @IBOutlet weak var vwProductCollection: UICollectionView!
    
    //------------------------------------------------------------------
    // MARK: - UIView Life Cycle Methods
    //------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Shop"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------------------
    // MARK: - Memory Management Methods
    //------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//------------------------------------------------------------------
// MARK: - UICollectionView DataSource Methods
//------------------------------------------------------------------

extension ProductsVC: UICollectionViewDataSource {
    
    //------------------------------------------------------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    //------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let dictProductData = arrProducts[indexPath.item] as? [String:AnyObject]
        
        cell.delegate = self
        cell.btnAddToCart.tag = indexPath.row
        cell.btnAddToCart.setTitle("Add to Cart", for: .normal)
        cell.lblProductPrice.text = "\(dictProductData!["price"]!)"
        cell.lblProductName.text = "\(dictProductData!["productname"]!)"
        cell.lblProductVendorDetails.text = "\(dictProductData!["vendorname"]!) \n \(dictProductData!["vendoraddress"]!)"
        
        let urlString = dictProductData!["productImg"]!
        if let url = URL(string: urlString as! String) {
            cell.imgProduct.contentMode = .scaleAspectFit
            cell.imgProduct.sd_setImage(with: url) { (image, error, imageCacheType, imageUrl) in
                if image != nil {
                    //print("image found")
                } else {
                    //print("image not found")
                }
            }
        }
        return cell
    }
    
}

//------------------------------------------------------------------
// MARK: - UICollectionView DataSource Methods
//------------------------------------------------------------------

extension ProductsVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width-25)/2.0
        let height = CGFloat(245)
        //((UIScreen.main.bounds.size.width-15)/2.0 * 1.5)
        
        return CGSize(width: width, height: height)
    }

}

//------------------------------------------------------------------
// MARK: - Product Cell DataSource Methods
//------------------------------------------------------------------

extension ProductsVC : AddProductDelegate {
    
    func addProductTapped(_ index: Int) {
        print(arrProducts[index] as! [String:AnyObject])
        guard let dictProduct = arrProducts[index] as? [String:AnyObject] else {
            return
        }
        
        let strProductName = (dictProduct["productname"] as? String)!
        let alertController = UIAlertController(title: "CueLogicTest", message: "Do you sure you want to add \(strProductName) to cart?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { Void in
            /*
            if #available(iOS 10.0, *) {
                let productDetails = SelectedProducts(context: context)
                productDetails.productName = strProductName
                productDetails.productPrice = Int32((dictProduct["price"] as? String)!)!
                productDetails.productImgRef = (dictProduct["productImg"] as? String)!
                
                productDetails.vendorName = (dictProduct["vendorname"] as? String)!
                productDetails.vendorAddress = (dictProduct["vendoraddress"] as? String)!
                
                productDetails.contactNumber = (dictProduct["phoneNumber"] as? String)!
                
                appDel.saveContext()

            } else {
                // Fallback on earlier versions
            }*/
        }
        let noAction: UIAlertAction = UIAlertAction(title: "NO", style: .cancel) { action -> Void in
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }

}
