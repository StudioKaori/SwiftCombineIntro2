//
//  AdvancedCombineBootcamp.swift
//  SwiftCombineIntro
//
//  Created by Kaori Persson on 2022-11-14.
//  based on this video https://www.youtube.com/watch?v=RUZcs0SWqnI&t=606s

import SwiftUI
import Combine

class AdvancedCombineDataService {
  
  let passThroughPublisher = PassthroughSubject<Int, Never>()
  
  init() {
    publishFakeData()
  }
  
  private func publishFakeData() {
    let items: [Int] = Array(0..<11)
    
    for x in items.indices {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) {
        self.passThroughPublisher.send(items[x])
      }
    }
  }
}

class AdvancedCombineBootcampViewModel: ObservableObject {
  
  @Published var data: [String] = []
  @Published var error: String = ""
  
  let dataService = AdvancedCombineDataService()
  
  var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  private func addSubscribers() {

    dataService.passThroughPublisher
    // Sequence operation
    // .first() -> only first publisher is coming through to the pipeline
    //  .first()
    
    // You can set a condition, ex. the first Int greater than 4
    //  .first(where: { $0 > 4 })
    
    // If you want to handle the error, use tryFirst
      .tryFirst(where: { int in
        if int == 3 {
          // If throw the error here, you will receive the error in the completion
          // Look at the switch case .failure
          throw URLError(.badServerResponse)
        }
        return int > 4
        
        // If the successful case comes first, the error wouldn't be thrown.
        // This case, successful case is greater than 1
        //return int > 1
      })
    
    // convert Int to String
      .map({ String($0) })
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("finished")
        case .failure(let error):
          self.error = "Error: \(error.localizedDescription)"
          print("Error: \(error.localizedDescription)")
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
          
          if !vm.error.isEmpty {
            Text(vm.error)
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
