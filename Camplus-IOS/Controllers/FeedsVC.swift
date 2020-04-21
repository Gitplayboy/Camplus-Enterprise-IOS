//
//  FeedsVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import Lottie

class FeedsVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var addPostImg: UIImageView!
    @IBOutlet weak var userWelcomeLbl: UILabel!
    var feedsData = [FeedsData]()
    let feedsService = FeedsSvcImpl()
    @IBOutlet weak var addPost:UIButton!
    @IBOutlet weak var feedsCollecView: UITableView!
    var refresher = UIRefreshControl()
    var rowHeights = [CGFloat]()
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
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refreshStream), for: .valueChanged)
        
        self.feedsCollecView!.refreshControl = refresher
        feedsCollecView!.addSubview(self.feedsCollecView!.refreshControl!)
        
        // Call service
        feedsService.fetchActiveFeeds(success: { (feedsArr) in
            self.feedsData = feedsArr
            self.feedsCollecView.reloadData()
        }) { (error) in
            if InternetConnectionManager.isConnectedToNetwork() {
                print("connected")
            } else {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
                self.navigationController?.pushViewController(noInternetVC, animated: true)
            }
        }
        addPost.layer.cornerRadius = addPost.frame.size.width/2
        addPost.layer.masksToBounds = true
        
        //hide the add post button other than admins
        if appDelegate.userDetails.userType == "A" {
            addPost.isHidden = false
            addPostImg.isHidden = false
        } else {
            addPost.isHidden = true
            addPostImg.isHidden = true
        }
        feedsCollecView.rowHeight = UITableView.automaticDimension
        
        //Detault Background clear
        feedsCollecView.backgroundColor = UIColor.clear
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
            if InternetConnectionManager.isConnectedToNetwork() {
                print("connected")
            } else {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
                self.navigationController?.pushViewController(noInternetVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedsDataCell
        cell.postTxtView?.text = feedsData[indexPath.row].postDescription!
        cell.postedDateLbl.text = feedsData[indexPath.row].postTime!
        
        if feedsData[indexPath.row].postImgName != nil {
            feedsService.downloadImages(filename: feedsData[indexPath.row].postImgName!,success: { (imageData) in
                
                DispatchQueue.main.async {
                    if let customCell = tableView.cellForRow(at: indexPath) as? FeedsDataCell {
                        customCell.postImgView!.image = imageData
                        customCell.postImgView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                    }
                }
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                
                if cell.postImgView != nil {
                    cell.postImgView.addGestureRecognizer(gesture)
                }
            }) { (error) in
                print(error)
            }
        } else {
            if cell.postImgView != nil {
                DispatchQueue.main.async {
                    if let customCell = tableView.cellForRow(at: indexPath) as? FeedsDataCell {
                        customCell.postImgView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                    }
                }
            }
        }
        if feedsData[indexPath.row].postDescription == nil && cell.postTxtView != nil {
            cell.postTxtView.bounds.size = CGSize(width: cell.postTxtView.bounds.width, height: 0)
        }
        cell.postedByLbl.text = "Posted by \(String(describing: feedsData[indexPath.row].postByUser!))"
        cell.postTitle.text = feedsData[indexPath.row].postTitle
        cell.profilePic?.layer.cornerRadius = (cell.profilePic?.layer.bounds.width)! / 2
        
        return cell
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
