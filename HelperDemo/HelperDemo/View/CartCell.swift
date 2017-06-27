//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import UIKit

@objc protocol RemoveProductDelegate {
    @objc optional func removeProductTapped(_ index: Int)

    @objc optional func callVendorTapped(_ index: Int)
}

class CartCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductVendorDetails: UILabel!
    @IBOutlet weak var btnRemoveFromCart: UIButton!
    @IBOutlet weak var btnCallVendor: UIButton!
    var delegate: RemoveProductDelegate?
    
    
    @IBAction func btnRemoveProductAction(sender: AnyObject) {
        delegate?.removeProductTapped!(sender.tag)
        
    }

    @IBAction func btnCallVendorAction(sender: AnyObject) {
        delegate?.callVendorTapped!(sender.tag)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnCallVendor.layer.borderWidth = 2
        btnCallVendor.layer.cornerRadius = 5
        btnCallVendor.layer.masksToBounds = true
        btnCallVendor.layer.borderColor = UIColor.black.cgColor
        
        btnRemoveFromCart.layer.borderWidth = 2
        btnRemoveFromCart.layer.cornerRadius = 5
        btnRemoveFromCart.layer.masksToBounds = true
        btnRemoveFromCart.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
