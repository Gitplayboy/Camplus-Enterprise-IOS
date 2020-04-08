//
//  HomeVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-07.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import Lottie

class HomeVC: UIViewController {
    
    @IBOutlet weak var loadingAnimView: AnimationView!
    var feedsData = [FeedsData]()
    var timer = Timer()
    var blurEffectView:UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stopAnimation), userInfo: nil, repeats: false)
        startAnimation()
        setupNavigationBar()
        // Mock data
        feedsData.append(FeedsData(postTxt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ",postImgName: nil))
        feedsData.append(FeedsData(postTxt: "I am great khali",postImgName: "justin_trudeau"))
        feedsData.append(FeedsData(postTxt: nil ,postImgName: "justin_trudeau"))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedsCell
        cell.postTxtView?.text = feedsData[indexPath.row].postTxt
        if feedsData[indexPath.row].postImgName != nil {
            cell.postImgView?.image = UIImage(named: feedsData[indexPath.row].postImgName!)
        }
        cell.profilePic?.layer.cornerRadius = (cell.profilePic?.layer.bounds.width)! / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var actualsize = CGSize()
        let textview = UITextView()

        textview.text = feedsData[indexPath.row].postTxt
        textview.font = UIFont(name:"Montserrat-Regular",size:14)
        
        
        actualsize = textview.sizeThatFits(CGSize(width: collectionView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        //BOTH IMAGE AND TEXT ARE AVAILABLE
        if feedsData[indexPath.row].postImgName != nil && feedsData[indexPath.row].postTxt != nil{
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 230)
        } else if feedsData[indexPath.row].postImgName == nil && feedsData[indexPath.row].postTxt != nil {
            // Only text available
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 80)
        } else if feedsData[indexPath.row].postImgName != nil && feedsData[indexPath.row].postTxt == nil {
            // Only image is available
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 200)
        } else {
            // Both nil
            return CGSize(width: collectionView.frame.size.width, height: actualsize.height)
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationItem.hidesBackButton = true
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
