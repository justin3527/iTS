//
//  SaveFileList.swift
//  iTS
//
//  Created by naver on 2017. 12. 5..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import UIKit

// 저장된 로그 파일들을 목록화하기 위한 클래스
class SaveFileList{
    // 기본 도큐멘트 디렉토리 경로
    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    var logPath : URL!
    var logFileList:[String] = []
    init(){
        
        logPath = documentsPath.appendingPathComponent("Log") // 로그 폴더의 경로
        
        //로그 폴더가 없으면 생성
        if !(FileManager.default.fileExists(atPath: (logPath?.path)!)){
            do{
                try FileManager.default.createDirectory(at: logPath!, withIntermediateDirectories:true ,attributes: nil)
            }catch let error as NSError{
                print("can't create directory, error : \(error.description)")
            }
            
        }
        getLogFileList() // 로그 파일 리스트를 불러옴
        
    }
    // 로그 파일 리스트를 불러오는 메소드
    func getLogFileList(){
        self.logFileList = try! FileManager.default.contentsOfDirectory(atPath: self.logPath.path) //해당 경로 밑의 모든 파일의 이름을 받아옴
        
    }
    // 로그파일 갯수
    func getCountOfLogFile() -> Int{
        return self.logFileList.count
    }
    // 인덱스 입력 시 해당 로그 파일을 이름 반환
    func getLogFile(index:Int) -> String{
        return logFileList[index]
    }
    
    // 파일 공유를 위한 매소드
    func shareTheFile(index:Int, target:Any){
        let filePath = [logPath.appendingPathComponent(logFileList[index])]
        print(filePath[0].path)
        let activity = UIActivityViewController.init(activityItems: filePath, applicationActivities: nil)
        (target as! UITableViewController).present(activity, animated: true, completion: nil)
    }
    
    //로그 파일 삭제 메소드
    func deleteTheFile(index:Int){
        let filePath = self.getLogFilePath(index: index)
        try! FileManager.default.removeItem(at: filePath)
    }
    
    // 해당 인덱스의 로그파일의 경로를 반환하느 메소드
    func getLogFilePath(index: Int)->URL{
        let filePath = logPath.appendingPathComponent(logFileList[index])
        return filePath
    }
    
    // 로그파일의 정보를 반환하는 메소드(여기서는 생성 날짜)
    func getLogFileDate(index:Int)->String{
        let filePath = self.getLogFilePath(index: index)
        let date = try! FileManager.default.attributesOfItem(atPath: filePath.path) as NSDictionary
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormat.string(from: date.fileCreationDate()!)
    }
    
    
}
