//
//  Instagram+.swift
//  SocialPostSearchDemo
//
//  Created by Iree García on 9/8/18.
//  Copyright © 2018 Iree García. All rights reserved.
//

import UIKit
import SwiftInstagram
import CoreLocation

protocol InstagramAPI {
   
   func login(
      from controller: UINavigationController,
      withScopes scopes: [InstagramScope],
      success: Instagram.EmptySuccessHandler?,
      failure: Instagram.FailureHandler?)
   
   @discardableResult
   func logout() -> Bool
   
   var isAuthenticated: Bool { get }
   
   
   // MARK: - Media
   
   func searchMedia(
      coordinates: CLLocationCoordinate2D?,
      distance: Int?,
      success: Instagram.SuccessHandler<[InstagramMedia]>?,
      failure: Instagram.FailureHandler?)
   
   
   // MARK: - Location
   
   func searchLocation(
      coordinates: CLLocationCoordinate2D?,
      distance: Int?,
      facebookPlacesId: String?,
      success: Instagram.SuccessHandler<[InstagramLocation<String>]>?,
      failure: Instagram.FailureHandler?)
}

extension Instagram: InstagramAPI {
   
}

// https://api.instagram.com/v1/media/search?access_token=8550654942.1f59b8b.869ef895713a44f4a926d0da0b50db7c&lat=19.357557&lng=-99.181108&distance=1609
