//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import Foundation
import UIKit

let appDel = (UIApplication.shared.delegate as! AppDelegate)

let context = appDel.managedObjectContext

//let context = appDel.persistentContainer.viewContext

let kAppName = "AppName"

let kGooglePlacesAPIKey = "AIzaSyAbno8-kdekUIEM5TEbWa3W01z9NNuxagQ"
//------------------------------------------------------------------


let kNavLoginVCIdentifier = "NavLogin"
let kLoginVCIdentifier = "LoginVC"
let kRegistrationVCIdentifier = "RegistrationVC"

let kTabHomeIdentifier = "TabHome"
let kNavHomeVCIdentifier = "NavHome"
let kHomeVCIdentifier = "HomeVC"

let ksegueTabVC = "segFromHomeScreen"

//------------------------------------------------------------------

let kColorWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let kColorRoyalBlue = #colorLiteral(red: 0.004204546567, green: 0.1372685432, blue: 0.400207907, alpha: 1)
let kColorOrange = #colorLiteral(red: 0.9411764706, green: 0.3568627451, blue: 0.1607843137, alpha: 1)

//------------------------------------------------------------------

enum ActionDescriptor {
    case edit, del
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .edit: return "Edit"
        case .del: return "Delete"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .edit: name = "Edit"
        case .del: name = "Delete"
        }
        
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .edit: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        case .del: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    }
}

enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

extension UISearchBar {
    public func setSerchTextcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
}

extension String {
    var isNumeric: Bool {
        let range = self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted)
        return (range == nil)
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
        //arrSavedCards = try context.fetch(SavedCards.fetchRequest())
    } catch {
        print("Fetching Failed")
    }
}


extension UIView {
    
    // This function will add constraints to views from String format
    func addConstraintsWithFormat(strFormat: String, views:UIView...) {
        var dictViews = [String:UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            dictViews[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: strFormat, options: NSLayoutFormatOptions(), metrics: nil, views: dictViews))
    }
    
    func addAnchor(top : NSLayoutYAxisAnchor? = nil ,leading: NSLayoutXAxisAnchor? = nil,bottom : NSLayoutYAxisAnchor? = nil ,trailing: NSLayoutXAxisAnchor? = nil) {
        
        addAnchorWithConstants(top: top, leading: leading, bottom: bottom, trailing: trailing, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0)
    }
    
    func addAnchorWithConstants(top : NSLayoutYAxisAnchor? = nil ,leading: NSLayoutXAxisAnchor? = nil,bottom : NSLayoutYAxisAnchor? = nil ,trailing: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leadingConstant: CGFloat = 0,bottomConstant: CGFloat = 0, trailingConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
            //leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: trailingConstant).isActive = true
            //rightAnchor.constraint(equalTo: right, constant: rightConstant).isActive = true
        }
    }
    
}

func localToUTC(date:String) -> String {
    let dateFormator = DateFormatter()
    dateFormator.dateFormat = "dd-MMM-yyyy HH:mm"
    dateFormator.calendar = NSCalendar.current
    dateFormator.timeZone = TimeZone.current
    
    let dt = dateFormator.date(from: date)
    dateFormator.timeZone = TimeZone(abbreviation: "UTC")
    dateFormator.dateFormat = "dd-MMM-yyyy HH:mm"
    
    return dateFormator.string(from: dt!)
}

func UTCToLocal(date:String) -> String {
    let dateFormator = DateFormatter()
    dateFormator.dateFormat = "dd-MMM-yyyy HH:mm"
    dateFormator.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormator.date(from: date)
    dateFormator.timeZone = TimeZone.current
    dateFormator.dateFormat = "dd-MMM-yyyy HH:mm"
    
    return dateFormator.string(from: dt!)
}


// This function will replace null value with empty string from dictionary.
func getValueFrmDict(dictReplace : [String: AnyObject], key: String ) -> String {
    guard let value = dictReplace[key] else {
        return ""
    }
    if value is NSNull {
        return ""
    }
    return "\(value)"
}

// This function will replace null value with empty string from UserDefaults.
func getDefaultsValueForKey(_ key: String ) -> String {
    guard let value = UserDefaults.standard.object(forKey: "keyDeviceToken") else {
        return ""
    }
    if value is NSNull {
        return ""
    }
    print("key = \(key) , value = \(value)")
    return "\(value)"
}

// This function will replace all the null value with empty string from dictionary.
func replaceNull(dictReplacing : [String: AnyObject]) -> [String: AnyObject] {
    var updatedDict = [String: AnyObject]()
    for key in dictReplacing.keys {
        updatedDict["\(key)"] = getValueFrmDict(dictReplace: dictReplacing, key: "\(key)") as AnyObject?
    }
    return updatedDict
}

func setNavBarTitle() -> UIImageView {
    let titleView = UIImageView(image: UIImage(named: "img_AppName"))
    titleView.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
    titleView.backgroundColor = .clear
    titleView.contentMode = .scaleAspectFit
    return titleView
}

// This function is used to get path of directory of application local storage.
func getDirectoryPath(strName:String, strExtension:String) -> String {
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let dirPath = docDir.first
    let dirFileName : String = (dirPath?.appending("/" + "\(strName).\(strExtension)"))!
    
    print("dirFileName = ",dirFileName)
    
    return dirFileName
}

// This function is used to get path of file from directory of application local storage.
func getDirectoryPath(strName:String, strExtension:String,strDirName:String) -> String {
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let dirPath = docDir.first
    let dirFileName : String = (dirPath?.appending("/\(strDirName)/" + "\(strName).\(strExtension)"))!
    
    print("dirFileName = ",dirFileName)
    
    return dirFileName
}

// This function is used to store image in directory of application local storage.
func storeImgInDocDir(strName:String,strExtension:String,strDirName:String) {
    do {
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dirPath = docDir.first
        let dirFileName : String = (dirPath?.appending("/\(strDirName)/" + "\(strName).\(strExtension)"))!
        
        let dataPath : String = (dirPath?.appending("/\(strDirName)"))!
        
        do {
            if !(FileManager.default.fileExists(atPath: dataPath)) {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            }
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        let pdfData = try Data(contentsOf: URL(string: "https://s-media-cache-ak0.pinimg.com/originals/c3/81/b9/c381b91ada97877fbab4dcfdd4d42f08.jpg")!, options: Data.ReadingOptions.alwaysMapped)
        
        let img = UIImage(data: pdfData)
        let imageData = UIImageJPEGRepresentation(img!, 1)
        FileManager.default.createFile(atPath: dirFileName, contents: imageData, attributes: nil)
        
    } catch {
        
    }
}

// This function is used to store image in directory of application local storage.
func storeSelectedCardImgInDocDir(strName:String,strExtension:String,strDirName:String,imgData: Data) {
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let dirPath = docDir.first
    let dirFileName : String = (dirPath?.appending("/\(strDirName)/" + "\(strName).\(strExtension)"))!
    
    let dataPath : String = (dirPath?.appending("/\(strDirName)"))!
    
    do {
        if !(FileManager.default.fileExists(atPath: dataPath)) {
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        }
    } catch let error as NSError {
        print(error.localizedDescription);
    }
    
    let img = UIImage(data: imgData)
    let imageData = UIImageJPEGRepresentation(img!, 1)
    FileManager.default.createFile(atPath: dirFileName, contents: imageData, attributes: nil)
}

// This function is used to delete directory of application local storage.
func deleteDocDir(strDirName:String) {
    
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let dirPath = docDir.first
    let dataPath : String = (dirPath?.appending("/\(strDirName)"))!
    
    do {
        try FileManager.default.removeItem(atPath: dataPath)
    }catch let error as NSError {
        print(error.localizedDescription);
    }
}

func deleteFromSavedCard(strFileName:String) {
    
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let dirPath = docDir.first
    let dataPath : String = (dirPath?.appending("/AppSavedCards/" + "\(strFileName).jpg"))!
    
    do {
        try FileManager.default.removeItem(atPath: dataPath)
    }catch let error as NSError {
        print(error.localizedDescription);
    }
}

func setDefaults(_ strValue:String,strKey:String) {
    UserDefaults.standard.set(strValue, forKey: strKey)
    UserDefaults.standard.synchronize()
}

func removeDefaults(_ strKey:String) {
    UserDefaults.standard.removeObject(forKey: strKey)
    UserDefaults.standard.synchronize()
}

