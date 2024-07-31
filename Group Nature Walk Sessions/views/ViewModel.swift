//
//  ViewModel.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-06-09.
//

import SwiftUI

final class ViewModel: ObservableObject {
  let openURL: OpenURLProtocol

  init(openURL: OpenURLProtocol = UIApplication.shared) {
    self.openURL = openURL
  }

  func callNumber(phoneNumber: String) {
      guard let url = URL(string: "tel://\(phoneNumber)") else { return }
              openURL.open(url)
  }
}
