//
//  SaveFileList.swift
//  iTS
//
//  Created by naver on 2017. 12. 5..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import UIKit
class SaveFileList{
    
    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    var logPath : URL!
    var logFileList:[String] = []
    init(){
        
        logPath = documentsPath.appendingPathComponent("Log")
        
        if !(FileManager.default.fileExists(atPath: (logPath?.path)!)){
            do{
                try FileManager.default.createDirectory(at: logPath!, withIntermediateDirectories:true ,attributes: nil)
            }catch let error as NSError{
                print("can't create directory, error : \(error.description)")
            }
            
        }
        getLogFileList()
        
    }
    
    func getLogFileList(){
        self.logFileList = try! FileManager.default.contentsOfDirectory(atPath: self.logPath.path)
        
    }
    
    func getCountOfLogFile() -> Int{
        return self.logFileList.count
    }
    
    func getLogFile(index:Int) -> String{
        return logFileList[index]
    }
    
    func shareTheFile(index:Int, target:Any){
        let filePath = [logPath.appendingPathComponent(logFileList[index])]
        print(filePath[0].path)
        let activity = UIActivityViewController.init(activityItems: filePath, applicationActivities: nil)
        (target as! UITableViewController).present(activity, animated: true, completion: nil)
    }
    
    func deleteTheFile(index:Int){
        let filePath = self.getLogFilePath(index: index)
        try! FileManager.default.removeItem(at: filePath)
    }
    
    func getLogFilePath(index: Int)->URL{
        let filePath = logPath.appendingPathComponent(logFileList[index])
        return filePath
    }
    
    func getLogFileDate(index:Int)->String{
        let filePath = self.getLogFilePath(index: index)
        let date = try! FileManager.default.attributesOfItem(atPath: filePath.path) as NSDictionary
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormat.string(from: date.fileCreationDate()!)
    }
    
    
}
