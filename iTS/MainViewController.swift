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

extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            colorLiteralRed: Float(1.0) / Float(255.0) * Float(red),
            green: Float(1.0) / Float(255.0) * Float(green),
            blue: Float(1.0) / Float(255.0) * Float(blue),
            alpha: alpha)
    }
}

class MainViewController : UIViewController, CircleMenuDelegate{
@IBOutlet var mainBtn:CircleMenu!
    var movedVC : UIViewController!
    let vcNames = ["resourceViewNV","allocatorViewNV","recordingViewNV","logListViewNV"]
    let items: [(icon: String, color: UIColor)] = [
        ("icon_resource", UIColor(red:0.19, green:0.57, blue:1, alpha:1)),
        ("icon_overload", UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
        ("icon_recording", UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)),
        ("icon_loglist", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
        //("nearby-btn", UIColor(red:1, green:0.39, blue:0, alpha:1)),
        ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainBtn.layer.cornerRadius = mainBtn.bounds.size.height / 2
        mainBtn.layer.borderWidth = 3.0
        mainBtn.layer.borderColor = UIColor.white.cgColor
        mainBtn.backgroundColor = UIColor.white
        mainBtn.clipsToBounds = true
        mainBtn.contentMode = .scaleToFill
        mainBtn.distance = Float(mainBtn.bounds.size.width * 2)

    }

    // MARK: <CircleMenuDelegate>
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        print("hii")
        
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
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: vcNames[atIndex])
        self.movedVC = vc
        
        print(movedVC)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        print(movedVC)
        self.present(self.movedVC,animated: true)
        
    }

}
