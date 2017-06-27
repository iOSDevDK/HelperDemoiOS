//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import UIKit

class CartVC: UIViewController {

    @IBOutlet weak var tblCartListing : UITableView!
    @IBOutlet weak var lblTotalCost : UILabel!
    var messageLabel: UILabel!
    var iPrice = 0
    var arrCartProducts : [SelectedProducts]  = []
    //var arrCartProducts : [String]  = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Cart"
        
        tblCartListing.rowHeight = UITableViewAutomaticDimension
        tblCartListing.estimatedRowHeight = 65.0
        
        tblCartListing.tableFooterView = UIView(frame: .zero)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()

    }
    
    func getData() {
        do {
            arrCartProducts.removeAll()
            arrCartProducts = try context.fetch(SelectedProducts.fetchRequest())
            
            iPrice = 0
            for idx in 0 ..< arrCartProducts.count {
                //let cartData = arrCartProducts[idx]
                //iPrice += Int(cartData.productPrice)
            }
            DispatchQueue.main.async {
                if self.iPrice == 0 {
                 self.lblTotalCost.text = "Total Price: "
                } else {
                self.lblTotalCost.text = "Total Price: \(self.iPrice)"
                }
                self.tblCartListing.reloadData()
            }
            
        } catch {
            print("Fetching Failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//------------------------------------------------------------------
// MARK: - UITableView DataSource Methods
//------------------------------------------------------------------

//extension CartVC: UITableViewDataSource,UITableViewDelegate {
//    
//    //------------------------------------------------------------------
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        if arrCartProducts.count == 0 {
//            messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
//            messageLabel.text = "No Products found in Cart."
//            messageLabel.textColor = .white
//            messageLabel.backgroundColor = .clear
//            messageLabel.numberOfLines = 0
//            messageLabel.textAlignment = .center
//            messageLabel.sizeToFit()
//            tableView.backgroundView = messageLabel
//            tableView.separatorStyle = .none
//            
//            return 0
//        } else {
//            tableView.backgroundView = nil
//            return 1
//        }
//
//    }
//    
//    //------------------------------------------------------------------
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrCartProducts.count
//    }
//    
//    //------------------------------------------------------------------
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return displayCartData(indexPath, tableView: tableView)
//        
//    }
//    
//    //------------------------------------------------------------------
//    
//    
//    func displayCartData(_ indexPath: IndexPath, tableView:UITableView) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
//        cell.delegate = self
//        let cartData = arrCartProducts[indexPath.item]
//        /*
//        if let name = cartData.productName {
//            cell.lblProductName.text = name
//        }
//        
//        if let price : String = String(cartData.productPrice) {
//            cell.lblProductPrice.text = price
//        }
//        
//        if let vendorDetails = cartData.vendorName,let vendorAddress = cartData.vendorAddress {
//            cell.lblProductVendorDetails.text = "\(vendorDetails) \n \(vendorAddress)"
//        }
//        
//        cell.btnCallVendor.tag = indexPath.row
//        cell.btnCallVendor.setTitle("Call \(cartData.vendorName!)", for: .normal)
//        */
//        cell.btnRemoveFromCart.tag = indexPath.row
//        cell.btnRemoveFromCart.setTitle("Remove from Cart", for: .normal)
//
//        
//        let urlString = cartData.productImgRef
//        if let url = URL(string: urlString!) {
//            cell.imgProduct.contentMode = .scaleAspectFit
//            cell.imgProduct.sd_setImage(with: url) { (image, error, imageCacheType, imageUrl) in
//                if image != nil {
//                    //print("image found")
//                } else {
//                    //print("image not found")
//                }
//            }
//        }
//
//        return cell
//    }
//    
//    //------------------------------------------------------------------
//    
//}

//------------------------------------------------------------------
// MARK: - Product Cell DataSource Methods
//------------------------------------------------------------------
/*
extension CartVC : RemoveProductDelegate {
 
    func removeProductTapped(_ index: Int) {
        let cartData = arrCartProducts[index]

        let alertController = UIAlertController(title: "CueLogicTest", message: "Are you sure you wan't to remove \(cartData.productName!) from cart?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { Void in
            context.delete(cartData)
            appDel.saveContext()
            self.getData()
            self.tblCartListing.reloadData()
        }
        let noAction: UIAlertAction = UIAlertAction(title: "NO", style: .cancel) { action -> Void in
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func callVendorTapped(_ index: Int) {
        let cartData = arrCartProducts[index]
        let strnumber = cartData.contactNumber!
        guard let phoneCallURL:URL = URL(string:"telprompt://\(strnumber)") else {
            return
        }
        
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
}
*/
