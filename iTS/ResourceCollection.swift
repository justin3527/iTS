//
//  ResourceCollection.swift
//  iTS
//
//  Created by naver on 2017. 12. 11..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation

// 시간정보를 타이머의 시간 변화를 HH:MM:SS로 표기화기 위한 구조체
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

// 기록되는 리소스 데이터들을 싱글톤 패턴의 클래스로 관리하여 모든 뷰에서 일관성 있게 데이터를 나타낼 수 있게 하기 위해 구현한 클래스
class ResourceCollection{
    static let sharedResource = ResourceCollection()
    
    var resourses:[ResourceInfo] = []
    var time = timeInfo()
    let common = Common()
    var isRecording = false // 로그 레코딩 중일 경우를 체크 하기 위함
    var additionalAllocMem = 0 // 메모리 과부하 시 추가된 메모리 정보를 담는 변수
    let maxViewDataCount = 300 // 그래프에 보여줄 최대 데이터 갯수
    
    private init(){}
    
    
    func startCollect(){
        
        self.common.startTimer(time: 1, target: self, selector: #selector(self.getResource))
    }
    
    @objc func getResource(){
        if isRecording{ //레코딩 시 레코딩 시간을 체크 하기 위함
            self.time.secValue += 1
        }
        
        resourses.append(ResourceInfo())
        
        
    }
    
    // 레코딩 시간을 반환함
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
    //레코딩 시간 초기화
    func resetRecordTime(){
        self.time.hourValue = 0
        self.time.minValue = 0
        self.time.secValue = 0
        
    }
    
    // 기록하고 있는 CPU 데이터 값을 반환하는 메소드
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
    // 기록하고 있는 메모리 데이터 값을 반환하는 메소드
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
        //사용되는 곳에 따라 리턴 해줄 데이터를 분리
        switch type {
        case "resource" :
            return [freeMems, activeMems, inactiveMems, wireMems]
        case "alloc" :
            return [freeMems, activeMems, physicalMems]
        default :
            return [totalMems, wireMems,activeMems,inactiveMems,freeMems,userMems]
        }
        
    }
    // 기록하고 있는 트래픽 데이터 값을 반환하는 메소드
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
        //원하는 데이터만 리털해주기 위해서 분리
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

