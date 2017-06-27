//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//


import UIKit

@objc protocol AddProductDelegate {
    @objc optional func addProductTapped(_ index: Int)
    
}

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductVendorDetails: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!
    var delegate: AddProductDelegate?
        
    
    @IBAction func btnAddProductAction(sender: AnyObject) {
        delegate?.addProductTapped!(sender.tag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnAddToCart.layer.borderWidth = 2
        btnAddToCart.layer.masksToBounds = true
        btnAddToCart.layer.borderColor = UIColor.black.cgColor
    }
    
}
