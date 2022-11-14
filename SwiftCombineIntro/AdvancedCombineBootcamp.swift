//
//  AdvancedCombineBootcamp.swift
//  SwiftCombineIntro
//
//  Created by Kaori Persson on 2022-11-14.
//  based on this video https://www.youtube.com/watch?v=RUZcs0SWqnI&t=606s

import SwiftUI
import Combine

// this class would not to be observable
class AdvancedCombineDataService {
  
  // @Published var basicPublisher: String = "first publish"
  // CurrentValueSubject(publisher)<Type, Error>(String) <- initialise it with parenthese, should have a default value
  let currentValuePublisher = CurrentValueSubject<String, Never>("first publish")
  
  init() {
    publishFakeData()
  }
  
  private func publishFakeData() {
    let items = ["one", "two", "three"]
    
    for x in items.indices {
      // publishers will stay alive until we cancel them!
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) {
        //self.basicPublisher = items[x]
        self.currentValuePublisher.send(items[x])
      }
    }
  }
}

class AdvancedCombineBootcampViewModel: ObservableObject {
  
  @Published var data: [String] = []
  // You can use 'inject' to reuse dataService to the other place too. See another video
  let dataService = AdvancedCombineDataService()
  
  var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  private func addSubscribers() {
    // Subscribe publisher
    //dataService.$basicPublisher
    dataService.currentValuePublisher
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("finished")
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: { [weak self] returnedValue in
        self?.data.append(returnedValue)
      })
      .store(in: &cancellables)
  }
  
}

struct AdvancedCombineBootcamp: View {
  
  @StateObject private var vm = AdvancedCombineBootcampViewModel()
  
    var body: some View {
      ScrollView {
        VStack {
          ForEach(vm.data, id: \.self) {
            Text($0)
              .font(.largeTitle)
              .fontWeight(.black)
          }
        }
      }
    }
}

struct AdvancedCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineBootcamp()
    }
}
