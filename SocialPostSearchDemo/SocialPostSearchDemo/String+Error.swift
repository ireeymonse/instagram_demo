//
//  String+Error.swift
//  SocialPostSearchDemo
//
//  Created by Iree García on 9/7/18.
//  Copyright © 2018 Iree García. All rights reserved.
//

import Foundation

extension String: LocalizedError {
   public var errorDescription: String? { return self }
}
