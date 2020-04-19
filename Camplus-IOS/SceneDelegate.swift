//
//  SceneDelegate.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-06.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        var homeViewController:UIViewController?
        let defaults = UserDefaults.standard
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if defaults.string(forKey: "username") != nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.userDetails.userId = defaults.string(forKey: "userId")!
            appDelegate.userDetails.userName = defaults.string(forKey: "username")!
            appDelegate.userDetails.userType = defaults.string(forKey: "userType")!
            appDelegate.userDetails.gender = defaults.string(forKey: "gender")!
            appDelegate.userDetails.firstName = defaults.string(forKey: "firstName")!
            appDelegate.userDetails.lastName = defaults.string(forKey: "lastName")!
            appDelegate.userDetails.emailId = defaults.string(forKey: "email")!
            appDelegate.userDetails.phone = defaults.string(forKey: "phone")!
            appDelegate.userDetails.userPwd = defaults.string(forKey: "userPwd")
            homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "homePageSB")
        } else {
            homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC")
        }
        let navigationController = UINavigationController(rootViewController: homeViewController!)
        self.window!.rootViewController = navigationController
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

