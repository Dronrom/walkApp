//
//  OpenURLProtocol.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-06-09.
//

import Foundation
import SwiftUI

protocol OpenURLProtocol {
  func open(_ url: URL)
}

extension UIApplication: OpenURLProtocol {
  func open(_ url: URL) {
    open(url, options: [:], completionHandler: nil)
  }
}
