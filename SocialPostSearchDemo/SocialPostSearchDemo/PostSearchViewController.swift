//
//  PostSearchViewController.swift
//  SocialPostSearchDemo
//
//  Created by Iree García on 8/20/18.
//  Copyright © 2018 Iree García. All rights reserved.
//

import UIKit
import SwiftInstagram
import SVProgressHUD
import AlamofireImage

let mile = 1609

class PostSearchViewController: UIViewController {
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var distanceView: UIView!
   @IBOutlet weak var distanceButton: UIButton!
   @IBOutlet weak var distanceSlider: UISlider!
   
   var refreshControl = UIRefreshControl()
   
   var posts = [InstagramMedia]()
   var distance = 1 * mile {
      didSet {
         distanceButton.setTitle("\(distance / mile) mi", for: .normal)
         distanceSlider.setValue(Float(distance / mile), animated: true)
      }
   }
   fileprivate var imageDownloader = ImageDownloader()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // attempt login
      authenticateIfNeeded { [weak self] error in
         guard error == nil else {
            SVProgressHUD.showError(withStatus: error!.localizedDescription)
            return
         }
         
         // initial load
         SVProgressHUD.show(withStatus: "Loading results")
         self?.reloadResults { error in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
               SVProgressHUD.showError(withStatus: error?.localizedDescription)
               return
            }
            
            // retry load if empty
            if strongSelf.posts.isEmpty && strongSelf.distance < 3 * mile {
               strongSelf.distance = 3 * mile
               strongSelf.reloadResults { _ in
                  SVProgressHUD.dismiss()
               }
               
            } else {
               SVProgressHUD.dismiss()
            }
         }
      }
      
      // config UI
      refreshControl.endRefreshing()
      refreshControl.tintColor = #colorLiteral(red: 0, green: 0.6, blue: 0.6, alpha: 1)
      refreshControl.addTarget(self, action: #selector(refreshResults(_:)), for: .valueChanged)
      tableView.refreshControl = refreshControl
      
      distanceView.isHidden = true
   }
   
   @IBAction func toggleDistanceView(_ sender: Any) {
      distanceView.isHidden = !distanceView.isHidden
   }
   
   @IBAction func distanceSliderChanged(_ sender: UISlider) {
      let prev = distance
      distance = Int(round(sender.value)) * mile
      if prev != distance {
         SVProgressHUD.show(withStatus: "Loading results")
         reloadResults { _ in
            SVProgressHUD.dismiss()
         }
      }
   }
   
   @objc func refreshResults(_ sender: AnyObject) {
      reloadResults { [weak self] error in
         self?.refreshControl.endRefreshing()
         
         guard error == nil else {
            SVProgressHUD.showError(withStatus: error?.localizedDescription)
            return
         }
      }
   }
   
   
   // MARK: - Data
   
   func authenticateIfNeeded(_ completion: @escaping (Error?)->Void) {
      let api = Instagram.shared
      if api.isAuthenticated {
         completion(nil)
         return
      }
      
      api.login(from: navigationController!,
                withScopes: [.basic, .publicContent],
                success: { completion(nil) },
                failure: { completion($0) })
   }
   
   private func reloadResults(_ completion: ((Error?) -> ())? = nil) {
      authenticateIfNeeded { (error) in
         guard error == nil else {
            completion?(error)
            return
         }
         
         // Florida 19.357557, -99.181108
         
         Instagram.shared.searchMedia(
            latitude: 19.357557, longitude: -99.181108, distance: self.distance,
            success: { [weak self] media in
               
               self?.posts = media
               self?.tableView.reloadData()
               completion?(nil)
               
            }, failure: { completion?($0) })
      }
   }
}


// MARK: -

extension PostSearchViewController: UITableViewDataSource, UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return max(posts.count, 1)
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard !posts.isEmpty else {
         return tableView.dequeueReusableCell(withIdentifier: "empty")!
      }
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
      let post = posts[indexPath.row]
      
      cell.titleLabel.text = post.caption?.text
      cell.userLabel.text = post.user.username
      cell.thumbnailView.af_setImage(
         withURL: post.images.lowResolution.url,
         imageTransition: .crossDissolve(0.2))
      
      cell.userPictureView.image = #imageLiteral(resourceName: "user")
      if let url = post.user.profilePicture {
         cell.userPictureView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "user"))
      }
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
   }
}

class PostCell: UITableViewCell {
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var userPictureView: UIImageView!
   @IBOutlet weak var userLabel: UILabel!
   @IBOutlet weak var thumbnailView: UIImageView!
}


