//
//  SocialPostSearchDemoTests.swift
//  SocialPostSearchDemoTests
//
//  Created by Iree García on 9/8/18.
//  Copyright © 2018 Iree García. All rights reserved.
//

import XCTest
@testable import SocialPostSearchDemo

class SocialPostSearchDemoTests: XCTestCase {
   
   var searchViewController: PostSearchViewController!
   var api = InstagramMock()
   
   override func setUp() {
      super.setUp()
      
      // recreate controller stack
      let nav = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as! UINavigationController
      UIApplication.shared.keyWindow!.rootViewController = nav
      XCTAssertNotNil(nav.view)
      
      searchViewController = nav.topViewController as? PostSearchViewController
      
      // mock api
      searchViewController.api = api
      
      // load view
      XCTAssertNotNil(searchViewController?.view, "Post search not presented")
   }
   
   override func tearDown() {
      super.tearDown()
   }
   
   func testLogIn() {
      XCTAssertTrue(api.isAuthenticated, "Login not attempted")
   }
   
   func testLogOut() {
      api.loginEnabled = false
      searchViewController.logOutButtonTapped(())
      XCTAssertFalse(api.isAuthenticated, "Logout not executed")
   }
   
   func testInitialSearchWidensArea() {
      XCTAssertEqual(searchViewController.distance, 3 * mile, "Area not widen in initial search")
   }
   
   func testFindPosts() {
      // add test data
      try? api.mockMedia(from: InstagramMock.response)
      
      // reload
      searchViewController.refreshResults(self)
      XCTAssertEqual(searchViewController.posts.count, 3, "Posts not found")
   }
   
}
