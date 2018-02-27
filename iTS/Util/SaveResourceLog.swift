//
//  SaveResourceLog.swift
//  iTS
//
//  Created by naver on 2017. 12. 5..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import CSV

//기록했던 로그 데이터를 엑셀 파일로 변환하는 작업을 하는 메소드가 모인 클레스
class SaveResourceLog{
    
    let rc = ResourceCollection.sharedResource // 리소스 데이터를 싱글톤 패턴으로 관리하고 사용
    
    //로그 데이터를 CSV파일로 저장하기 위하 메소드 (파라미터 : 파일 이름 , 시작 인덱스, 종료 인덱스 )
    //리소스 데이터들은 앱이 실행함과 동시에 기록을 시작하여 종료될떄 까지 기록이 계속되기 떄문에 로그 저장을 시작한 시점의 데이터 인덱스를 시작 인덱스와 종료인덱스로 저장하여 그 부분만 데이터로하여 CSV를 생성하기 위함
    func saveLogToCSV(fileName:String, startIndex:Int, stopIndex:Int){
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) // 도큐멘트 디렉토리 path
        
        let logPath = documentsPath.appendingPathComponent("Log") // 도큐멘트 디렉토리 밑에 LOG 폴더의 path
        
        if !(FileManager.default.fileExists(atPath: (logPath?.path)!)){ // 로그 폴더가 없을 경우 생성
            do{
                try FileManager.default.createDirectory(at: logPath!, withIntermediateDirectories:true ,attributes: nil)
            }catch let error as NSError{
                print("can't create directory, error : \(error.description)")
            }
            
        }
        
        let filePath = logPath?.appendingPathComponent(fileName+".csv") // 저장할 파일 path
        let title = ["Time", "Core0", "Core1", "Memory_wire", "Memory_active", "Memory_inactive", "Memory_used", "Memory_free",  "WIFI_Rx", "WIFI_Tx", "CELL_Rx", "CELL_TX", "LOCAL_Rx","LOCAL_TX"] // excel 상단의 데이터 종류
        var datas = [title]
        
        for i in startIndex ..< stopIndex{ // 엑셀에 로그 데이터 기록
            print(rc.resourses[i])
            datas.append(rc.resourses[i].retrunToExcelData())
        }
        
        self.makeCSV(path: (filePath?.path)!, datas: datas) // CSV라이브러리로 데이터를 엑셀 파일로 생성
        
        print(FileManager.default.fileExists(atPath: (filePath?.path)!))
        
    }
    
    // CSV라이브러리로 데이터를 엑셀 파일 만드는 메소드
    func makeCSV(path:String, datas:[[String]]){
        let stream = OutputStream(toFileAtPath: path, append: false)!
        let csv = try! CSVWriter(stream: stream)
        
        for data in datas{
            try! csv.write(row: data)
        }
        
        csv.stream.close()
    }
    
   

}
