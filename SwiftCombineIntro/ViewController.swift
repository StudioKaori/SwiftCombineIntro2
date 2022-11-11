//
//  ViewController.swift
//  SwiftCombineIntro
//
//  Created by Kaori Persson on 2022-11-10.
//
import Combine
import UIKit

class MyCustomTableCell: UITableViewCell {
  
}

class ViewController: UIViewController, UITableViewDataSource {
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.register(MyCustomTableCell.self,
                   forCellReuseIdentifier: "cell")
    
    return table
  }()

  // Need it for combine
  private var models = [String]()
  var observer: AnyCancellable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.frame = view.bounds
    
    observer = APICaller.shared.fetchCompanies()
    // receive the data on the main thread instead of using DispathchQueue.main.async
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("finish")
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: { [weak self] value in
        self?.models = value
        // reloadData -> Don't need to wrap with DespatchQueue.main.async because of .receive(on: DispatchQueue.main)
        self?.tableView.reloadData()
      })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else {
      fatalError()
    }
    
    return cell
  }

}

