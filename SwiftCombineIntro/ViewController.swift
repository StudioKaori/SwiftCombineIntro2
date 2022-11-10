//
//  ViewController.swift
//  SwiftCombineIntro
//
//  Created by Kaori Persson on 2022-11-10.
//

import UIKit

class MyCustomTableCell: UITableViewCell {
  
}

class ViewController: UIViewController {
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.register(MyCustomTableCell.self,
                   forCellReuseIdentifier: "cell")
    
    return table
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


}

