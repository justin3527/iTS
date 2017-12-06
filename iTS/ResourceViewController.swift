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
    @IBOutlet var batteryGraphView : UIView!
    @IBOutlet var diskGraphView : UIView!
    
    //Device Label
    @IBOutlet var dName_Lbl : UILabel!
    @IBOutlet var dId_Lbl : UILabel!
    @IBOutlet var dVer_Lbl : UILabel!
    @IBOutlet var dRunTime_Lbl : UILabel!
    
    //graphs
    var myChart = ChartsGraph()
    var cpuGraph : BarChartView!
    var trafficGraph : BarChartView!
    var memoryGraph : PieChartView!
    var batteryGraph : PieChartView!
    var diskGraph : PieChartView!
    
    var timer:Timer!
    
    //colors
  let colors = [NSUIColor(red: 192/255.0, green: 255/255.0, blue: 140/255.0, alpha: 1.0),
    NSUIColor(red: 255/255.0, green: 247/255.0, blue: 140/255.0, alpha: 1.0),
    NSUIColor(red: 255/255.0, green: 208/255.0, blue: 140/255.0, alpha: 1.0),
    NSUIColor(red: 140/255.0, green: 234/255.0, blue: 255/255.0, alpha: 1.0),
    NSUIColor(red: 255/255.0, green: 140/255.0, blue: 157/255.0, alpha: 1.0)]
    override func viewDidLoad() {
        super.viewDidLoad()
         UIDevice.current.isBatteryMonitoringEnabled = true
        self.setGraphs()
        self.updataData()
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryStateDidChange(notification:)), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryLevelDidChange(notification:)), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updataData), userInfo: nil, repeats: true)
    }
    
    func updataData(){
        self.getResource()
        self.setResourceDataToLabel()
        self.updateGraphs()
        self.setDeviceDataToLabel()
       
    }
    
    func setDeviceDataToLabel(){
        dName_Lbl.text = UIDevice.current.name
        dId_Lbl.text =  UIDevice.current.modelName
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
            let datas = [Double(currentCPU.core0),Double(currentCPU.core1)]
            let labels = ["CPU #0","CPU #1"]
            self.cpuGraph = myChart.setBarGraph(frame : cpuGraphView.bounds, datas: datas, labels: labels, colors: ChartColorTemplates.joyful())
            
            self.cpuGraph.leftAxis.axisMinimum = 0
            self.cpuGraph.leftAxis.axisMaximum = 100
        
    
        cpuGraphView.addSubview(self.cpuGraph)
        }
    
    
    func setTrafficsGraphView(){
            let datas = [Double(currentWiFi.rx),Double(currentWiFi.tx),Double(currentCell.rx),Double(currentCell.tx),Double(currentLocal.rx),Double(currentLocal.tx)]
            let labels = ["WI-FI(Rx/Tx)","Cellular(Rx/Tx)","Local(Rx/Tx)"]
            self.trafficGraph = myChart.setBarGraph(frame : trafficGraphView.bounds, datas: datas, labels: labels, colors: ChartColorTemplates.colorful(),groupEntryCount: 2)
       // self.view.addSubview(barView)
        trafficGraphView.addSubview(self.trafficGraph)
        
    }
    
    func setMemoryGraphView(){
            let datas = [currentMemory.free, currentMemory.active, currentMemory.inactive, currentMemory.wired]
            let labels = ["free","active","inactive","wired"]
        self.memoryGraph = myChart.setPieGraph(frame : memoryGraphView.bounds, datas: datas, labels: labels, colors: ChartColorTemplates.pastel())
       
        memoryGraphView.addSubview(self.memoryGraph)
    }
    
    func setBatteryGraphView(){
        
        let currentBty = UIDevice.current.batteryLevel*100
        let datas = [Double(100-currentBty), Double(currentBty)]
        let labels = ["empty","charge"]
        
        batteryGraph = myChart.setPieGraph(frame: batteryGraphView.bounds, datas: datas, labels: labels, colors: ChartColorTemplates.material())
        
        var batteryState : String
        
        switch UIDevice.current.batteryState{
            
        case .unknown:
            batteryState = "Unknown";
        case .unplugged :
            batteryState = "Uncharging";
        case .charging :
            batteryState = "Charging";
        case .full :
            batteryState = "Full";
            
        }
        
        batteryGraph.centerText = batteryState
        
        batteryGraphView.addSubview(batteryGraph)
    }
    
    func setDiskGraphView(){
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
        
        let datas = [Double(systemFreeSize!), Double(systemSize!)]
        let labels = ["Free","Used"]
        self.diskGraph = myChart.setPieGraph(frame : diskGraphView.bounds, datas: datas, labels: labels, colors: [NSUIColor(red: 216/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0), NSUIColor(red: 255/255.0, green: 0/255.0, blue: 98/255.0, alpha: 1.0)])
        self.diskGraph.centerText = "DISK"
        diskGraphView.addSubview(self.diskGraph)
        
    }
    
    func setGraphs(){
        self.setCPUGraphView()
        self.setTrafficsGraphView()
        self.setMemoryGraphView()
        self.setBatteryGraphView()
        self.setDiskGraphView()
    }
    
    func updateGraphs(){
        
        let cpuDatas = [Double(currentCPU.core0),Double(currentCPU.core1)]
        let cpuLabels = ["CPU #0","CPU #1"]
        self.cpuGraph.data = myChart.setBarData(datas: cpuDatas, labels: cpuLabels, colors: [NSUIColor(red: 41/255.0, green: 111/255.0, blue: 232/255.0, alpha: 1.0),NSUIColor(red: 41/255.0, green: 196/255.0, blue: 232/255.0, alpha: 1.0)])
        
        let trafficDatas = [Double(currentWiFi.rx),Double(currentWiFi.tx),Double(currentCell.rx),Double(currentCell.tx),Double(currentLocal.rx),Double(currentLocal.tx)]
        let trafficLabels = ["WI-FI(Rx/Tx)","Cellular(Rx/Tx)","Local(Rx/Tx)"]
        self.trafficGraph.data = myChart.setBarData(datas: trafficDatas, labels:trafficLabels,colors: ChartColorTemplates.colorful(), groupEntryCount: 2)
        
        let memDatas = [currentMemory.free, currentMemory.active, currentMemory.inactive, currentMemory.wired]
        let memLabels = ["free","active","inactive","wired"]
        self.memoryGraph.data = myChart.setPieData(datas: memDatas, labels: memLabels, colors: ChartColorTemplates.colorful())
        
    }
    
    
    func batteryStateDidChange(notification: NSNotification){
        // The stage did change: plugged, unplugged, full charge...
        print(UIDevice.current.batteryState)
        
        var batteryState : String
        
        switch UIDevice.current.batteryState{
            
        case .unknown:
            batteryState = "Unknown";
        case .unplugged :
            batteryState = "Uncharging";
        case .charging :
            batteryState = "Charging";
        case .full :
            batteryState = "Full";
            
        }
        
        batteryGraph.centerText = batteryState
    }
    
    func batteryLevelDidChange(notification: NSNotification){
        // The battery's level did change (98%, 99%, ...)
        print(UIDevice.current.batteryLevel)
        let currentBty = UIDevice.current.batteryLevel*100
        let datas = [Double(100-currentBty), Double(currentBty)]
        let labels = ["empty","charge"]
        
        batteryGraph.data = myChart.setPieData(datas: datas, labels: labels,colors: [NSUIColor(red: 216/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0),NSUIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)])
        
    }
    
    
    @IBAction func refresh(){
        self.updataData()
    }
    
    @IBAction func backToMain(){
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,3":                               return "iPhone 7"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
