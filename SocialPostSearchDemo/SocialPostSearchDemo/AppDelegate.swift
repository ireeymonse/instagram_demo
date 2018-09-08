//
//  AppDelegate.swift
//  SocialPostSearchDemo
//
//  Created by Iree García on 8/20/18.
//  Copyright © 2018 Iree García. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftInstagram

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
   {
      SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.66, green: 0, blue: 0.044, alpha: 1))
      
      // FIXME: remove hardcoded token
      _ = Instagram.shared.storeAccessToken("8550654942.1f59b8b.869ef895713a44f4a926d0da0b50db7c")
      
      return true
   }
}

