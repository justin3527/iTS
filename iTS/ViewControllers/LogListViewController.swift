//
//  LogListViewController.swift
//  iTS
//
//  Created by naver on 2017. 9. 19..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import UIKit

class LogListViewController : UITableViewController{
    
    let saveFileList = SaveFileList()
    var resultSearch:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshControl()
    }
    
    func setRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.updateListData), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        self.view.addSubview(refreshControl)
        
        
    }
    
    func updateListData(){
        saveFileList.getLogFileList()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.saveFileList.getCountOfLogFile()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemList")!
        
        cell.textLabel?.text = saveFileList.getLogFile(index: row)
        cell.detailTextLabel?.text = saveFileList.getLogFileDate(index: row)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        saveFileList.shareTheFile(index: indexPath.row, target: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            saveFileList.deleteTheFile(index: indexPath.row)
            updateListData()
        }
        else if editingStyle == .insert{}
    }
    
    @IBAction func backToMain(){
        self.dismiss(animated: true, completion: nil)
    }
}
