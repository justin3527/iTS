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

//해당 app의 모든 그래프는 Charts 라이브러리를 이용함
// 차트를 생성하는데 중복되는 코드가 많아서 사용성에 맞게 메소드화 해둔 클래스
class ChartsGraph{
    
    //바 형태의 그래프를 생성하는 메소드
    // 파라미터 : frame - 그래프를 그릴 뷰 영역의 프레임 값 / datas - 그래프에 들어갈 데이터 값 / labels - 그래프의 들어갈 레이블 명 / colors - 그래프의 색깔 / groupEntryCount - 그래프의 데이터를 그룹화 하여 표시할 때 사용하는데 그룹내 몇개의 데이터가 들어갈지 입력하면됨 (입력한 그룹의 갯수를 기준으로 순서대로 그룹화한다)
    func setBarGraph(frame:CGRect, datas:[Double], labels:[String], colors:[NSUIColor], groupEntryCount gCount:Int = 1)->BarChartView{
        
        let barView = BarChartView(frame: frame) // 기본 바 차트 생성
        
        barView.data = self.setBarData(datas: datas, labels: labels,colors: colors, groupEntryCount: gCount) // 바 데이터 입력
        barView.rightAxis.enabled = false
        barView.xAxis.enabled = false
        barView.chartDescription?.text = ""
        barView.animate(yAxisDuration: 1)
        
        return barView // 완성된 바 그래프 뷰를 리턴
    }
    
    // 바 차트의 데이터를 구축하는 메소드
    func setBarData(datas:[Double], labels:[String], colors:[NSUIColor],groupEntryCount gCount:Int = 1) ->BarChartData{
        
        //아래 과정은 Charts 라이브러리 사용법 참조
        
        var dataSets : [BarChartDataSet] = []
        
        var i = 0;
        var lblCount = 0 // 그룹화 한 것에 맞춰 적절하게 레이블을 입력하기 위해 레이블 카운트를 따로 둠
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
        lineView.chartDescription?.enabled = false
        lineView.rightAxis.enabled = false
        lineView.legend.form = .line
        lineView.backgroundColor = UIColor.clear
        return lineView
    }

    
    
    func setLineGraphData(datas:[[Double]], labels:[String], colors:[NSUIColor],groupEntryCount gCount:Int = 1) -> LineChartData{
        
        var dataSets : [LineChartDataSet] = []
        var i = 0
        while i < datas.count{
            var entrys : [ChartDataEntry] = [ChartDataEntry]()
            for k in 0..<datas[i].count{
                let entry = ChartDataEntry(x: Double(k), y: Double(datas[i][k]))
                entrys.append(entry)
            }
            
            let dataSet = LineChartDataSet(values: entrys, label: labels[i])
            
            i += 1
            
            dataSet.mode = .cubicBezier
            dataSet.drawCircleHoleEnabled = false
            dataSet.drawCirclesEnabled = false
            dataSet.drawValuesEnabled = false
            if gCount < 2{
                dataSet.colors = [colors[i-1]]
                
            }else{
                dataSet.colors = colors
            }
            
            dataSets.append(dataSet)
        }
        
        let data = LineChartData(dataSets: dataSets)
    
        return data
        
    }
    
}
