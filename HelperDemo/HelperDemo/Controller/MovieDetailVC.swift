//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FMDB
import MZDownloadManager

class MovieDetailVC: UIViewController {
    
    var dictSelectedMovie : [String:AnyObject]?
    var arrActorsList = [AnyObject]()
    var arrRelatedMovies = [AnyObject]()
    var dictMoviePaidStatus = [String:AnyObject]()
    
    var isAddedToWatchlist : Bool = false
    
    var messageLabel: UILabel!
    
    @IBOutlet weak var vwScroll : UIScrollView!
    @IBOutlet weak var vwContainer : UIView!
    @IBOutlet weak var vwMovieHeader: UIView!
    @IBOutlet weak var vwBuyMovie: UIView!
    @IBOutlet weak var vwDownloadMovie: UIView!
    @IBOutlet weak var vwCancelDownload: UIView!
    @IBOutlet weak var vwMovieDescription: UIView!
    @IBOutlet weak var vwMovieActors: UIView!
    @IBOutlet weak var vwRelatedMovies: UIView!
    @IBOutlet weak var vwContainerRelatedMovies: UIView!
    @IBOutlet weak var constraintContainerMoviesHeight: NSLayoutConstraint!
    @IBOutlet weak var vwActorsCollection: UICollectionView!
    @IBOutlet weak var vwImgMoviePoster: UIImageView!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblDurationGenre: UILabel!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var lblMovieDescription: UILabel!
    
    var imgFavourite = UIImage()
    var urlMovieDownload = ""
    let myDownloadPath = MZUtility.baseFilePath + "/DownloadedMovies"
    
    lazy var downloadManager: MZDownloadManager = {
        [unowned self] in
        let sessionIdentifer: String = "com.iosDevelopment.MZDownloadManager.BackgroundSession"
        
        var completion = appDel.backgroundSessionCompletionHandler
        
        let downloadmanager = MZDownloadManager(session: sessionIdentifer, delegate: self, completion: completion)
        return downloadmanager
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        debugPrint("custom download path: \(myDownloadPath)")

        vwCancelDownload.isHidden = true
        vwDownloadMovie.isHidden = true
        
        let barBtnCancel =  UIBarButtonItem(image: UIImage(named: "img_Back"), style: .done, target: self, action: #selector(btnBackTapped))
        self.navigationItem.leftBarButtonItem = barBtnCancel

        setUpRightNavBar()
        
        self.navigationItem.title = "ProinBox"
        
        print("dictSelectedMovie! = ", dictSelectedMovie!)
        
        getMoviePaidStatus()
        setUpMovieDetailView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpRightNavBar() {
        if isAddedToWatchlist {
            imgFavourite = #imageLiteral(resourceName: "img_Selected")
        } else {
            imgFavourite = #imageLiteral(resourceName: "img_NotSelected")
        }
        let barBtnWatchList =  UIBarButtonItem(image: imgFavourite, style: .done, target: self, action: #selector(btnWatchListTapped))
        
        let barBtnShare =  UIBarButtonItem(image: UIImage(named: "img_Share"), style: .done, target: self, action: #selector(btnShareTapped))
        self.navigationItem.rightBarButtonItems = [barBtnShare,barBtnWatchList]
    }
}

extension MovieDetailVC {
    
    func setUpMovieDetailView() {
        moviePoster()
        movieDesc()
        movieTitle()
        movieDuration()
        
        if ("\(dictSelectedMovie!["status"]!)" == "Free") {
            vwDownloadMovie.isHidden = false
            vwBuyMovie.isHidden = true
        } else {
            vwDownloadMovie.isHidden = true
            vwBuyMovie.isHidden = false
            btnBuyNow.setTitle("BUY MOVIE FOR \(dictSelectedMovie!["currency"] as! String) \(dictSelectedMovie!["price"] as! String)", for: .normal)
        }
        
        getMovieActors()
        
        getRelatedMovie()
        
    }
    
    func moviePoster() {
        guard let urlPoster = URL(string: (dictSelectedMovie?["cover"] as! String)) else {
            return
        }
        vwImgMoviePoster.sd_setImage(with: urlPoster)
    }
    
    func movieDesc() {
        guard let strDesc : String = (dictSelectedMovie?["description"] as! String?) else {
            lblMovieDescription.text = ""
            return
        }
        do {
            if strDesc.contains("<") {
                lblMovieDescription.text = try strDesc.convertHtmlSymbols()
            } else {
                lblMovieDescription.text = strDesc//try strDesc.convertHtmlSymbols()
            }
        } catch {}
    }
    
    func movieTitle() {
        guard let strTitle : String = (dictSelectedMovie?["title"] as! String?) else {
            lblMovieName.text = ""
            return
        }
        lblMovieName.text = strTitle
    }
    
    func movieDuration() {
        
        guard let strDuration : String = (dictSelectedMovie?["time"] as! String?) else {
            lblDurationGenre.text = ""
            return
        }
        
        lblDurationGenre.text = strDuration
        
        guard let strGenre : String = (dictSelectedMovie?["genre"] as! String?) else {
            return
        }
        lblDurationGenre.text = strDuration + "Min | " + strGenre
    }

    // This function will create view of related movies.
    func setUpRelatedMoviesView() {
        vwContainerRelatedMovies.backgroundColor = .lightGray
        let height = 120
        var dictViews = [String:AnyObject]()
        
        for idx in 0 ..< arrRelatedMovies.count {
            
            let vwRelatedMovie = UIView()
            vwRelatedMovie.backgroundColor = .white
            vwRelatedMovie.translatesAutoresizingMaskIntoConstraints = false
            vwContainerRelatedMovies.addSubview(vwRelatedMovie)
            
            dictViews["vw\(idx)"] = vwRelatedMovie
            
            if idx == 0 {
                vwContainerRelatedMovies.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[vw\(idx)(\(height))]", options: [], metrics: nil, views: dictViews))
                vwContainerRelatedMovies.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[vw\(idx)]-0-|", options: [], metrics: nil, views: dictViews))
            } else {
                vwContainerRelatedMovies.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\((5 * idx) + (height * idx)))-[vw\(idx)(\(height))]", options: [], metrics: nil, views: dictViews))
                vwContainerRelatedMovies.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[vw\(idx)]-0-|", options: [], metrics: nil, views: dictViews))
            }
            setRelatedMovieSubView(vwRelatedMovie, index: idx, height: Float(height))
            
        }
        constraintContainerMoviesHeight.constant = CGFloat((5 * (arrRelatedMovies.count)) + (height * (arrRelatedMovies.count)))
        self.view.layoutIfNeeded()
        
    }
    
    // This function will add related movie item based on index from array.
    func setRelatedMovieSubView(_ vwMovie: UIView,index : Int, height : Float) {
        
        let vwImgRMPoster = UIImageView()
        vwImgRMPoster.backgroundColor = appBgColor
        vwImgRMPoster.translatesAutoresizingMaskIntoConstraints = false
        vwMovie.addSubview(vwImgRMPoster)
        
        let lblRelatedMovieName = UILabel()
        lblRelatedMovieName.backgroundColor = .white
        lblRelatedMovieName.font = UIFont.systemFont(ofSize: 14)
        lblRelatedMovieName.translatesAutoresizingMaskIntoConstraints = false
        vwMovie.addSubview(lblRelatedMovieName)
        
        let lblRelatedMovieGenre = UILabel()
        lblRelatedMovieGenre.backgroundColor = .white
        lblRelatedMovieGenre.textColor = .gray
        lblRelatedMovieGenre.font = UIFont.systemFont(ofSize: 14)
        lblRelatedMovieGenre.translatesAutoresizingMaskIntoConstraints = false
        vwMovie.addSubview(lblRelatedMovieGenre)
        
        let lblRelatedMoviePrice = UILabel()
        lblRelatedMoviePrice.textColor = .red
        lblRelatedMoviePrice.backgroundColor = .white
        lblRelatedMoviePrice.textAlignment = .right
        lblRelatedMoviePrice.font = UIFont.systemFont(ofSize: 12)
        lblRelatedMoviePrice.translatesAutoresizingMaskIntoConstraints = false
        vwMovie.addSubview(lblRelatedMoviePrice)
        
        let dictRelatedMoviesSubViews = ["poster":vwImgRMPoster,"name":lblRelatedMovieName,"genre":lblRelatedMovieGenre,"price":lblRelatedMoviePrice]
        
        vwMovie.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[poster]-4-|", options: [], metrics: nil, views: dictRelatedMoviesSubViews))
        vwMovie.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[poster(\(height * 0.7))]", options: [], metrics: nil, views: dictRelatedMoviesSubViews))
        
        vwMovie.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[name]-6-[genre]", options: [], metrics: nil, views: dictRelatedMoviesSubViews))
        vwMovie.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(height * 0.7 + 8))-[name]-4-|", options: [], metrics: nil, views: dictRelatedMoviesSubViews))
        vwMovie.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(height * 0.7 + 8))-[genre]-4-|", options: [], metrics: nil, views: dictRelatedMoviesSubViews))
        
        vwMovie.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[price]-4-|", options: [], metrics: nil, views: dictRelatedMoviesSubViews))
        vwMovie.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(height * 0.7 + 8))-[price]-4-|", options: [], metrics: nil, views: dictRelatedMoviesSubViews))
        
        let dictRelatedMovieData = self.arrRelatedMovies[index] as! [String:AnyObject]
        
        vwImgRMPoster.sd_setImage(with: URL(string: dictRelatedMovieData["cover"]! as! String))
        
        lblRelatedMovieName.text = "\(dictRelatedMovieData["title"]!)".uppercased()
        lblRelatedMovieGenre.text = "\(dictRelatedMovieData["genre"]!)".capitalized
        
        if ("\(dictRelatedMovieData["status"]!)" == "Free") {
            lblRelatedMoviePrice.text = "free".capitalized
        } else {
            lblRelatedMoviePrice.text = "\(dictRelatedMovieData["currency"]!) \(dictRelatedMovieData["price"]!)".uppercased()
        }
        
        let btnRelatedMovie = UIButton(type: .custom)
        btnRelatedMovie.tag = index
        btnRelatedMovie.backgroundColor = .clear
        btnRelatedMovie.translatesAutoresizingMaskIntoConstraints = false
        btnRelatedMovie.addTarget(self, action: #selector(btnRelatedMovieTapped(sender:)), for: .touchUpInside)
        vwMovie.addSubview(btnRelatedMovie)
        
        
        let dictBtnRelatedMovies = ["btnMovie":btnRelatedMovie]
        
        vwMovie.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[btnMovie]-0-|", options: [], metrics: nil, views: dictBtnRelatedMovies))
        vwMovie.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[btnMovie]-0-|", options: [], metrics: nil, views: dictBtnRelatedMovies))
    }
    
}

//------------------------------------------------------------------
// MARK: - Action Methods
//------------------------------------------------------------------

extension MovieDetailVC {

    func btnBackTapped() {
        //self.navigationController!.popViewController(animated: true)
        self.navigationController!.popToRootViewController(animated: true)
    }

    func btnWatchListTapped() {
        if isAddedToWatchlist {
            deleteFavoriteMovie(withID: movieDetail(strKey: "id"))
        } else {
            storeMovieToFavorite()
        }
        setUpRightNavBar()
    }
    
    func btnShareTapped() {
        let activityViewController = UIActivityViewController(activityItems: ["PROCINBOX"], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.excludedActivityTypes = [ .airDrop,.addToReadingList,.assignToContact,.copyToPasteboard,.message,.postToFlickr,.saveToCameraRoll,.postToWeibo,.postToVimeo,.postToTwitter,.postToTencentWeibo,.openInIBooks]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func btnRelatedMovieTapped(sender:AnyObject) {
        let objMovieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        
        let dictMovieData = arrRelatedMovies[sender.tag] as! [String:AnyObject]
        
        objMovieDetailVC.dictSelectedMovie = dictMovieData
        
        self.navigationController?.pushViewController(objMovieDetailVC, animated: true)
    }

    func storeMovieToFavorite() {
        let dirPaths =  NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0]
        let destPath = (docsDir as NSString).appendingPathComponent(DataName)
        
        db = FMDatabase(path: destPath)
        
        let query = "insert into \(tblFavourite) (id,title,time,description,number,cover,full_cover,genre,status,trailer,price,currency) values ('\(Int(movieDetail(strKey: "id"))!)',\"\(movieDetail(strKey: "title"))\",'\(movieDetail(strKey: "time"))',\"\(movieDetail(strKey: "description"))\",'\(movieDetail(strKey: "number"))','\(movieDetail(strKey: "cover"))','\(movieDetail(strKey: "full_cover"))','\(movieDetail(strKey: "genre"))','\(movieDetail(strKey: "status"))','\(movieDetail(strKey: "trailer"))','\(movieDetail(strKey: "price"))','\(movieDetail(strKey: "currency"))')"
        

        print("query \(query)")
        
        if db.open() {
            if !db.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(db.lastError(), db.lastErrorMessage())
                db.close()
            } else {
                self.isAddedToWatchlist = true
                db.close()
            }
        }
    }
    
    func movieDetail(strKey: String) -> String {
        
        var movieValue = ""
        if dictSelectedMovie?[strKey] is String {
            movieValue = dictSelectedMovie?[strKey]! as! String
        } else {
            movieValue = "\(dictSelectedMovie?[strKey]! as! Int)"
        }
        
        guard let strDesc : String = movieValue else {
             return ""
        }
        return strDesc
    }
    
    func deleteFavoriteMovie(withID ID: String) {
        
        if db.open() {
            let query = "delete from \(tblFavourite) where id = '\(ID)'"
            
            do {
                try db.executeUpdate(query, values: [ID])
                self.isAddedToWatchlist = false
            } catch {
                print(error.localizedDescription)
            }
            
            db.close()
        }
    }
}

//------------------------------------------------------------------
// MARK: - IBAction Methods
//------------------------------------------------------------------

extension MovieDetailVC {
    
    
    @IBAction func btnWatchTrailerTapped() {
        let videoURL = NSURL(string: "\(dictSelectedMovie!["trailer"]!)")
        let player = AVPlayer(url: videoURL! as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func btnDownloadTapped() {

         let fileURL  : NSString = urlMovieDownload as NSString
         var fileName : NSString = fileURL.lastPathComponent as NSString
         fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(fileName as String) as NSString)
        
         downloadManager.addDownloadTask(fileName as String, fileURL: fileURL as String, destinationPath: myDownloadPath)
        
        
    }
    
    func downloadMovie(filePath :String) {
        
        let dirPaths =  NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0]
        let destPath = (docsDir as NSString).appendingPathComponent(DataName)
        
        db = FMDatabase(path: destPath)
        
        let query = "insert into \(tblDownloadMovie) (id,client_id,title,file,download_id,status) values ('\(Int(movieDetail(strKey: "id"))!)','\(Int(movieDetail(strKey: "id"))!)','\(filePath)',,\"\(movieDetail(strKey: "title"))\"'\(movieDetail(strKey: "price"))','\(movieDetail(strKey: "currency"))')"
        
        
        print("query \(query)")
        
        if db.open() {
            if !db.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(db.lastError(), db.lastErrorMessage())
                db.close()
            } else {
                self.isAddedToWatchlist = true
                db.close()
            }
        }
    }

    
    @IBAction func btnCancelDownloadingTapped() {
        
    }
    
    @IBAction func btnStreamTapped() {
        
        let videoURL = NSURL(string: "\(self.dictMoviePaidStatus["fav_url"]!)")
        let player = AVPlayer(url: videoURL! as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func btnBuyTapped() {
        let objPaymentOptionsVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentOptionsVC") as! PaymentOptionsVC
        objPaymentOptionsVC.mPrice = "\(dictSelectedMovie!["currency"] as! String) \(dictSelectedMovie!["price"] as! String)"
        objPaymentOptionsVC.dictSelectedMovie = dictSelectedMovie!
        self.navigationController?.pushViewController(objPaymentOptionsVC, animated: true)
    }
    
    }

//------------------------------------------------------------------
// MARK: - UICollectionView DataSource Methods
//------------------------------------------------------------------

extension MovieDetailVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if arrActorsList.count > 0 {
            collectionView.backgroundView = nil
            return 1
        } else {
            messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            messageLabel.text = "No Actors Found."
            messageLabel.textColor = .gray
            messageLabel.backgroundColor = .clear
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.sizeToFit()
            collectionView.backgroundView = messageLabel
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrActorsList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCell", for: indexPath) as! ActorCell
        
        let dictActorsData = arrActorsList[indexPath.item] as! [String:AnyObject]
        //print("dictActorsData = ", dictActorsData)
        
        cell.vwImgActor.sd_setImage(with: URL(string: "\(dictActorsData["photo"]!)"))
        cell.lblActorName.text = "\(dictActorsData["name"]!)".capitalized
        
        return cell
    }
}

//------------------------------------------------------------------
// MARK: - UIColletionView Delegate Methods
//------------------------------------------------------------------


extension MovieDetailVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ((UIScreen.main.bounds.size.width-25)/3.0 + 25)
        let height = vwActorsCollection.frame.size.height
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected Index :: ",arrActorsList[indexPath.item])
        let objActorDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ActorDetailVC") as! ActorDetailVC
        
        let dictActorData = arrActorsList[indexPath.item] as! [String:AnyObject]
        objActorDetailVC.dictSelectedActor = dictActorData
        
        self.navigationController?.pushViewController(objActorDetailVC, animated: true)

    }
    
}

//------------------------------------------------------------------
// MARK: - WebService Methods
//------------------------------------------------------------------

extension MovieDetailVC {
    
    // This function will call web service to get list of actor who have worked in movie.
    func getMovieActors() {
        
        var movieID = ""
        if dictSelectedMovie?["id"] is String {
            movieID = dictSelectedMovie?["id"]! as! String
        } else {
            movieID = "\(dictSelectedMovie?["id"]! as! Int)"
        }
        
        guard let strMovieID : String = movieID else {
            return
        }
        
       /* guard let strMovieID : String = (dictSelectedMovie?["id"] as! String?) else {
            return
        }*/
        
        appDel.showProgress()
        WebService.callWebService(strAPI: "", methodType: .get, requestParams: [:], successCompletionHandler: { (dictResponse) in
            self.arrActorsList.removeAll()
            if (dictResponse["status"] as! String) == "success" {
                self.arrActorsList = dictResponse["actors"] as! [AnyObject]
            }
            DispatchQueue.main.async {
                appDel.hideProgress()
                self.vwActorsCollection.reloadData()
            }
        }, messageCallBackHandler: { (dictResponse) in
            //print(dictResponse)
            DispatchQueue.main.async {
                appDel.hideProgress()
            }
        }) { (error) in
            print(error)
            DispatchQueue.main.async {
                appDel.hideProgress()
            }
        }
    }
        
    // This function will call web service to get pais status of selected movie.
    func getMoviePaidStatus() {
        var movieID = ""
        if dictSelectedMovie?["id"] is String {
            movieID = dictSelectedMovie?["id"]! as! String
        } else {
            movieID = "\(dictSelectedMovie?["id"]! as! Int)"
        }
        
        guard let strMovieID : String = movieID else {
            return
        }
        
        appDel.showProgress()
        
        //UserDefaults.standard.set(dictUserData, forKey: "loggedInUserdata")
        
        let dictUserData = UserDefaults.standard.object(forKey: "loggedInUserdata") as! [String:AnyObject]
        print("dictUserData = ",dictUserData)
        let strUserId : String = UserDefaults.standard.object(forKey: "user_Id") as! String
        print("strUserId = ",strUserId)
        
        WebService.callWebService(strAPI: "", methodType: .get, requestParams: [:], successCompletionHandler: { (dictResponse) in

//        WebService.callWebService(strAPI: "movie/paid_status/?api_key=08111987RWN&id=\(strMovieID)&clientId=15", methodType: .get, requestParams: [:], successCompletionHandler: { (dictResponse) in
            self.dictMoviePaidStatus = (dictResponse["paid_status_api"] as! [AnyObject])[0] as! [String:AnyObject]
            self.urlMovieDownload = self.dictMoviePaidStatus["movie_url"]! as! String
            //print("self.dictMoviePaidStatus = ", self.dictMoviePaidStatus["movie_url"]! as! String)
            DispatchQueue.main.async {
                appDel.hideProgress()
                
            }
        }, messageCallBackHandler: { (dictResponse) in
            print(dictResponse)
            DispatchQueue.main.async {
                appDel.hideProgress()
            }
        }) { (error) in
            print(error)
            DispatchQueue.main.async {
                appDel.hideProgress()
            }
        }
        
    }

    
}

extension MovieDetailVC: MZDownloadManagerDelegate {
    
    func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [MZDownloadModel]) {
    }
    
    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
    }
    
    func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
    }
    
    func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
    }
    
    func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {
        
    }
    
    func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
        
        downloadManager.presentNotificationForDownload("Ok", notifBody: "Download did completed")
        
        let docDirectoryPath : NSString = (MZUtility.baseFilePath as NSString).appendingPathComponent(downloadModel.fileName) as NSString
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MZUtility.DownloadCompletedNotif as String), object: docDirectoryPath)
    }
    
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
        
        debugPrint("Error while downloading file: \(downloadModel.fileName)  Error: \(error)")
    }
    
    //Oppotunity to handle destination does not exists error
    //This delegate will be called on the session queue so handle it appropriately
    func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        let fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(downloadModel.fileName as String) as NSString)
        let path =  myDownloadPath + "/" + (fileName as String)
        try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
        debugPrint("Default folder path: \(myDownloadPath)")
    }
}

