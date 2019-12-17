//
//  QuestionM.swift
//  Questio
//
//  Created by Rahul Berry on 04/12/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVKit

class QuestionM:UIViewController{
    let ref = Database.database().reference()
    var config = config_data()
    var questionInfo:[String] = []
    var current_question:String = ""
    var data = ""
    var qData = questionData()
    var qOrder = [""]
    var objPlayer: AVAudioPlayer?
    var skipHandle = false
    var player:AVPlayer?
    var faceStateArray = ["annoyed", "ears_flapping", "flirt", "happy", "sad", "surprised", "suspicious", "wink", "nothing","nothing","nothing","nothing","nothing"]
    var cv = ComputerVision()

    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var GreenButton: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
//        cv.setupCaptureSession()
//        cv.setupDevice()
//        cv.setupInputOutput()
//        cv.startRunningCaptureSession()
//
        self.skipHandle = false
        self.ref.child("Hardware_Interface").child("Current_State").setValue("Question")
        self.ref.child("Current_Question").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
            if let value = snapshot.value as? Int{
            self.config.Current_Question = String(value)
                let pathURL = URL.init(fileURLWithPath:  Bundle.main.path(forResource: "Q"+self.config.Current_Question + "A" , ofType: "mp3")!)
                self.player = AVPlayer(playerItem: AVPlayerItem(url: pathURL))
                let playerLayer = AVPlayerLayer(player: self.player)
                 let asset = AVURLAsset(url: pathURL, options: nil)
                let audioDuration = asset.duration
                let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
                self.ref.child("Hardware_Interface").child("Audio").setValue(Int(audioDurationSeconds)-1)

                    NotificationCenter.default.addObserver(self, selector: #selector(self.finishVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
                self.player?.play()
            let randomInt = Int.random(in: 0..<13)
                   self.ref.child("Hardware_Interface").child("Face_State").setValue(self.faceStateArray[randomInt])
        
//                guard let url = Bundle.main.url(forResource: "Q"+self.config.Current_Question+"A", withExtension: "mp3") else { return }
//
//                do {
//                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//                    try AVAudioSession.sharedInstance().setActive(true)
//                    let asset = AVURLAsset(url: url, options: nil)
//                    let audioDuration = asset.duration
//                    let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
//                    self.ref.child("Hardware_Interface").child("Audio").setValue(Int(audioDurationSeconds))
//
//                    // For iOS 11
//                    self.objPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//                    // For iOS versions < 11
//                    self.objPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//                    self.objPlayer?.play()
//                    DispatchQueue.main.asyncAfter(deadline:.now() + audioDurationSeconds + 1.0, execute: {
//                        print(self.skipHandle)
//                        if(!(self.skipHandle)){
//                        if((self.qData.format == "y/n")||(self.qData.format=="two")){
//                                  self.exitVC(segueIdentifier: "YNSegueM")
//                                }
//                                else if((self.qData.format == "five")||(self.qData.format == "three")||(self.qData.format == "four")){
//                                  self.exitVC(segueIdentifier: "FiveScaleResponseM")
//                                }
//
//                        self.ref.child("Hardware_Interface").child("Face_State").setValue("ears_flapping")
//                        }
//                    })
//
//                } catch let error {
//                    print(error.localizedDescription)
//                }
                
            self.ref.child("Questions").child("short").child("Q"+self.qOrder[Int(self.config.Current_Question)!]).observeSingleEvent(of: .value, with: { snapshot in
                    let questionData = snapshot.value as? NSDictionary
                    self.qData.format = questionData?["Type"] as! String
                    self.qData.Question = questionData?["Question"] as! String
                    self.qData.optOne = questionData?["1"] as! String
                    self.qData.optTwo = questionData?["2"] as! String
                    self.qData.optThree = questionData?["3"] as! String
                    self.qData.optFour = questionData?["4"] as! String
                    self.qData.optFive = questionData?["5"] as! String
                    self.QuestionLabel.text = self.qData.Question
                    self.QuestionLabel.adjustsFontSizeToFitWidth = true
//                    self.QuestionLabel = UILabel(frame: CGRect(x: 40, y: 396, width: 1258, height: 330))
                })
            }
        })
    }
     override func viewDidLoad() {
            super.viewDidLoad()
         self.GreenButton.layer.cornerRadius = 45

        
        ref.child("Hardware_Interface").child("Question").observe(.value, with: {snapshot in
                if let value = snapshot.value as? String{
                    if(value == "Yes"){
                        self.skipHandle = true
                        self.ref.child("Hardware_Interface").child("Audio").setValue("End")
                        self.player?.pause()
                        if((self.qData.format == "y/n")||(self.qData.format=="two")){
                            self.exitVC(segueIdentifier: "YNSegueM")
                    }
                    else if((self.qData.format == "five")||(self.qData.format == "three")||(self.qData.format == "four")){
                            self.exitVC(segueIdentifier: "FiveScaleResponseM")
                    }
                    self.ref.child("Hardware_Interface").child("Question").setValue("rest")
                    }
                }
            })
        }
        
        func exitVC(segueIdentifier:String){
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
        }
           
           /*Pass data across view controllers*/
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print(self.qData)
            ref.child("Hardware_Interface").child("Audio").setValue("End")
            if((self.qData.format == "y/n")||(self.qData.format == "two")){
                let vc = segue.destination as! YNResponseM
                vc.config = self.config
                vc.qData = self.qData
            }
            else if((self.qData.format == "five")||(self.qData.format == "three")||(self.qData.format == "four")){
                let vc = segue.destination as! FiveScaleResponseM
                vc.config = self.config
                vc.qData = self.qData
            }
           
        }
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            NotificationCenter.default.removeObserver(self)
        }
    @objc func finishVideo(note: NSNotification){
      DispatchQueue.main.asyncAfter(deadline:.now() + 1, execute: {
         if((self.qData.format == "y/n")||(self.qData.format=="two")){
                    self.exitVC(segueIdentifier: "YNSegueM")
         }
        else if((self.qData.format == "five")||(self.qData.format == "three")||(self.qData.format == "four")){
            self.exitVC(segueIdentifier: "FiveScaleResponseM")
        }
       

        })
      }
    }
        
