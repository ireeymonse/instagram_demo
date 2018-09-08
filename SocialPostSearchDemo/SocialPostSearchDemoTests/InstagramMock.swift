//
//  InstagramMock.swift
//  SocialPostSearchDemoTests
//
//  Created by Iree García on 9/8/18.
//  Copyright © 2018 Iree García. All rights reserved.
//

import UIKit
@testable import SocialPostSearchDemo
import SwiftInstagram
import CoreLocation

class InstagramMock: InstagramAPI {
   
   var loginEnabled = true
   
   func login(from controller: UINavigationController, withScopes scopes: [InstagramScope], success: Instagram.EmptySuccessHandler?, failure: Instagram.FailureHandler?) {
      isAuthenticated = loginEnabled
      
      if isAuthenticated { success?() }
      else { failure?("mockup login disabled") }
   }
   
   func logout() -> Bool {
      isAuthenticated = false
      return true
   }
   
   private(set) var isAuthenticated: Bool = false
   
   
   // search
   
   struct Response<T: Decodable>: Decodable {
      let data: T?
   }
   
   func mockMedia(from jsonResponse: String) throws {
      guard let data = jsonResponse.data(using: .utf8) else {
         throw "Invalid input"
      }
      let jsonDecoder = JSONDecoder()
      jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
      let object = try jsonDecoder.decode(Response<[InstagramMedia]>.self, from: data)
      media = object.data
   }
   
   var media: [InstagramMedia]?
   
   func searchMedia(coordinates: CLLocationCoordinate2D?, distance: Int?, success: (([InstagramMedia]) -> Void)?, failure: Instagram.FailureHandler?) {
      success?(media ?? [])
   }
   
   func searchLocation(coordinates: CLLocationCoordinate2D?, distance: Int?, facebookPlacesId: String?, success: (([InstagramLocation<String>]) -> Void)?, failure: Instagram.FailureHandler?) {
      success?([])
   }
   
   
   static let response = """
{
  \"data\": [
    {
      \"id\": \"1863331243849303622_8550654942\",
      \"user\": {
        \"id\": \"8550654942\",
        \"full_name\": \"Iree García\",
        \"profile_picture\": \"https://scontent.cdninstagram.com/vp/077f9aa2b47a524dc7737c0e6e89a7d2/5C2B870B/t51.2885-19/s150x150/40272740_1800972063271944_8144752732029321216_n.jpg\",
        \"username\": \"iree.dev\"
      },
      \"images\": {
        \"thumbnail\": {
          \"width\": 150,
          \"height\": 150,
          \"url\": \"https://scontent.cdninstagram.com/vp/188702264e1dfc724284823bfa75a632/5C30DE94/t51.2885-15/e35/s150x150/40655591_726503411050700_7205777429770534912_n.jpg\"
        },
        \"low_resolution\": {
          \"width\": 320,
          \"height\": 320,
          \"url\": \"https://scontent.cdninstagram.com/vp/39a17771e2334869499847ce33f631a9/5C32BE64/t51.2885-15/e35/s320x320/40655591_726503411050700_7205777429770534912_n.jpg\"
        },
        \"standard_resolution\": {
          \"width\": 640,
          \"height\": 640,
          \"url\": \"https://scontent.cdninstagram.com/vp/8b0f9ac124f42e87696b3e31a5ee462c/5C206333/t51.2885-15/sh0.08/e35/s640x640/40655591_726503411050700_7205777429770534912_n.jpg\"
        }
      },
      \"created_time\": \"1536346415\",
      \"caption\": {
        \"id\": \"17950297849176577\",
        \"text\": \"Test\",
        \"created_time\": \"1536346415\",
        \"from\": {
          \"id\": \"8550654942\",
          \"full_name\": \"Iree García\",
          \"profile_picture\": \"https://scontent.cdninstagram.com/vp/077f9aa2b47a524dc7737c0e6e89a7d2/5C2B870B/t51.2885-19/s150x150/40272740_1800972063271944_8144752732029321216_n.jpg\",
          \"username\": \"iree.dev\"
        }
      },
      \"user_has_liked\": false,
      \"likes\": {
        \"count\": 0
      },
      \"tags\": [],
      \"filter\": \"Normal\",
      \"comments\": {
        \"count\": 0
      },
      \"type\": \"image\",
      \"link\": \"https://www.instagram.com/p/Bnb4eTYhkZG/\",
      \"location\": {
        \"latitude\": 19.332484448822,
        \"longitude\": -99.218003524091,
        \"name\": \"Unidad Independencia San Jerónimo\",
        \"id\": 225297574
      },
      \"attribution\": null,
      \"users_in_photo\": []
    },
    {
      \"id\": \"1863308880927747385_8550654942\",
      \"user\": {
        \"id\": \"8550654942\",
        \"full_name\": \"Iree García\",
        \"profile_picture\": \"https://scontent.cdninstagram.com/vp/077f9aa2b47a524dc7737c0e6e89a7d2/5C2B870B/t51.2885-19/s150x150/40272740_1800972063271944_8144752732029321216_n.jpg\",
        \"username\": \"iree.dev\"
      },
      \"images\": {
        \"thumbnail\": {
          \"width\": 150,
          \"height\": 150,
          \"url\": \"https://scontent.cdninstagram.com/vp/d854476393af3bcdaeaa443049536c1c/5C37D988/t51.2885-15/e35/s150x150/40360547_505980796531803_4354534824493449216_n.jpg\"
        },
        \"low_resolution\": {
          \"width\": 320,
          \"height\": 320,
          \"url\": \"https://scontent.cdninstagram.com/vp/f78f6743371435276d028077e4d7b679/5C2AE978/t51.2885-15/e35/s320x320/40360547_505980796531803_4354534824493449216_n.jpg\"
        },
        \"standard_resolution\": {
          \"width\": 640,
          \"height\": 640,
          \"url\": \"https://scontent.cdninstagram.com/vp/5cdd1dc0aabc66151afde2dab6e6f9b6/5C35262F/t51.2885-15/sh0.08/e35/s640x640/40360547_505980796531803_4354534824493449216_n.jpg\"
        }
      },
      \"created_time\": \"1536343749\",
      \"caption\": null,
      \"user_has_liked\": false,
      \"likes\": {
        \"count\": 0
      },
      \"tags\": [],
      \"filter\": \"Normal\",
      \"comments\": {
        \"count\": 0
      },
      \"type\": \"image\",
      \"link\": \"https://www.instagram.com/p/BnbzY4Sh205/\",
      \"location\": {
        \"latitude\": 19.332484448822,
        \"longitude\": -99.218003524091,
        \"name\": \"Unidad Independencia San Jerónimo\",
        \"id\": 225297574
      },
      \"attribution\": null,
      \"users_in_photo\": []
    },
    {
      \"id\": \"1862737294559922367_8456895067\",
      \"user\": {
        \"username\": \"ireegarciam\"
      },
      \"images\": {
        \"thumbnail\": {
          \"width\": 150,
          \"height\": 150,
          \"url\": \"https://scontent.cdninstagram.com/vp/60cfed89a822c6f95ea9bca03e35e379/5C3A7113/t51.2885-15/e35/c0.135.1080.1080/s150x150/40015453_104130160508082_2039134310092267386_n.jpg\"
        },
        \"low_resolution\": {
          \"width\": 320,
          \"height\": 400,
          \"url\": \"https://scontent.cdninstagram.com/vp/759d04b0eea030362ccc1ccf50c2bb6f/5C2F15EA/t51.2885-15/e35/p320x320/40015453_104130160508082_2039134310092267386_n.jpg\"
        },
        \"standard_resolution\": {
          \"width\": 640,
          \"height\": 800,
          \"url\": \"https://scontent.cdninstagram.com/vp/d03da9aa444dbc332697c42128c07d9a/5C1DC5BD/t51.2885-15/sh0.08/e35/p640x640/40015453_104130160508082_2039134310092267386_n.jpg\"
        }
      },
      \"created_time\": \"1536275611\",
      \"caption\": {
        \"id\": \"17955967348089273\",
        \"text\": \"Pier 39\",
        \"created_time\": \"1536275611\",
        \"from\": {
          \"username\": \"ireegarciam\"
        }
      },
      \"user_has_liked\": false,
      \"likes\": {
        \"count\": 2
      },
      \"tags\": [],
      \"filter\": \"Normal\",
      \"comments\": {
        \"count\": 0
      },
      \"type\": \"image\",
      \"link\": \"https://www.instagram.com/p/BnZxbNAHci_/\",
      \"location\": {
        \"latitude\": 19.378016704573,
        \"longitude\": -99.178969860077,
        \"name\": \"Parque Hundido\",
        \"id\": 357235
      },
      \"attribution\": null,
      \"users_in_photo\": []
    }
  ],
  \"meta\": {
    \"code\": 200
  }
}
"""
   
}
