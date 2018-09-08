//
//  PostDetailsViewController.swift
//  SocialPostSearchDemo
//
//  Created by Iree García on 9/7/18.
//  Copyright © 2018 Iree García. All rights reserved.
//

import UIKit
import SwiftInstagram
import SVProgressHUD

class PostDetailsViewController: UIViewController {
   
   @IBOutlet weak var userPictureView: UIImageView!
   @IBOutlet weak var userLabel: UILabel!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var imageView: UIImageView!
   
   var post: InstagramMedia?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      guard let post = post else {
         return
      }
      
      userPictureView.image = #imageLiteral(resourceName: "user")
      if let url = post.user.profilePicture {
         userPictureView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "user"))
      }
      userLabel.text = post.user.username
      
      titleLabel.text = post.caption?.text
      imageView.af_setImage(
         withURL: post.images.standardResolution.url,
         imageTransition: .crossDissolve(0.2))
   }
   
}


// MARK: -

class CenteringScrollView: UIScrollView {
   /// This view sets the content size used to perform the centering.
   @IBOutlet weak var centeringContentView: UIView?
   
   override func layoutSubviews() {
      super.layoutSubviews()
      if let contentHeight = centeringContentView?.frame.height {
         contentInset.top = max(0, frame.height - contentHeight) / 2 + 1
      }
   }
}

