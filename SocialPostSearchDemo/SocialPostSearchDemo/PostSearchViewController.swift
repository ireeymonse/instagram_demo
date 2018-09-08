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
import MapKit

let mile = 1609

class PostSearchViewController: UIViewController {
   
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var distanceView: UIView!
   @IBOutlet weak var distanceButton: UIButton!
   @IBOutlet weak var distanceSlider: UISlider!
   @IBOutlet weak var locationLabel: UILabel!
   
   private var refreshControl = UIRefreshControl()
   
   var api: InstagramAPI = Instagram.shared
   var posts = [InstagramMedia]()
   var distance = 1 * mile {
      didSet {
         distanceButton.setTitle("\(distance / mile) mi", for: .normal)
         distanceSlider.setValue(Float(distance / mile), animated: true)
      }
   }
   fileprivate var imageDownloader = ImageDownloader()
   
   fileprivate let locationManager = CLLocationManager()
   fileprivate var location = CLLocation(latitude: 19.357557, longitude: -99.181108)
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // config UI
      refreshControl.endRefreshing()
      refreshControl.tintColor = #colorLiteral(red: 0, green: 0.6, blue: 0.6, alpha: 1)
      refreshControl.addTarget(self, action: #selector(refreshResults(_:)), for: .valueChanged)
      tableView.refreshControl = refreshControl
      
      distanceView.isHidden = true
      locationLabel.superview?.isHidden = true
      
      // initial load
      reloadResults { [weak self] error in
         guard let strongSelf = self else { return }
         guard error == nil else {
            SVProgressHUD.showError(withStatus: error?.localizedDescription)
            return
         }
         
         strongSelf.reloadLocationName()
         
         // retry load if empty
         if strongSelf.posts.isEmpty && strongSelf.distance < 3 * mile {
            strongSelf.distance = 3 * mile
            strongSelf.reloadResults()
         }
      }
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if !api.isAuthenticated {
         navigationItem.leftBarButtonItem?.title = "Log in"
         refreshControl.endRefreshing()
      } else {
         navigationItem.leftBarButtonItem?.title = "Log out"
      }
   }
   
   @IBAction func toggleDistanceView(_ sender: Any) {
      distanceView.isHidden = !distanceView.isHidden
   }
   
   @IBAction func distanceSliderChanged(_ sender: UISlider) {
      let prev = distance
      distance = Int(round(sender.value)) * mile
      if prev != distance {
         reloadResults()
      }
   }
   
   @objc func refreshResults(_ sender: AnyObject) {
      reloadResults { error in
         if error != nil {
            SVProgressHUD.showError(withStatus: error?.localizedDescription)
         }
      }
   }
   
   @IBAction func logOutButtonTapped(_ sender: Any) {
      api.logout()
      posts.removeAll()
      tableView.reloadData()
      
      // show login interface
      api.login(from: navigationController!, withScopes: [.basic, .publicContent], success: {
         self.reloadResults()
      }, failure: nil)
   }
   
   
   // MARK: - Data
   
   private func reloadResults(_ completion: ((Error?) -> Void)? = nil) {
      guard Reachability.isConnectedToNetwork() else {
         refreshControl.endRefreshing()
         completion?("Please, connect to the Internet.")
         return
      }
      
      // load routine
      func load() {
         if !refreshControl.isRefreshing {
            tableView.setContentOffset(
               CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.frame.height),
               animated: true)
            refreshControl.beginRefreshing()
         }
         
         // find location
         enableLocationServices()
         
         api.searchMedia(
            coordinates: location.coordinate, distance: distance,
            success: { [weak self] media in
               
               self?.posts = media
               self?.tableView.reloadData()
               self?.refreshControl.endRefreshing()
               completion?(nil)
               
            }, failure: { completion?($0) })
      }
      
      // auth and load?
      guard api.isAuthenticated else {
         api.login(from: navigationController!,
                   withScopes: [.basic, .publicContent],
                   success: { load() },
                   failure: { completion?($0) })
         return
      }
      
      // just load
      load()
   }
   
   
   // MARK: - Navigation
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      super.prepare(for: segue, sender: sender)
      if let details = segue.destination as? PostDetailsViewController,
         let cell = sender as? UITableViewCell,
         let i = tableView.indexPath(for: cell)?.row
      {
         details.post = posts[i]
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


// MARK: - Location

extension PostSearchViewController: CLLocationManagerDelegate {
   
   func enableLocationServices() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
   }
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      location = locations.last ?? location
      if api.isAuthenticated {
         reloadResults()
         reloadLocationName()
      }
   }
   
   func reloadLocationName() {
      // helper function
      func meters(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
         let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
         return location.distance(from: loc)
      }
      
      api.searchLocation(coordinates: location.coordinate, distance: 5, facebookPlacesId: nil, success: { locations in
         let matches = locations.map { ($0.name, meters(from: $0.coordinates)) }
            .sorted { $0.1 < $1.1 }
         
         if let closest = matches.first {
            self.locationLabel.text = "Near \(closest.0)"
            self.locationLabel.superview?.isHidden = false
         }
         
      }, failure: nil)
   }
}


