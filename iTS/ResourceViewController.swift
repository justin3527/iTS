//
//  ResourceViewController.swift
//  iTS
//
//  Created by naver on 2017. 9. 19..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ResourceViewController : UIViewController{

    @IBOutlet var mainView:UIView!
    @IBOutlet var scrollView:UIView!
    //CPU label
    @IBOutlet var cpu0_Lbl : UILabel!
    @IBOutlet var cpu1_Lbl : UILabel!
    
    //CPU progress
    @IBOutlet var cpu0_progress : UIProgressView!
    @IBOutlet var cpu1_progress : UIProgressView!
    
    //Traffics Label
    @IBOutlet var wifi_Lbl : UILabel!
    @IBOutlet var cellular_Lbl : UILabel!
    @IBOutlet var local_Lbl : UILabel!
    
    //memory Label
    @IBOutlet var physical_Lbl : UILabel!
    @IBOutlet var user_Lbl : UILabel!
    @IBOutlet var used_Lbl : UILabel!
    @IBOutlet var total_Lbl : UILabel!
    
    //graph views
    @IBOutlet var cpuGraphView : UIView!
    @IBOutlet var trafficGraphView : UIView!
    @IBOutlet var memoryGraphView : UIView!
    
    //Device Label
    @IBOutlet var dName_Lbl : UILabel!
    @IBOutlet var dId_Lbl : UILabel!
    @IBOutlet var dVer_Lbl : UILabel!
    @IBOutlet var dRunTime_Lbl : UILabel!
    
    var timer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updataData()
        self.setGraphs()
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryStateDidChange(notification:)), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryLevelDidChange(notification:)), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updataData), userInfo: nil, repeats: true)
    }
    
    func updataData(){
        self.getResource()
        self.setResourceDataToLabel()
        self.setDeviceDataToLabel()
        var systemSize: Int64? {
            guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
                let totalSize = (systemAttributes[.systemSize] as? NSNumber)?.int64Value else {
                    return nil
            }
            
            return totalSize
        }
        
        var systemFreeSize: Int64? {
            guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
                let freeSize = (systemAttributes[.systemFreeSize] as? NSNumber)?.int64Value else {
                    return nil
            }
            
            return freeSize
        }
        
        print("used:\(Double(systemSize!-systemFreeSize!)/1000000000)/free : \(Double(systemFreeSize!)/1000000000)/total:\(Double(systemSize!)/1000000000)")
    }
    
    func setDeviceDataToLabel(){
        dName_Lbl.text = UIDevice.current.name
        dId_Lbl.text = UIDevice.current.model
        dVer_Lbl.text = UIDevice.current.systemVersion
       
        let systemUpTime = Int(ProcessInfo.processInfo.systemUptime)
        let hour = systemUpTime/3600
        let min = systemUpTime/60 - hour*60
        let sec = systemUpTime%60
        dRunTime_Lbl.text = "\(hour)h \(min)m \(sec)s"
    }

    
    func getResource(){
        getCPU()
        getTraffic()
        getMemory()
    }
    
    func setResourceDataToLabel(){
        //set CPU data
        cpu0_Lbl.text = String(currentCPU.core0)
        cpu1_Lbl.text = String(currentCPU.core1)
        cpu0_progress.progress = currentCPU.core0 * 0.01
        cpu1_progress.progress = currentCPU.core1 * 0.01
        
        //set Traffics  data
        wifi_Lbl.text = String(format:"%d / %d KB", currentWiFi.rx - currentWiFi.rxFirst, currentWiFi.tx - currentWiFi.txFirst)
        cellular_Lbl.text = String(format:"%d / %d KB", currentCell.rx - currentCell.rxFirst, currentCell.tx - currentCell.txFirst)
        local_Lbl.text = String(format:"%d / %d KB", currentLocal.rx - currentLocal.rxFirst, currentLocal.tx - currentLocal.txFirst)
        
        //set memory data
        physical_Lbl.text = String(format:"%.1f% %MB", currentMemory.physical / 1024)
        user_Lbl.text =  String(format:"%.1f% %MB", currentMemory.user / 1024)
        used_Lbl.text = String(format:"%.1f% %MB", currentMemory.used)
        total_Lbl.text = String(format:"%.1f% %MB", currentMemory.total)
    }

    
    func setCPUGraphView(){
        let myChart = ChartsGraph(cpuGraphView.frame)
            let datas = [Double(currentCPU.core0),Double(currentCPU.core1)]
            let labels = ["CPU #0","CPU #1"]
            let barView = myChart.setBarGraphView(datas: datas, labels: labels)
            
            barView.leftAxis.axisMinimum = 0
            barView.leftAxis.axisMaximum = 100
        
            cpuGraphView.addSubview(barView)
        }
    
    
    func setTrafficsGraphView(){
        let myChart = ChartsGraph(trafficGraphView.frame)
            let datas = [Double(currentWiFi.rx),Double(currentWiFi.tx),Double(currentCell.rx),Double(currentCell.tx),Double(currentLocal.rx),Double(currentLocal.tx)]
            let labels = ["WI-FI(Rx/Tx)","Cellular(Rx/Tx)","Local(Rx/Tx)"]
            let barView = myChart.setBarGraphView(datas: datas, labels: labels, groupEntryCount: 2)
       // self.view.addSubview(barView)
        
    }
    
    func setMemoryGraphView(){
        let myChart = ChartsGraph(memoryGraphView.frame)
            let datas = [currentMemory.free, currentMemory.active, currentMemory.inactive, currentMemory.wired]
            let labels = ["free","active","inactive","wired"]
            let pieView = myChart.setPieGraphView(datas: datas, labels: labels)
       // self.view.addSubview(pieView)
    }
    
    func setGraphs(){
        self.setCPUGraphView()
        self.setTrafficsGraphView()
        self.setMemoryGraphView()

    }
    
    
    func batteryStateDidChange(notification: NSNotification){
        // The stage did change: plugged, unplugged, full charge...
        print(UIDevice.current.batteryState)
    }
    
    func batteryLevelDidChange(notification: NSNotification){
        // The battery's level did change (98%, 99%, ...)
        print(UIDevice.current.batteryLevel)
    }
    
    
    @IBAction func refresh(){
        self.updataData()
    }
    
    @IBAction func backToMain(){
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
}
