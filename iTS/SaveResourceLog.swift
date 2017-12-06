//
//  SaveResourceLog.swift
//  iTS
//
//  Created by naver on 2017. 12. 5..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import CSV
struct timeInfo {
    var hourValue : Int = 0
    var minValue : Int = 0
    var secValue : Int = 0
    
    
    mutating func timeEncoding(){
        if secValue == 60{
            minValue += 1
            secValue = 0
        }
        
        if minValue == 60{
            hourValue += 1
            minValue = 0
        }
    }
    
}
class SaveResourceLog{
    
    var resourses:[ResourceInfo]!
    var time = timeInfo()
    let common = Common()
    
    func getRunningTime()->String{
        
        time.timeEncoding()
        
        var secString = ""
        var minString = ""
        var hourString = ""
        
        if self.time.secValue<10{
            secString = "0\(self.time.secValue)"
        }
        else{
            secString = "\(self.time.secValue)"
        }
        
        if self.time.minValue<10{
            minString = "0\(self.time.minValue)"
        }
        else{
            minString = "\(self.time.minValue)"
        }
        
        if self.time.hourValue<10{
            hourString = "0\(self.time.hourValue)"
        }
        else{
            hourString = "\(self.time.hourValue)"
        }
        
        
        
        return "\(hourString):\(minString):\(secString)"
    }
    
    func resetRecordTime(){
        self.time.hourValue = 0
        self.time.minValue = 0
        self.time.secValue = 0
        
    }
    
    func recording(){
        self.time.secValue += 1
        resourses.append(ResourceInfo())
    }
    
    func startRecord(){
        resourses = []
        resetRecordTime()
    }
    
    func saveLogToCSV(fileName:String){
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
        
        for resourse in resourses{
            print(resourse)
            datas.append(resourse.retrunToString())
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
    
    func getRecordCPU()->[[Double]]{
        var cpu0s:[Double] = []
        var cpu1s:[Double] = []
        
        for i in 0..<resourses.count{
            cpu0s.append(Double(resourses[i].core0))
            cpu1s.append(Double(resourses[i].core1))
        }
        
        return [cpu0s, cpu1s]
        
    }
    
    func getRecordMem()->[[Double]]{
        var totalMems:[Double] = []
        var wireMems:[Double] = []
        var activeMems:[Double] = []
        var inactiveMems:[Double] = []
        var freeMems:[Double] = []
        var userMems:[Double] = []
        
        for i in 0..<resourses.count{
            totalMems.append(resourses[i].totalMem)
            wireMems.append(resourses[i].wireMem)
            activeMems.append(resourses[i].activeMem)
            inactiveMems.append(resourses[i].inactiveMem)
            freeMems.append(resourses[i].freeMem)
            userMems.append(resourses[i].userMem)
        }
        
        return [totalMems, wireMems,activeMems,inactiveMems,freeMems,userMems]
    }
    
    func getRecordTraffic()->[[Double]]{
        var wifiRxs:[Double] = []
        var wifiTxs:[Double] = []
        var cellRxs:[Double] = []
        var cellTxs:[Double] = []
        var localRxs:[Double] = []
        var localTxs:[Double] = []
        
        for i in 0..<resourses.count{
            wifiRxs.append(Double(resourses[i].wifiRx))
            wifiTxs.append(Double(resourses[i].wifiTx))
            cellRxs.append(Double(resourses[i].cellRx))
            cellTxs.append(Double(resourses[i].cellTx))
            localRxs.append(Double(resourses[i].localRx))
            localTxs.append(Double(resourses[i].localTx))
        }
        
        return [wifiRxs, wifiTxs,cellRxs,cellTxs,localRxs,localTxs]
   }

}
