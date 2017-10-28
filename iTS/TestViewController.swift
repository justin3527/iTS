//
//  TestViewController.swift
//  iTS
//
//  Created by naver on 2017. 9. 15..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import UIKit

class TestViewController:UIViewController{

    @IBOutlet var lbl : UILabel!
    var css : recordFunc!
    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    var logPath : URL!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        css = recordFunc()
        css.firstStep()
        
        logPath = documentsPath.appendingPathComponent("video")
        
        let a = FileManager.default.fileExists(atPath: (logPath?.path)!)
        print(a)
        if !(a){
            do{
                try FileManager.default.createDirectory(at: logPath!, withIntermediateDirectories:true ,attributes: nil)
            }catch let error as NSError{
                print("can't create directory, error : \(error.description)")
            }
            
        }
    }
    
    @IBAction func start(){
        css.startRecord()
    }
    
    @IBAction func stop(){
        css.stopRecord()
    }
}
