//
//  ViewController.swift
//  SwiftCombineIntro
//
//  Created by Kaori Persson on 2022-11-10.
//  Based on this video https://www.youtube.com/watch?v=hbY1KTI0g70
import Combine
import UIKit

class MyCustomTableCell: UITableViewCell {
  
  var button: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemPink
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  // passthrough subject can happen multiple times while completion happens only onece
  // ex. user tap the button multiple times
  let action = PassthroughSubject<String, Never>()
  
  // want to override the initialiser to add it as subview
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(button)
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  @objc private func didTapButton() {
    button.backgroundColor = .systemBlue
    action.send("Cool! Button was tapped!")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    button.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width-20, height: contentView.frame.size.height-6)
  }
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
  var observers: [AnyCancellable] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.frame = view.bounds
    
    APICaller.shared.fetchCompanies()
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
    // .sink returns observer, so store it in observers
      .store(in: &observers)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else {
      fatalError()
    }
    cell.button.setTitle(models[indexPath.row], for: .normal)
    
    // .sink() returns observer(Any cancerable)
    // action: this case, it happens when the button is tapped
    cell.action.sink(receiveValue: { [weak self] string in
      print(string)
      print("Button pressed \(self?.models[indexPath.row])")
    })
    .store(in: &observers)
    
    return cell
  }

}

