//
//  APICaller.swift
//  SwiftCombineIntro
//
//  Created by Kaori Persson on 2022-11-11.
//

import Combine
import Foundation

class APICaller {
  static let shared = APICaller()
  
  func fetchData(completion: ([String]) -> Void) {
    completion(["Apple"])
  }
}
