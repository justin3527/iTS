//
//  MainViewController.swift
//  iTS
//
//  Created by naver on 2017. 9. 15..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import CircleMenu
import UIKit

// 색상 값을 추가로 지정한 익스텐션
extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            colorLiteralRed: Float(1.0) / Float(255.0) * Float(red),
            green: Float(1.0) / Float(255.0) * Float(green),
            blue: Float(1.0) / Float(255.0) * Float(blue),
            alpha: alpha)
    }
}

//앱실행 후 런치 스크린 후 보여지는 앱의 초기화면을 관리하는 컨트롤러
class MainViewController : UIViewController, CircleMenuDelegate{
@IBOutlet var mainBtn:CircleMenu!
    var movedVC : UIViewController! // 메인화면에서 이동할 뷰 컨트롤러를 담을 변수
    let vcNames = ["resourceViewNV","allocatorViewNV","recordingViewNV","logListViewNV"] // 각각 기능 뷰들의 스토리보드 ID
    let items: [(icon: String, color: UIColor)] = [ // 중앙 버튼 클릭 시 나오는 각 뷰로 이동할 아이콘 버튼 설정
        ("icon_resource", UIColor(red:0.19, green:0.57, blue:1, alpha:1)),
        ("icon_overload", UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
        ("icon_recording", UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)),
        ("icon_loglist", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
        //("nearby-btn", UIColor(red:1, green:0.39, blue:0, alpha:1)),
        ]

    
    let rc = ResourceCollection.sharedResource
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //버튼을 동그라미로 만들기 위함
        mainBtn.layer.cornerRadius = mainBtn.bounds.size.height / 2
        mainBtn.layer.borderWidth = 3.0
        mainBtn.layer.borderColor = UIColor.white.cgColor
        mainBtn.backgroundColor = UIColor.white
        mainBtn.clipsToBounds = true
        mainBtn.contentMode = .scaleToFill
        mainBtn.distance = Float(mainBtn.bounds.size.width * 2)

        //리소스 길고 시작
        rc.startCollect()
        
    }
    

    // MARK: <CircleMenuDelegate>
    // 사이클메뉴 라이브러리를 이용한 메소드
    // 기본 라이브러리 사용법만 이용
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        
        button.backgroundColor = items[atIndex].color
        button.bounds.size = CGSize(width: 50, height: 50)
        button.layer.cornerRadius = button.bounds.size.height / 2
        button.layer.borderWidth = 3.0
        button.layer.borderColor = items[atIndex].color.cgColor
        button.clipsToBounds = true
        button.contentMode = .scaleToFill
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage  = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    //버튼이 선택될 떄 수행되는 메소드
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
        if atIndex == 2{ // 미구현 부분 예외 처리
            let common = Common()
            common.basicAalert(title: "Prepare", msg: "Can not use this function yet ", target: self)
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: vcNames[atIndex])
        self.movedVC = vc
        
        print(movedVC)
    }
    
    //버튼이 선택된 후 수행되는 메소드
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        print(movedVC)
        if atIndex == 2{
            let common = Common()
            common.basicAalert(title: "Prepare", msg: "Can not use this function yet ", target: self)
            return
        }
        self.present(self.movedVC,animated: true)
        
    }

}
