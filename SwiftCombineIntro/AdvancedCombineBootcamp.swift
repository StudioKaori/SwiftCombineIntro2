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
        
        // When reach to the end, send the completion ".finished"
        if x == items.indices.last {
          self.passThroughPublisher.send(completion: .finished)
        }
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
    // When is the last publisher?? -> need completion to know the last publisher
    //  .last()
    
    // This case the result will be 3, but the need to wait until receiving completion .finish (This case 10 secs)
    //  .last(where: { $0 < 4 })
    
    // Handle error
    // Unlike tryFirst, this case the error occurs even int > 1 comes first.
//      .tryLast(where: { int in
//        if int == 3 {
//          throw URLError(.badServerResponse)
//        }
//        return int > 1
//      })
    
    // Did the video until tryLast
    // https://www.youtube.com/watch?v=RUZcs0SWqnI&t=1203s
    // Next topic is 35:58, dropFirst
    
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
