//
//  URLListTableViewController.swift
//  EngIdeaExercise
//
//  Created by MSQUARDIAN on 7/29/19.
//  Copyright © 2019 MSQUARDIAN. All rights reserved.
//

import UIKit

private let reusableLinkLabelCellIdentifier = "ReusableLinkCellIdentifier"


class URLListTableViewController: UITableViewController {
    
    let URLList = URLManager.shared.saved

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableLinkLabelCellIdentifier)
        print(URLList)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return URLList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableLinkLabelCellIdentifier, for: indexPath)
        let urlString = URLList[indexPath.section].absoluteString
        cell.textLabel?.text = urlString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard URLList.count > indexPath.row
            else { return }
        let url = URLList[indexPath.row]
        UIApplication.shared.canOpenURL(url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}
