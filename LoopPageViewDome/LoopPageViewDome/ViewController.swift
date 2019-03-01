//
//  ViewController.swift
//  LoopPageViewDome
//
//  Created by admin on 2019/3/1.
//  Copyright © 2019 zhouqiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let items = ["上下滚动", "左右滚动"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "轮播器"
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = VerticalViewController()
            vc.title =  items[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = HorizontalViewController()
            vc.title =  items[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

