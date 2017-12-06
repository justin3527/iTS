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
    
    
    func setBarGraph(frame:CGRect, datas:[Double], labels:[String], colors:[NSUIColor], groupEntryCount gCount:Int = 1)->BarChartView{
        
        let barView = BarChartView(frame: frame)
        
        barView.data = self.setBarData(datas: datas, labels: labels,colors: colors, groupEntryCount: gCount)
        barView.rightAxis.enabled = false
        barView.xAxis.enabled = false
        barView.chartDescription?.text = ""
        barView.animate(yAxisDuration: 1)
        
        return barView
    }
    
    func setBarData(datas:[Double], labels:[String], colors:[NSUIColor],groupEntryCount gCount:Int = 1) ->BarChartData{
        
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
            
            if gCount < 2{
                dataSet.colors = [colors[i-1]]
                
            }else{
                dataSet.colors = colors
            }
            
            dataSets.append(dataSet)
            lblCount += 1
            
        }
        
        return BarChartData(dataSets: dataSets)
        
        
        
    }
    
    
    func setPieGraph(frame:CGRect, datas:[Double], labels:[String], colors:[NSUIColor])->PieChartView{
        
        let pieView = PieChartView(frame: frame)
        pieView.data = self.setPieData(datas: datas, labels: labels, colors: colors)

        pieView.chartDescription?.text = ""
        
        return pieView
    }
    
    func setPieData(datas:[Double], labels:[String], colors:[NSUIColor]) -> PieChartData{
        
        var total = 0.0;
        
        for i in 0..<datas.count{
            total += datas[i]
            print(datas[i])
        }

        var dataEntries : [PieChartDataEntry] = []
        
        for i in 0..<datas.count{
            let entry = PieChartDataEntry(value: datas[i]/total*100, label: labels[i])
           
            dataEntries.append(entry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = colors
        return PieChartData(dataSet: chartDataSet)
        
    }

    
    
    
    func baseLineGraph(frame:CGRect) -> LineChartView{
        let lineView = LineChartView(frame: frame)
        return lineView
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
