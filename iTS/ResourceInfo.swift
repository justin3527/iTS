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
        physicalMem = currentMemory.physical / 1024
        wifiRx = currentWiFi.rx - currentWiFi.rxFirst
        wifiTx = currentWiFi.tx - currentWiFi.txFirst
        cellRx = currentCell.rx - currentCell.rxFirst
        cellTx = currentCell.tx - currentCell.txFirst
        localRx = currentLocal.rx - currentLocal.rxFirst
        localTx = currentLocal.tx - currentLocal.txFirst
    }
    
    func retrunToString() -> [String]{
        return [time, "\(core0)", "\(core1)", "\(totalMem)", "\(wireMem)", "\(activeMem)", "\(inactiveMem)", "\(userMem)", "\(freeMem)", "\(physicalMem)", "\(wifiRx)", "\(wifiTx)", "\(cellRx)", "\(cellTx)", "\(localRx)", "\(localTx)"]
    }
}
