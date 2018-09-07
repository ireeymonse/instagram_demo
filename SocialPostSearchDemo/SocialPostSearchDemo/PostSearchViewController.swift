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

class PostSearchViewController: UIViewController {
   @IBOutlet weak var tableView: UITableView!
   
   var refreshControl = UIRefreshControl()
   
   var posts = [InstagramMedia]()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Login
      authenticateIfNeeded { [weak self] (error) in
         guard error == nil else {
            SVProgressHUD.showError(withStatus: error!.localizedDescription)
            return
         }
         
         SVProgressHUD.show(withStatus: "Loading results")
         self?.loadResults { (error, media) in
            guard error == nil else {
               SVProgressHUD.showError(withStatus: error?.localizedDescription)
               return
            }
            
            self?.posts = media ?? []
            self?.tableView.reloadData()
            
            SVProgressHUD.dismiss()
         }
      }
      
      // config
      
      refreshControl.endRefreshing()
      refreshControl.tintColor = #colorLiteral(red: 0, green: 0.6, blue: 0.6, alpha: 1)
      refreshControl.addTarget(self, action: #selector(refreshResults(_:)), for: .valueChanged)
      tableView.refreshControl = refreshControl
   }
   
   func authenticateIfNeeded(_ completion: @escaping (NSError?)->Void) {
      let api = Instagram.shared
      if api.isAuthenticated {
         completion(nil)
         return
      }
      
      api.login(from: navigationController!,
                withScopes: [.basic, .publicContent],
                success: { completion(nil) },
                failure: { completion($0 as NSError) })
   }
   
   
   // MARK: - Data
   
   @objc func refreshResults(_ sender: AnyObject) {
      loadResults { [weak self] (error, results) in
         guard error == nil, let results = results else { return }
         
         self?.posts = results
         self?.tableView.reloadData()
         
         self?.refreshControl.endRefreshing()
      }
   }
   
   private func loadResults(_ completion: @escaping (NSError?, [InstagramMedia]?) -> ()) {
      authenticateIfNeeded { (error) in
         guard error == nil else {
            completion(error, nil)
            return
         }
         
         Instagram.shared.searchMedia(latitude: 19.382403, longitude: -99.175237,
                                      success: { completion(nil, $0) },
                                      failure: { completion($0 as NSError, nil) })
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
      //FIXME: image thumbnail
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
   }
}


class PostCell: UITableViewCell {
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var userLabel: UILabel!
   @IBOutlet weak var thumbnailView: UIImageView!
}

