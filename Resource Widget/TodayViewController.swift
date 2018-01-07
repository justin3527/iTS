//
//  TodayViewController.swift
//  Resource Widget
//
//  Created by naver on 2017. 12. 21..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import UIKit
import NotificationCenter
import Foundation
import Charts

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var cpuGraphView : UIView!
    @IBOutlet var trafficGraphView : UIView!
    @IBOutlet var memoryGraphView : UIView!
    
    let rc = ResourceCollection.sharedResource
    let myChart = ChartsGraph()
    var isUpdate = false
    let common = Common()
    var trafficType = "wifi"
    
    var cpuGraph : LineChartView!
    var trafficGraph : LineChartView!
    var memoryGraph : LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rc.startCollect()
        self.updateGraph()
        isUpdate = true
        
       common.startTimer(time: 1, target: self, selector: #selector(self.updateGraph))
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.removeGraph()
        isUpdate = false
        self.updateGraph()
        isUpdate = true
        completionHandler(NCUpdateResult.newData)
    }
    
    func setCPUGraphView(){
        let datas = rc.getRecordCPU()
        let labels = ["CPU #0","CPU #1"]
        let colors = [NSUIColor(red: 41/255.0, green: 111/255.0, blue: 232/255.0, alpha: 1.0), NSUIColor(red: 41/255.0, green: 196/255.0, blue: 232/255.0, alpha: 1.0)]
        if !isUpdate{
            self.cpuGraph = myChart.baseLineGraph(frame: cpuGraphView.bounds)
            self.cpuGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: colors)
            cpuGraphView.addSubview(self.cpuGraph)
        }
        else{
            self.cpuGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: colors)
        }
        
    }
    
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
    
    func setTrafficsGraphView(){
        let datas = rc.getRecordTraffic(type : trafficType)
        let labels = ["RX", "TX"]
        if !isUpdate{
            self.trafficGraph = myChart.baseLineGraph(frame: trafficGraphView.bounds)
            self.trafficGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: ChartColorTemplates.colorful())
            trafficGraphView.addSubview(self.trafficGraph)
        }
        else{
            self.trafficGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: ChartColorTemplates.colorful())
        }
        
        
    }
    
    func setMemoryGraphView(){
        let datas = rc.getRecordMem(type : "resource")
        let labels = ["free","active","inactive","wired"]
        
        let colors = [NSUIColor(red: 192/255.0, green: 255/255.0, blue: 140/255.0, alpha: 1.0),
                      NSUIColor(red: 255/255.0, green: 247/255.0, blue: 140/255.0, alpha: 1.0),
                      NSUIColor(red: 255/255.0, green: 208/255.0, blue: 140/255.0, alpha: 1.0),
                      NSUIColor(red: 140/255.0, green: 234/255.0, blue: 255/255.0, alpha: 1.0),
                      NSUIColor(red: 255/255.0, green: 140/255.0, blue: 157/255.0, alpha: 1.0)]
        
        if !isUpdate{
            self.memoryGraph = myChart.baseLineGraph(frame: memoryGraphView.bounds)
            self.memoryGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: colors)
            memoryGraphView.addSubview(self.memoryGraph)
        }
        else{
            self.memoryGraph.data = myChart.setLineGraphData(datas: datas, labels: labels, colors: colors)
        }
    }
    
    func updateGraph(){
        self.setCPUGraphView()
        self.setTrafficsGraphView()
        self.setMemoryGraphView()
    }
    
    func removeGraph(){
        self.cpuGraph.removeFromSuperview()
        self.trafficGraph.removeFromSuperview()
        self.memoryGraph.removeFromSuperview()
    }
    
    
    
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == NCWidgetDisplayMode.compact{
            self.preferredContentSize = maxSize
            
        }
        else{
            self.preferredContentSize = CGSize(width: maxSize.width, height : 390)
        }
    }
    
}
