////
////  RecordingViewController.swift
////  iTS
////
////  Created by naver on 2017. 9. 19..
////  Copyright © 2017년 xindawn. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class RecordingViewController : UIViewController{
//
//    @IBOutlet var playBtn : UIButton!
//    @IBOutlet var stopBtn : UIButton!
//    @IBOutlet var timeLabel : UILabel!
//
//    let common = Common()
//    let saveResourceLog = SaveResourceLog()
//    var fileName = ""
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        stopBtn.isEnabled = false
//    }
//
//    @IBAction func playResourceRecordLog(){
//
//        let alert = UIAlertController(title: "Input Log File Name", message: "Input Log File Name", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addTextField(configurationHandler: {(tf) in
//            tf.placeholder = "FileName"
//        })
//
//
//        let okBtn = UIAlertAction(title: "Start", style: .default){
//            (_) in
//            self.fileName = (alert.textFields?[0].text)!
//            self.playBtn.isEnabled = false
//            self.stopBtn.isEnabled = true
//
//            self.common.startTimer(time: 1, target: self, selector: #selector(self.recordingLog))
//            self.saveResourceLog.startRecord()
//        }
//        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
//
//        alert.addAction(okBtn)
//        alert.addAction(cancelBtn)
//
//        self.present(alert, animated: true)
//
//    }
//
//    @IBAction func stopResourceRecordLog(){
//        playBtn.isEnabled = true
//        stopBtn.isEnabled = false
//        common.stopTimer()
//        saveResourceLog.resetRecordTime()
//        self.timeLabel.text = saveResourceLog.getRunningTime()
//        saveResourceLog.saveLogToCSV(fileName : self.fileName)
//    }
//
//    func recordingLog(){
//        saveResourceLog.recording()
//        self.timeLabel.text = saveResourceLog.getRunningTime()
//    }
//
//    @IBAction func backToMain(){
//        self.dismiss(animated: true, completion: nil)
//    }
//}

