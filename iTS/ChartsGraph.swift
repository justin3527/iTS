//
//  ChartsGraph.swift
//  iTS
//
//  Created by naver on 2017. 10. 21..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import UIKit
import Charts
class ChartsGraph{
    
    var frame:CGRect!
    
    init(_ newFrame:CGRect){
        self.frame = newFrame
    }
    
    
    func basePieGraph()->PieChartView{
        
        let pieView = PieChartView(frame: self.frame)
        
        pieView.backgroundColor = UIColor.white
        pieView.chartDescription?.text = ""
        
        return pieView
    }
    
    func baseBarGraph()->BarChartView{
        
        let barView = BarChartView(frame: self.frame)
        
        barView.rightAxis.enabled = false
        barView.xAxis.enabled = false
        barView.backgroundColor = UIColor.white
        barView.chartDescription?.text = ""
        barView.animate(yAxisDuration: 1)
        
        return barView
    }
    
    func baseLineGraph() -> LineChartView{
        let lineView = LineChartView(frame: self.frame)
        return lineView
    }
    
    func setBarGraphView(datas:[Double], labels:[String], groupEntryCount gCount:Int = 1) ->BarChartView{
        
        var dataSets : [BarChartDataSet] = []
        
        var i = 0;
        var lblCount = 0
        while(i<datas.count){
            
            var dataEntries : [BarChartDataEntry] = []
            
            for _ in 0..<gCount{
                let dataEntry = BarChartDataEntry(x: Double(i), y: datas[i])
                dataEntries.append(dataEntry)
                i+=1
            }
            
            let dataSet = BarChartDataSet(values: dataEntries, label: labels[lblCount])
            dataSet.colors = ChartColorTemplates.colorful()
            dataSets.append(dataSet)
            lblCount += 1
            
        }
        
        let chartData = BarChartData(dataSets: dataSets)
        let barView = self.baseBarGraph()
        barView.data = chartData
        
        return barView
        
    }
    
    
    func setPieGraphView(datas:[Double], labels:[String]) -> PieChartView{
        
        var total = 0.0;
        
        for i in 0..<datas.count{
            total += datas[i]
        }
        
        var dataEntries : [PieChartDataEntry] = []
        
        for i in 0..<datas.count{
            let entry = PieChartDataEntry(value: datas[i]/total*100, label: labels[i])
            dataEntries.append(entry)
        }
        
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = ChartColorTemplates.colorful()
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let pieView = self.basePieGraph()
        pieView.data = chartData
        
        return pieView
    }
    
    func setLineGraphData(datas:[[Double]], labels:[String], colors:[UIColor]) -> LineChartData{
        
        var dataSets : [LineChartDataSet] = []
        
        for i in 0..<datas.count{
            var entrys : [ChartDataEntry] = [ChartDataEntry]()
            for k in 0..<datas[i].count{
                let entry = ChartDataEntry(x: Double(k), y: Double(datas[i][k]))
                entrys.append(entry)
            }
            
            let dataSet = LineChartDataSet(values: entrys, label: labels[i])
            dataSet.colors = [colors[i]]
            dataSets.append(dataSet)
        }
        
        let data = LineChartData(dataSets: dataSets)
        
        return data
        
    }
    
}
