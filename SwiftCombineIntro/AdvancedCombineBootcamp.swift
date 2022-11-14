//
//  AdvancedCombineBootcamp.swift
//  SwiftCombineIntro
//
//  Created by Kaori Persson on 2022-11-14.
//  based on this video https://www.youtube.com/watch?v=RUZcs0SWqnI&t=606s

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
  // You can use 'inject' to reuse dataService to the other place too. See another video
  let dataService = AdvancedCombineDataService()
  
  init() {
    addSubscribers()
  }
  
  private func addSubscribers() {
    dataService.$basicPublisher
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("finished")
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: { [weak self] returnedValue in
        self?.data = returnedValue
      })
  }
  
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
