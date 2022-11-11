//
//  ViewController.swift
//  SwiftCombineIntro
//
//  Created by Kaori Persson on 2022-11-10.
//

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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.frame = view.bounds
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else {
      fatalError()
    }
  }

}

