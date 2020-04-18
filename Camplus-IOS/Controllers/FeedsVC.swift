//
//  FeedsVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import Lottie

class FeedsVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var userWelcomeLbl: UILabel!
    var feedsData = [FeedsData]()
    let feedsService = FeedsSvcImpl()
    @IBOutlet weak var addPost:UIButton!
    @IBOutlet weak var feedsCollecView: UICollectionView!
    var refresher = UIRefreshControl()
    
    @IBOutlet weak var loadingAnimView: AnimationView!
    var timer = Timer()
    var blurEffectView:UIVisualEffectView?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stopAnimation), userInfo: nil, repeats: false)
        userWelcomeLbl.text = "Welcome \(String(describing: appDelegate.userDetails.userName!))"
        startAnimation()
        setupNavigationBar()
        
        self.feedsCollecView!.alwaysBounceVertical = true
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refreshStream), for: .valueChanged)

        self.feedsCollecView!.refreshControl = refresher
        feedsCollecView!.addSubview(self.feedsCollecView!.refreshControl!)

        // Call service
        feedsService.fetchActiveFeeds(success: { (feedsArr) in
            self.feedsData = feedsArr
            self.feedsCollecView.reloadData()
        }) { (error) in
            print(error)
        }
        addPost.layer.cornerRadius = addPost.frame.size.width/2
        addPost.layer.masksToBounds = true
    }
    
    
    @objc func refreshStream() {
        // Call service
        feedsService.fetchActiveFeeds(success: { (feedsArr) in
            // This code will hide refresh controller
            DispatchQueue.main.async {
                self.feedsCollecView!.refreshControl?.endRefreshing()
            }
            self.feedsData = feedsArr
            self.feedsCollecView.reloadData()
            
        }) { (error) in
            print(error)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedsData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedsDataCell
        cell.postTxtView?.text = feedsData[indexPath.row].postDescription!
        cell.postedDateLbl.text = feedsData[indexPath.row].postTime!
        
        if feedsData[indexPath.row].postImgName != nil {
            feedsService.downloadImages(filename: feedsData[indexPath.row].postImgName!,success: { (imageData) in
                cell.postImgView?.image = imageData
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                if cell.postImgView != nil {
                    cell.postImgView.addGestureRecognizer(gesture)
                }
            }) { (error) in
                print(error)
            }
        } else {
            if cell.postImgView != nil {
                cell.postImgView.removeFromSuperview()
            }
        }
        if feedsData[indexPath.row].postDescription == nil && cell.postTxtView != nil{
            cell.postTxtView.removeFromSuperview()
        }
        cell.postedByLbl.text = "Posted by \(String(describing: feedsData[indexPath.row].postByUser!))"
        cell.postTitle.text = feedsData[indexPath.row].postTitle
        cell.profilePic?.layer.cornerRadius = (cell.profilePic?.layer.bounds.width)! / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var actualsize = CGSize()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedsDataCell
        cell.postTxtView?.text = feedsData[indexPath.row].postDescription
        
        let textview = UITextView()
        
        if feedsData[indexPath.row].postDescription != nil {
            textview.text = feedsData[indexPath.row].postDescription!
            textview.font = UIFont(name:"Proxima Nova Reg",size:16)
            
            if cell.postTxtView != nil {
                actualsize = cell.postTxtView.sizeThatFits(cell.postTxtView.bounds.size)
            }
            
            print("text is \(textview.text!)")
            print("width is \(actualsize.width)")
            print("height is \(actualsize.height)")
        }
        
        //BOTH IMAGE AND TEXT ARE AVAILABLE
        if feedsData[indexPath.row].postImgName != nil && feedsData[indexPath.row].postDescription != nil{
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 250)
        } else if feedsData[indexPath.row].postImgName == nil && feedsData[indexPath.row].postDescription != nil {
            // Only text available
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 80)
        } else if feedsData[indexPath.row].postImgName != nil && feedsData[indexPath.row].postDescription == nil {
            // Only image is available
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 300)
        } else {
            // Both nil
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height)
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
        }, completion: nil)
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if InternetConnectionManager.isConnectedToNetwork() {
            print("connected")
        } else {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            navigationController?.pushViewController(noInternetVC, animated: true)
        }
        self.tabBarController!.navigationItem.rightBarButtonItem?.customView?.isHidden = true
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationItem.hidesBackButton = true
        self.tabBarController!.navigationItem.rightBarButtonItem?.customView?.isHidden = true
    }
    
    func startAnimation() {
        showAnimate()
        loadingAnimView.isHidden = false
        let loadingAnimation = Animation.named("loading")
        loadingAnimView.animation = loadingAnimation
        loadingAnimView.loopMode = LottieLoopMode.loop
        loadingAnimView.play()
        self.view.addSubview(loadingAnimView)
    }
    
    @objc func stopAnimation() {
        loadingAnimView.stop()
        loadingAnimView.isHidden = true
        removeBlurEffectView()
    }
    func showAnimate() {
        makeBlurEffectView()
    }
    func makeBlurEffectView() {
        let effect: UIBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        blurEffectView = UIVisualEffectView(effect: effect)
        blurEffectView!.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        self.view.addSubview(blurEffectView!)
    }
    func removeBlurEffectView() {
        if blurEffectView != nil {
            self.blurEffectView!.removeFromSuperview()
        }
    }
}
