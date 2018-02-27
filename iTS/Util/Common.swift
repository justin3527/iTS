//
//  Common.swift
//  iTS
//
//  Created by naver on 2017. 12. 5..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import UIKit

// 대부분의 앱 개발 시 공통적으로 사용할 수 있는 부분을 따로 클래스화 해둔 녀석

class Common{
    
    var timer : Timer! //반복을 위한 타이머
    
    //타이머시작
    // 파라미터 : time - 반복 시간 / target : 해당 기능을 수행할 클래스 / selector - 반복할 메소드
    
    func startTimer(time:Double, target:Any, selector:Selector){
        timer = Timer.scheduledTimer(timeInterval: time, target: target, selector: selector, userInfo: nil, repeats: true)
    }
    
    //타이머 종료
    func stopTimer(){
        timer.invalidate()
    }
    
    //기본 얼럿 구현을 메소드화 한 것
    func basicAalert(title:String, msg:String, target:Any) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "comfirm", style: .default)
        
        alert.addAction(ok)
        
        (target as! UIViewController).present(alert,animated:true)
    }
    
    //현재 날짜를 반환함
    func getCurrentDate()->String{
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: now as Date)
    }
}
