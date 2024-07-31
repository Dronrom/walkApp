//
//  WindowProvider.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-06-09.
//

import Foundation
import SwiftUI

class WindowProvider: ObservableObject {
  weak var windowScene: UIWindowScene?

  func setWindowScene(_ scene: UIWindowScene) {
    windowScene = scene
  }
}
