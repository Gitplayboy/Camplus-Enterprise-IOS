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
    var timer = Timer()
    var blurEffectView:UIVisualEffectView?
    
    @IBOutlet weak var moreMenuIcImg: UIImageView!
    @IBOutlet weak var publicForumIcImg: UIImageView!
    @IBOutlet weak var chatIcImg: UIButton!
    @IBOutlet weak var homeIcImg: UIButton!
    @IBOutlet weak var chatContainer: UIView!
    @IBOutlet weak var feedsContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stopAnimation), userInfo: nil, repeats: false)
        startAnimation()
        setupNavigationBar()
        chatContainer.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if InternetConnectionManager.isConnectedToNetwork() {
            print("connected")
        } else {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            navigationController?.pushViewController(noInternetVC, animated: true)
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
    @IBAction func onChatClick(_ sender: UIButton) {
        chatContainer.isHidden = false
        feedsContainer.isHidden = true
        
        chatIcImg.setImage(UIImage(named: "chat-selected"), for: .normal)
        homeIcImg.setImage(UIImage(named: "home-icon"), for: .normal)
    }
    @IBAction func onHomeClick(_ sender: UIButton) {
        chatContainer.isHidden = true
        feedsContainer.isHidden = false
        
        chatIcImg.setImage(UIImage(named: "chat"), for: .normal)
        homeIcImg.setImage(UIImage(named: "home-selected"), for: .normal)
    }
    
}
