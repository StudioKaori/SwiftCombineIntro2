//
//  AdvancedCombineBootcamp.swift
//  SwiftCombineIntro
//
//  Created by Kaori Persson on 2022-11-14.
//

import SwiftUI

// this class would not to be observable
class AdvancedCombineDataService {
  
  @Published var basicPublisher: [String] = []
  
  init() {
    publishFakeData()
  }
  
  private func publishFakeData() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.basicPublisher = ["one", "two", "three"]
    }
  }
}

class AdvancedCombineBootcampViewModel: ObservableObject {
  
  @Published var data: [String] = []
  
}

struct AdvancedCombineBootcamp: View {
  
  @StateObject private var vm = AdvancedCombineBootcampViewModel()
  
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AdvancedCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineBootcamp()
    }
}
