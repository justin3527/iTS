//
//  AllocatorViewController.swift
//  iTS
//
//  Created by naver on 2017. 9. 19..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import UIKit
import Charts
class AllocatorViewController : UIViewController{
    
    @IBOutlet var memoryView : UIView!
    @IBOutlet var currentAddMem : UILabel!
    @IBOutlet var addBtn : UIButton!
    @IBOutlet var freeBtn : UIButton!
    @IBOutlet var refreshBtn : UIButton!
    
    
    var myChart:ChartsGraph!
    let memoryList = [1, 5, 10, 50]
    var currentSetAllocMemory : Int!
    var currentAllocMemIndex : Int!
    var pieChart : PieChartView!
    var common = Common()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        currentAddMem.text = "0MB"
        currentSetAllocMemory  = 0
        currentAllocMemIndex = 0
        myChart = ChartsGraph()
        self.setMemoryChart()
        self.changeBtnState(self.freeBtn)
        self.changeBtnState(self.refreshBtn)
        
    }
    
    override func didReceiveMemoryWarning() {
        self.common.basicAalert(title: "Warnning",msg: "memory is already full",target: self)
    }
    
    func getResource(){
        getCPU()
        getTraffic()
        getMemory()
    }
    
    func setMemoryChart(){
        
        self.getResource()
        var allocatedValue:Int32{return allocCount1mb + allocCount5mb * 5 + allocCount10mb * 10 + allocCount50mb * 50}
        let datas = [currentMemory.free, currentMemory.active, Double(allocatedValue), (currentMemory.physical / 1024) - (currentMemory.free + Double(allocatedValue))]
        let labels = ["free","active","Allocated","Allocable"]
        let pieView = myChart.setPieGraph(frame: memoryView.frame ,datas: datas, labels: labels,colors: ChartColorTemplates.colorful())
        
        self.pieChart = pieView
        
        self.view.addSubview(pieView)
    }
    
    @IBAction func ChangeAllocMemSize(sender : UISegmentedControl){
        self.currentAllocMemIndex = sender.selectedSegmentIndex
        print(currentAllocMemIndex)
        
    }
    
    @IBAction func addMemory(){
        if !freeBtn.isEnabled{
            print("dimmed")
            self.changeBtnState(self.freeBtn)
            self.changeBtnState(self.refreshBtn)
        }
        allocMem(Int32(memoryList[currentAllocMemIndex]))
        currentSetAllocMemory = currentSetAllocMemory + memoryList[currentAllocMemIndex]
        currentAddMem.text = "\(currentSetAllocMemory!)MB"
        self.refreshChart()
    }
    
    @IBAction func freeMemory(){
        
        if currentSetAllocMemory > 0
        {
            freeMem(Int32(memoryList[currentAllocMemIndex]))
            currentSetAllocMemory = currentSetAllocMemory - memoryList[currentAllocMemIndex]
            
            if currentSetAllocMemory < 0{
                currentSetAllocMemory = 0
                self.changeBtnState(self.freeBtn)
                self.changeBtnState(self.refreshBtn)
            }
            
            currentAddMem.text = "\(currentSetAllocMemory!)MB"
            self.refreshChart()
        }
        else{
            self.common.basicAalert(title: "Warnning",msg: "Can't delloc the memory",target: self)
            self.changeBtnState(self.freeBtn)
            self.changeBtnState(self.refreshBtn)
        }
        
    }
    
    @IBAction func freeAllMemory(){
        freeAllMem()
        currentAddMem.text = "0MB"
        self.refreshChart()
        self.changeBtnState(self.freeBtn)
        self.changeBtnState(self.refreshBtn)
        
    }
    
    
    
    func refreshChart(){
        self.pieChart.removeFromSuperview()
        self.setMemoryChart()
        
    }
    
    func changeBtnState(_ btn:UIButton){
        print(btn.alpha)
        print(btn.isEnabled)
        if btn.isEnabled{
            btn.alpha = 0.5
        }
        else{
            btn.alpha = 1
        }
        btn.isEnabled = !btn.isEnabled
        print(btn.isEnabled)
        print("============")
    }
    
    @IBAction func backToMain(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
