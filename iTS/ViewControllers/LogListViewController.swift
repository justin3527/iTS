//
//  LogListViewController.swift
//  iTS
//
//  Created by naver on 2017. 9. 19..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import UIKit

//저장된 로그 파일 목록을 보여주는 뷰를 관리하는 컨트롤러
class LogListViewController : UITableViewController{
    
    let saveFileList = SaveFileList() // 로그 파일을 관리하는 클래스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshControl()
    }
    
    func setRefreshControl(){ // 테이블 뷰 상단에서 아래로 당길떄 리프레쉬 되도록 하기 위한 메소드
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.updateListData), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        self.view.addSubview(refreshControl)
        
        
    }
    
    // 목록 데이터를 업데이트하는 메소드
    func updateListData(){
        saveFileList.getLogFileList()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    //테이블의 셀 갯수 설정
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.saveFileList.getCountOfLogFile()
    }
    
    //테이블 셀의 데이터 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemList")!
        
        cell.textLabel?.text = saveFileList.getLogFile(index: row)
        cell.detailTextLabel?.text = saveFileList.getLogFileDate(index: row)
        
        return cell
        
    }
    
    // 셀 선택 시 동작
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        saveFileList.shareTheFile(index: indexPath.row, target: self) // 파일 공유 실행
    }
    
    //셀에서 좌측 스와이프 시 표시될 동작 설정(삭제만 구현)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            saveFileList.deleteTheFile(index: indexPath.row)
            updateListData()
        }
        else if editingStyle == .insert{}
    }
    
    //세그먼트 동작으로 초기화면으로 돌아가기 위한 메소드
    @IBAction func backToMain(){
        self.dismiss(animated: true, completion: nil)
    }
}
