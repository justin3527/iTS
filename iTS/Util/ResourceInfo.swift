//
//  ResourceInfo.swift
//  iTS
//
//  Created by naver on 2017. 12. 5..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
struct ResourceInfo{
    
    var time : String
    var core0 : Float
    var core1 : Float
    var totalMem : Double
    var wireMem : Double
    var activeMem : Double
    var inactiveMem : Double
    var freeMem : Double
    var userMem : Double
    var usedMem : Double
    var physicalMem : Double
    var wifiRx : UInt32
    var wifiTx : UInt32
    var cellRx : UInt32
    var cellTx : UInt32
    var localRx : UInt32
    var localTx : UInt32
    
    init(){
        let common = Common()
        
        getCPU()
        getTraffic()
        getMemory()
        
        time = (common.getCurrentDate())
        core0 = currentCPU.core0
        core1 = currentCPU.core1
        totalMem = currentMemory.total
        wireMem = currentMemory.wired
        activeMem = currentMemory.active
        inactiveMem = currentMemory.inactive
        freeMem = currentMemory.free
        userMem = currentMemory.user/1024
        usedMem = currentMemory.used
        physicalMem = currentMemory.physical / 1024
        
        
        
        
        wifiRx = currentWiFi.rx - currentWiFi.rxOld
        wifiTx = currentWiFi.tx - currentWiFi.txOld
        cellRx = currentCell.rx - currentCell.rxOld
        cellTx = currentCell.tx - currentCell.txOld
        localRx = currentLocal.rx - currentLocal.rxOld
        localTx = currentLocal.tx - currentLocal.txOld
        
        print("\(currentWiFi.rx) / \(currentWiFi.rxFirst) / \(currentWiFi.rxOld) / \(wifiRx)")
        currentWiFi.rxOld = currentWiFi.rx
        currentWiFi.txOld = currentWiFi.tx
        currentCell.rxOld = currentCell.rx
        currentCell.txOld = currentCell.tx
        currentLocal.rxOld = currentLocal.rx
        currentLocal.txOld = currentLocal.tx
    }
    
    //모든 데이터를 스트링으로 반환 하는 메소드
    func retrunToString() -> [String]{
        return [time, "\(core0)", "\(core1)", "\(totalMem)", "\(wireMem)", "\(activeMem)", "\(inactiveMem)", "\(userMem)", "\(usedMem)", "\(freeMem)", "\(physicalMem)", "\(wifiRx)", "\(wifiTx)", "\(cellRx)", "\(cellTx)", "\(localRx)", "\(localTx)"]
    }
    
    // 로그 데이터 중 엑셀에 저장할 데이터만 반환
    func retrunToExcelData() -> [String]{
        return [time, "\(core0)", "\(core1)", "\(wireMem)", "\(activeMem)", "\(inactiveMem)", "\(usedMem)", "\(freeMem)", "\(wifiRx)", "\(wifiTx)", "\(cellRx)", "\(cellTx)", "\(localRx)", "\(localTx)"]
    }
}
