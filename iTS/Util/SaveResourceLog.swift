//
//  SaveResourceLog.swift
//  iTS
//
//  Created by naver on 2017. 12. 5..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import CSV

class SaveResourceLog{
    
    let rc = ResourceCollection.sharedResource
    
    func saveLogToCSV(fileName:String, startIndex:Int, stopIndex:Int){
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        let logPath = documentsPath.appendingPathComponent("Log")
        
        if !(FileManager.default.fileExists(atPath: (logPath?.path)!)){
            do{
                try FileManager.default.createDirectory(at: logPath!, withIntermediateDirectories:true ,attributes: nil)
            }catch let error as NSError{
                print("can't create directory, error : \(error.description)")
            }
            
        }
        
        let filePath = logPath?.appendingPathComponent(fileName+".csv")
        let title = ["Time", "Core0", "Core1", "Memory_Total", "Memory_wire", "Memory_active", "Memory_inactive", "Memory_user", "Memory_free", "Memory_physical", "WIFI_Rx", "WIFI_Tx", "CELL_Rx", "CELL_TX", "LOCAL_Rx","LOCAL_TX"]
        var datas = [title]
        
        for i in startIndex ..< stopIndex{
            print(rc.resourses[i])
            datas.append(rc.resourses[i].retrunToString())
        }
        
        self.makeCSV(path: (filePath?.path)!, datas: datas)
        
        print(FileManager.default.fileExists(atPath: (filePath?.path)!))
        
    }
    
    func makeCSV(path:String, datas:[[String]]){
        let stream = OutputStream(toFileAtPath: path, append: false)!
        let csv = try! CSVWriter(stream: stream)
        
        for data in datas{
            try! csv.write(row: data)
        }
        
        csv.stream.close()
    }
    
   

}
