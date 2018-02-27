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
//메모리 과부화 뷰를 관리하는 컨트롤러
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
    var rc = ResourceCollection.sharedResource
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        currentAddMem.text = "\(rc.additionalAllocMem)MB" // 현재 추가로 할당된 데이터 화면에 표시
        currentSetAllocMemory  = rc.additionalAllocMem
        currentAllocMemIndex = 0
        myChart = ChartsGraph()
        self.setMemoryChart()
        
        if rc.additionalAllocMem == 0{ // 할당된 메모리가 없을 경우 메모리 초기화, 감소 버튼 비활성화
            self.changeBtnState(self.freeBtn)
            self.changeBtnState(self.refreshBtn)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() { // 메모리 위험 경고 시 얼럿
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
    
    //추가할 메모리 양을 세그먼트컨트롤러로 관리하기 위한 메소드
    
    @IBAction func ChangeAllocMemSize(sender : UISegmentedControl){
        self.currentAllocMemIndex = sender.selectedSegmentIndex
        print(currentAllocMemIndex)
        
    }
    
    
    //메모리 추가 시 동작하는 메소드
    @IBAction func addMemory(){
        if !freeBtn.isEnabled{
            print("dimmed")
            self.changeBtnState(self.freeBtn)
            self.changeBtnState(self.refreshBtn)
        }
        allocMem(Int32(memoryList[currentAllocMemIndex]))
        currentSetAllocMemory = currentSetAllocMemory + memoryList[currentAllocMemIndex]
        currentAddMem.text = "\(currentSetAllocMemory!)MB"
        self.refreshChart() // 차트 새로 고침
    }
    
    //메모리 해제시 동작하는 메소드
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
    
    // 할당된 메모리 초기화 메소드
    @IBAction func freeAllMemory(){
        freeAllMem()
        currentAddMem.text = "0MB"
        self.refreshChart()
        self.changeBtnState(self.freeBtn)
        self.changeBtnState(self.refreshBtn)
        
    }
    
    
    // 그래프 새로고침 메소드
    func refreshChart(){
        self.pieChart.removeFromSuperview()
        self.setMemoryChart()
        
    }
    
    //버튼 활성화 및 비활성화 시 상태 변경을 위한 메소드
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
    
    // 세그먼트 동작으로 초기화면으로 돌아가기 위한 메소드
    @IBAction func backToMain(){
        rc.additionalAllocMem = self.currentSetAllocMemory
        self.dismiss(animated: true, completion: nil)
    }
    
}
