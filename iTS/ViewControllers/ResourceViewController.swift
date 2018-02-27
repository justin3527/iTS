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

// 현재 리소스 정보를 보여주는 뷰를 관리하는 컨트롤러
class ResourceViewController : UIViewController{

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
    
    // save area
    @IBOutlet var playBtn : UIButton!
    @IBOutlet var stopBtn : UIButton!
    @IBOutlet var timeLabel : UILabel!
    
    //graphs
    var myChart = ChartsGraph()
    var cpuGraph : LineChartView!
    var trafficGraph : LineChartView!
    var memoryGraph : LineChartView!
    var batteryGraph : PieChartView!
    var diskGraph : PieChartView!
    
    var timer:Timer!
    var isUpdate = false
    var trafficType = "wifi"
    
    let common = Common()
    let saveResourceLog = SaveResourceLog()
    var fileName = ""
    var recordStartIdx = 0
    var recordStopIdx = 0
    
    let rc = ResourceCollection.sharedResource
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         UIDevice.current.isBatteryMonitoringEnabled = true
        self.setGraphs()
        isUpdate = true
        self.updataData()
        
        //배터리 변화 관측을 위한 옵져버
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryStateDidChange(notification:)), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryLevelDidChange(notification:)), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updataData), userInfo: nil, repeats: true)
        
        // 메인화면으로 이동 후 재 진입시에도 레코딩 정보를 계속 노출하기 위해 예외처리
        if rc.isRecording{
            playBtn.isEnabled = false
        }
        else{
            stopBtn.isEnabled = false
        }
        
    }
    
    // 타이머를 이용하여 데이터를 업데이트하기 위해 업데이트할 정보를 한 메소드에 통합
    func updataData(){
        self.getResource()
        self.setResourceDataToLabel()
        self.setGraphs()
        self.setDeviceDataToLabel()
        
        if rc.isRecording{
            timeLabel.text = rc.getRunningTime()
        }
       
    }
    
    //다바이스 정보 탭의 레이블에 데이터 입력
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
    
    // 리소스 탭에 데이터를 입력
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

    // cpu 그래프를 만들고 화면에 노출
    func setCPUGraphView(){
        let datas = rc.getRecordCPU()
        let labels = ["CPU #0","CPU #1"]
        let colors = [NSUIColor(red: 41/255.0, green: 111/255.0, blue: 232/255.0, alpha: 1.0), NSUIColor(red: 41/255.0, green: 196/255.0, blue: 232/255.0, alpha: 1.0)]
       
        //초기 한번만 그래프를 초기화 및 생성 하고 이 후에는 데이터만 업데이트
        if !isUpdate{
            self.cpuGraph = myChart.baseLineGraph(frame: cpuGraphView.bounds)
            self.cpuGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: colors)
            cpuGraphView.addSubview(self.cpuGraph)
        }
        else{
            self.cpuGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: colors)
        }
        
        }
    
    // 트래픽은 종류가 많기 때문에 세그먼트 컨트롤러 보여줄 그래프를 선택할 수 있게 구현함
    // 선택한 그래프 정보를 업데이트하기 위한 메소드
    @IBAction func trafficGraphType(sender : UISegmentedControl){
        
        switch sender.selectedSegmentIndex{
        case 0:
            trafficType = "wifi"
        case 1:
            trafficType = "cell"
        case 2:
            trafficType = "local"
        default :
            trafficType = "all"
        }
        setTrafficsGraphView()
    }
    
    // 트래픽 그래프를 만들고 화면에 노출
    func setTrafficsGraphView(){
        let datas = rc.getRecordTraffic(type : trafficType)
            let labels = ["RX", "TX"]
        
        //초기 한번만 그래프를 초기화 및 생성 하고 이 후에는 데이터만 업데이트
        if !isUpdate{
            self.trafficGraph = myChart.baseLineGraph(frame: trafficGraphView.bounds)
            self.trafficGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: ChartColorTemplates.colorful())
            trafficGraphView.addSubview(self.trafficGraph)
        }
        else{
            self.trafficGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: ChartColorTemplates.colorful())
        }
        
        
    }
    // 메모리 그래프를 만들고 화면에 노출
    func setMemoryGraphView(){
        let datas = rc.getRecordMem(type : "resource")
        let labels = ["free","active","inactive","wired"]
        
        let colors = [NSUIColor(red: 192/255.0, green: 255/255.0, blue: 140/255.0, alpha: 1.0),
                      NSUIColor(red: 255/255.0, green: 247/255.0, blue: 140/255.0, alpha: 1.0),
                      NSUIColor(red: 255/255.0, green: 208/255.0, blue: 140/255.0, alpha: 1.0),
                      NSUIColor(red: 140/255.0, green: 234/255.0, blue: 255/255.0, alpha: 1.0),
                      NSUIColor(red: 255/255.0, green: 140/255.0, blue: 157/255.0, alpha: 1.0)]
        //초기 한번만 그래프를 초기화 및 생성 하고 이 후에는 데이터만 업데이트
        if !isUpdate{
            self.memoryGraph = myChart.baseLineGraph(frame: memoryGraphView.bounds)
            self.memoryGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: colors)
            memoryGraphView.addSubview(self.memoryGraph)
        }
        else{
            self.memoryGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: colors)
        }
    }
    // 배터리 그래프를 만들고 화면에 노출
    func setBatteryGraphView(){
        
        let currentBty = UIDevice.current.batteryLevel*100
        let datas = [Double(100-currentBty), Double(currentBty)]
        let labels = ["empty","charge"]
        
        batteryGraph = myChart.setPieGraph(frame: batteryGraphView.bounds, datas: datas, labels: labels, colors:  [NSUIColor(red: 216/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0),NSUIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)])
        
        var batteryState : String
        
        switch UIDevice.current.batteryState{
            
        case .unknown:
            batteryState = "Unknown";
        case .unplugged :
            batteryState = "Uncharge";
        case .charging :
            batteryState = "Charging";
        case .full :
            batteryState = "Full";
            
        }
        
        batteryGraph.centerText = batteryState
        
        batteryGraphView.addSubview(batteryGraph)
    }
    // 디스크그래프를 만들고 화면에 노출
    func setDiskGraphView(){
        //오픈 소스를 이용하여 시스템 디스크 정보를 얻어옴
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
    
    // 그래프를 초기화하고 업데이트메소드를 하나의 메소드로 통합
    func setGraphs(){
        self.setCPUGraphView()
        self.setTrafficsGraphView()
        self.setMemoryGraphView()
        if !isUpdate{
            self.setBatteryGraphView()
            self.setDiskGraphView()
        }
        
    }
    
    // 배터리 충전 상태 변화 시 값 변 경을 위한 메소드
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
    // 배터리 값 변경 시 값을 업데이트하기 위한 메소드
    // 배터리 값이 변할 때 마다 그래프를 업데이트 해줌

    func batteryLevelDidChange(notification: NSNotification){
        // The battery's level did change (98%, 99%, ...)
        print(UIDevice.current.batteryLevel)
        let currentBty = UIDevice.current.batteryLevel*100
        let datas = [Double(100-currentBty), Double(currentBty)]
        let labels = ["empty","charge"]
        
        batteryGraph.data = myChart.setPieData(datas: datas, labels: labels,colors: [NSUIColor(red: 216/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0),NSUIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)])
        
    }
    
        // 로그 레코딩 시작 시 동작하는 메소드
        @IBAction func playResourceRecordLog(){
    
            //파일명을 입력받기 위한 얼럿 노출
            let alert = UIAlertController(title: "Input Log File Name", message: "Input Log File Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField(configurationHandler: {(tf) in
                tf.placeholder = "FileName"
            })
    
            // 얼럿에서 확인 버튼 클릭 시 레코딩 동작(시작 인덱스만 기록)
            let okBtn = UIAlertAction(title: "Start", style: .default){
                (_) in
                self.fileName = (alert.textFields?[0].text)!
                self.playBtn.isEnabled = false
                self.stopBtn.isEnabled = true
                
                self.changeRecordState()
                self.recordStartIdx = self.rc.resourses.count-1
    
            }
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
    
            alert.addAction(okBtn)
            alert.addAction(cancelBtn)
    
            self.present(alert, animated: true)
    
        }
    
        // 레코딩 스탑 버튼 클릭 시 동작하는 메소드로 스탑 인덱스를 설정하고 시작 인덱스와 스탑 인덱스의 사이 데이터를 엑셀파일에다가 기록
        @IBAction func stopResourceRecordLog(){
            playBtn.isEnabled = true
            stopBtn.isEnabled = false
            
            self.changeRecordState()
            self.recordStopIdx = self.rc.resourses.count-1
            rc.resetRecordTime()
            self.saveResourceLog.saveLogToCSV(fileName: fileName, startIndex: recordStartIdx, stopIndex: recordStopIdx)
            
        }
    
    // 레코딩 유무를 변경하기 위한 메소드
    func changeRecordState(){
        rc.isRecording = !rc.isRecording
    }
 
    // 세그먼트를 이용하여 메인뷰로 돌가기 위한 메소드
    @IBAction func backToMain(){
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
}
//디바이스 코드 네임을 우리가 아는 기기명으로 변경해서 보여주기 위함
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
