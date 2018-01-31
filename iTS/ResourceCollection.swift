//
//  ResourceCollection.swift
//  iTS
//
//  Created by naver on 2017. 12. 11..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation

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

class ResourceCollection{
    static let sharedResource = ResourceCollection()
    
    var resourses:[ResourceInfo] = []
    var time = timeInfo()
    let common = Common()
    var isRecording = false
    var additionalAllocMem = 0
    let maxViewDataCount = 300
    
    private init(){}
    
    
    func startCollect(){
        
        self.common.startTimer(time: 1, target: self, selector: #selector(self.getResource))
    }
    
    @objc func getResource(){
        if isRecording{
            self.time.secValue += 1
        }
        
        resourses.append(ResourceInfo())
        
        
    }
    
    
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
    
    
    func getRecordCPU()->[[Double]]{
        var cpu0s:[Double] = []
        var cpu1s:[Double] = []
        
        var k:Int = 0
        
        if resourses.count > maxViewDataCount{
            k = resourses.count - maxViewDataCount
        }
        
        for i in k..<resourses.count{
            cpu0s.append(Double(resourses[i].core0))
            cpu1s.append(Double(resourses[i].core1))
        }
        
        return [cpu0s, cpu1s]
        
    }
    
    func getRecordMem(type:String = "record")->[[Double]]{
        var totalMems:[Double] = []
        var wireMems:[Double] = []
        var activeMems:[Double] = []
        var inactiveMems:[Double] = []
        var freeMems:[Double] = []
        var userMems:[Double] = []
        var physicalMems : [Double] = []
        var k:Int = 0
        
        if resourses.count > maxViewDataCount{
            k = resourses.count - maxViewDataCount
        }
        
        for i in k..<resourses.count{
            totalMems.append(resourses[i].totalMem)
            wireMems.append(resourses[i].wireMem)
            activeMems.append(resourses[i].activeMem)
            inactiveMems.append(resourses[i].inactiveMem)
            freeMems.append(resourses[i].freeMem)
            userMems.append(resourses[i].userMem)
            physicalMems.append(resourses[i].physicalMem)
        }
        
        switch type {
        case "resource" :
            return [freeMems, activeMems, inactiveMems, wireMems]
        case "alloc" :
            return [freeMems, activeMems, physicalMems]
        default :
            return [totalMems, wireMems,activeMems,inactiveMems,freeMems,userMems]
        }
        
    }
    
    func getRecordTraffic(type:String = "all")->[[Double]]{
        var wifiRxs:[Double] = []
        var wifiTxs:[Double] = []
        var cellRxs:[Double] = []
        var cellTxs:[Double] = []
        var localRxs:[Double] = []
        var localTxs:[Double] = []
        
        var k:Int = 0
        
        if resourses.count > maxViewDataCount{
            k = resourses.count - maxViewDataCount
        }
        
        for i in k..<resourses.count{
            wifiRxs.append(Double(resourses[i].wifiRx))
            wifiTxs.append(Double(resourses[i].wifiTx))
            cellRxs.append(Double(resourses[i].cellRx))
            cellTxs.append(Double(resourses[i].cellTx))
            localRxs.append(Double(resourses[i].localRx))
            localTxs.append(Double(resourses[i].localTx))
        }
        
        switch type {
        case "wifi":
            return [wifiRxs, wifiTxs]
        case "cell" :
            return [cellRxs,cellTxs]
        case "local" :
            return [localRxs,localTxs]
        default:
            return [wifiRxs, wifiTxs,cellRxs,cellTxs,localRxs,localTxs]
        }
        
    }
    
    
    
    
}

