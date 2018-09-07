//
//  PostSearchViewController.swift
//  SocialPostSearchDemo
//
//  Created by Iree García on 8/20/18.
//  Copyright © 2018 Iree García. All rights reserved.
//

import UIKit
import SwiftInstagram

class PostSearchViewController: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Login
      let api = Instagram.shared
      
      api.login(from: navigationController!, withScopes: [.basic, .publicContent], success: {
         api.searchMedia(latitude: 19.3848402, longitude: -99.1831457, success: { media in
            print(media)
            
         }, failure: { error in
            print("search: \(error.localizedDescription)")
         })
         
      }, failure: { error in
         print("login: \(error.localizedDescription)")
      })
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
}
