//
//  ImageCache.swift
//  InfiniteLoadingTableView
//
//  Created by MAC on 9/8/20.
//  Copyright © 2020 PaulRenfrew. All rights reserved.
//

import Foundation
import UIKit

/*
 Singleton - Only 1 instance exists in the application ever. Should also be accessible everywhere
 In Swift need 3 things to create a singleton
 
 1. final class
 2. private init
 3. static shared instance
 */

final class ImageCache {
  
  static let shared = ImageCache()
  
  private init() { }
  
  private let cache: NSCache<NSString, UIImage> = NSCache()
  
  func saveImage(with url: URL, image: UIImage) {
    self.cache.setObject(image, forKey: url.absoluteString as NSString)
  }
  
  func retrieveImage(with url: URL) -> UIImage? {
    return self.cache.object(forKey: url.absoluteString as NSString)
  }
}
