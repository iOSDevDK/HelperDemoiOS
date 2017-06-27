//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "CardCell"

class CardsListingVC: UICollectionViewController {
    
    var arrSavedCards: [SavedCards] = []
    //var arrSavedCards: [String] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = setNavBarTitle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deleteDocDir(strDirName: "FrontCard")
        deleteDocDir(strDirName: "BackCard")
        
        removeDefaultsData()
        
        getData()
        
    }
    
    func removeDefaultsData() {
        let arrRemKeys = ["fName","lName"]
        for key in arrRemKeys {
            if UserDefaults.standard.object(forKey: key) != nil {
                removeDefaults(key)
            }
        }
    }
    
    // This function will list out all the font added and supported in application.
    func checkFonts() {
        for familyName in UIFont.familyNames as [String] {
            print("\(familyName)")
            for fontName in UIFont.fontNames(forFamilyName: familyName) as [String] {
                print("\tFont: \(fontName)")
            }
        }
    }
    
    // This function will get data of all the cards saved in 'CoreData'.
    func getData() {
        do {
            arrSavedCards = try context.fetch(SavedCards.fetchRequest())
            print("arrSavedCards = ",arrSavedCards)
            print("arrSavedCards COUNT = ",arrSavedCards.count)
            collectionView?.reloadData()
        } catch {
            print("Fetching Failed")
        }
    }
    
}

//------------------------------------------------------------------
// MARK: - UICollectionView DataSource Methods
//------------------------------------------------------------------
/*
extension CardsListingVC {
    
    //------------------------------------------------------------------
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if arrSavedCards.count > 0 {
            return 2
        } else {
            return 2
        }
    }
    
    //------------------------------------------------------------------
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return kArrCards.count
        } else {
            if arrSavedCards.count > 0 {
                return arrSavedCards.count
            } else {
                return 0
            }
        }
    }
    
    //------------------------------------------------------------------
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
            
            let card = kArrCards[indexPath.item]
            cardCell.cardData = card
            
            return cardCell
        } else {
            let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
            cardCell.imgVwCard.backgroundColor = UIColor.gray
            
            let selectedCard : SavedCards = (self.arrSavedCards[indexPath.item])
            let arrTempImgs = Array(selectedCard.frontImgPath!.components(separatedBy: ","))
            print(arrTempImgs)
            let strImgPath = getDirectoryPath(strName: "\(arrTempImgs[0])", strExtension: "jpg", strDirName: "AppSavedCards")
            cardCell.imgVwCard.image = UIImage(contentsOfFile: strImgPath)!
            
            return cardCell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TemplateHeaderView", for: indexPath) as! TemplateHeaderView
        
        if indexPath.section == 1 {
            headerView.title.text = "My Saved Cards"
        } else if indexPath.section == 0 {
            headerView.title.text = "Templates"
        }
        return headerView
        
    }
    
}
*/
//------------------------------------------------------------------
// MARK: - UIColletionView Delegate Methods
//------------------------------------------------------------------
/*
extension CardsListingVC : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.size.width-25)/3.0
        let height = ((UIScreen.main.bounds.size.width-25)/3.0 * 1.5)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    //------------------------------------------------------------------
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("selected Index :: ",kArrCards[indexPath.item])
            let selectedCardVCOBJ = self.storyboard?.instantiateViewController(withIdentifier: "SelectedCardVC") as! SelectedCardVC
            selectedCardVCOBJ.selCardData = kArrCards[indexPath.item]
            self.navigationController?.pushViewController(selectedCardVCOBJ, animated: true)
        } else {
            displaySavedCardAlert(indexPath: indexPath)
        }
    }
    
    //------------------------------------------------------------------
    
    // This function will open or delete saved card in 'CoreData'.
    func displaySavedCardAlert(indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "ChampCards", message: "Would you like to", preferredStyle: .alert)
        let openAction = UIAlertAction(title: "OPEN", style: .default, handler: { (UIAlertAction) in
            let selectedCard : SavedCards = (self.arrSavedCards[indexPath.item])
            
            let arrTempImgs = Array(selectedCard.frontImgPath!.components(separatedBy: ","))
            print(arrTempImgs)
            
            
            let strImgPath = getDirectoryPath(strName: (selectedCard.imgPath! as String), strExtension: "jpg", strDirName: "AppSavedCards")
            var strImgName = "img_BGPlaceholder"
            if FileManager.default.fileExists(atPath: strImgPath) {
                let capturedImageFront = UIImage(contentsOfFile: strImgPath)!
                let imgOriginalFrontData = UIImageJPEGRepresentation(capturedImageFront, 1)
                storeSelectedCardImgInDocDir(strName: "selFrontCard", strExtension: "jpg", strDirName: "FrontCard", imgData: imgOriginalFrontData!)
                strImgName = "selFrontCard"
            } else {
                strImgName = "img_BGPlaceholder"
            }
            
            var strFirstName = "PLAYER"
            var strLastName = "NAME"
            
            var cardColor : UIColor = .clear
            if selectedCard.borderColor == "clear" {
                cardColor = .clear
            } else if selectedCard.borderColor == "green" {
                cardColor = UIColor(r: 17, g: 109, b: 31) //.green
            } else if selectedCard.borderColor == "blue" {
                cardColor = .blue
            } else if selectedCard.borderColor == "purple" {
                cardColor = UIColor(r: 124, g: 42, b: 192)
            } else {
                cardColor = UIColor(r: 191, g: 18, b: 68)
            }
            
            var cFront = CardFront(Name: strFirstName, LastName: strLastName, TeamName: selectedCard.teamname!, imgPath: strImgName, logoPath: "", year: "2017",borderColor: cardColor)
            
            if selectedCard.playername!.contains("_") {
                let fullNameArr = selectedCard.playername!.components(separatedBy: "_")
                let name    = fullNameArr[0]
                let surname = fullNameArr[1]
                strFirstName = name
                strLastName = surname
                
                cFront = CardFront(Name: strFirstName, LastName: strLastName, TeamName: selectedCard.teamname!, imgPath: strImgName, logoPath: "", year: "2017",borderColor: cardColor)
            } else {
                cFront = CardFront(Name: selectedCard.playername!, LastName: strLastName, TeamName: selectedCard.teamname!, imgPath: strImgName, logoPath: "", year: "2017",borderColor: cardColor)
            }
            
            print("selectedCard.backCardData! == ",selectedCard.backCardData!)
            print("selectedCard.backCardData! == ",selectedCard.backCardType!)
            
            let dictBackData = selectedCard.backCardData! as! [String:String]
            
            var isBackDataEditted : Bool = false
            
            if dictBackData["Number"]! != "Number" {
                isBackDataEditted = true
                setDefaults("true", strKey: "isBackEdited")
            }
            
            print("selectedCard.frontCardType! == ",selectedCard.frontCardType!)
            
            var cBack1 = CardBack(backCardType: .bCard1,isBackEdited: isBackDataEditted,backData : backDataFirst)
            if selectedCard.backCardType! == "bCard1" {
                cBack1 = CardBack(backCardType: .bCard1,isBackEdited: isBackDataEditted,backData : selectedCard.backCardData! as! [String : String])
            } else if selectedCard.backCardType! == "bCard2" {
                cBack1 = CardBack(backCardType: .bCard2,isBackEdited: isBackDataEditted,backData : selectedCard.backCardData! as! [String : String])
            } else {
                cBack1 = CardBack(backCardType: .bCard3,isBackEdited: isBackDataEditted,backData : selectedCard.backCardData! as! [String : String])
            }
            
            
            var firstCard = CardData(imgBgName: "Card1", screen: .Front, front: cFront, back: cBack1, type: .Card1)
            if selectedCard.frontCardType == "Card1" {
                firstCard = CardData(imgBgName: "Card1", screen: .Front, front: cFront, back: cBack1, type: .Card1)
            } else if selectedCard.frontCardType == "Card2" {
                firstCard = CardData(imgBgName: "Card2", screen: .Front, front: cFront, back: cBack1, type: .Card2)
            } else {
                firstCard = CardData(imgBgName: "Card3", screen: .Front, front: cFront, back: cBack1, type: .Card3)
            }
            
            let selectedCardVCOBJ = self.storyboard?.instantiateViewController(withIdentifier: "SelectedCardVC") as! SelectedCardVC
            selectedCardVCOBJ.selCardData = firstCard
            self.navigationController?.pushViewController(selectedCardVCOBJ, animated: true)
            
        })
        let deleteAction = UIAlertAction(title: "DELETE", style: .default, handler: { (UIAlertAction) in
            let selectedCard : SavedCards = (self.arrSavedCards[indexPath.item])
            
            
            deleteFromSavedCard(strFileName: selectedCard.imgPath! as String)
            
            let arrTempImgs = Array(selectedCard.frontImgPath!.components(separatedBy: ","))
            print(arrTempImgs)
            deleteFromSavedCard(strFileName: "\(arrTempImgs[0])")
            deleteFromSavedCard(strFileName: "\(arrTempImgs[1])")
            
            context.delete(self.arrSavedCards[indexPath.item])
            appDel.saveContext()
            self.getData()
            self.collectionView?.reloadData()
        })
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: { (UIAlertAction) in
            
        })
        
        alertController.addAction(openAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
 */
