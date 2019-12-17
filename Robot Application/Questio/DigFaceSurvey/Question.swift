//
//  Question1.swift
//  Questio
//
//  Created by Rahul Berry on 17/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit

class Question:UIViewController{
    let ref = Database.database().reference()
    var config = config_data()
    var questionInfo:[String] = []
    var current_question:String = ""
    var data = ""
    var qData = questionData()
    var qOrder = [""]
    var vidType = "Q"
    var firType = "short"
    var personal = ""
    var player:AVPlayer?
    var skipHandle = false
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.skipHandle = false
        if(self.personal == "true"){
        if(self.config.Personal_Limit != 0){
            if(self.config.Current_Question == "4"){
                self.config.Short_Limit = self.config.Personal_Limit
                self.ref.child("Current_Question").setValue(1)
                self.vidType = "QP"
                self.personal = "false"
            }
        }
        }
        
    self.ref.child("Current_Question").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
            if let value = snapshot.value as? Int{
            self.config.Current_Question = String(value)
                
                let pathURL = URL.init(fileURLWithPath:  Bundle.main.path(forResource: self.vidType + self.qOrder[value] + self.config.Face_Type, ofType: "mp4")!)
                self.player = AVPlayer(playerItem: AVPlayerItem(url: pathURL))
                let playerLayer = AVPlayerLayer(player: self.player)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.finishVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
                    playerLayer.frame = .init(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height)
                    self.videoView.layer.addSublayer(playerLayer)
                self.player?.play()
                  }
            
            if(self.vidType == "QP"){
                self.firType = "personal"
            }
            self.ref.child("Questions").child(self.firType).child(self.vidType+self.qOrder[Int(self.config.Current_Question)!]).observeSingleEvent(of: .value, with: { snapshot in
                    let questionData = snapshot.value as? NSDictionary
                    self.qData.format = questionData?["Type"] as! String
                    self.qData.Question = questionData?["Question"] as! String
                    self.qData.optOne = questionData?["1"] as! String
                    self.qData.optTwo = questionData?["2"] as! String
                    self.qData.optThree = questionData?["3"] as! String
                    self.qData.optFour = questionData?["4"] as! String
                    self.qData.optFive = questionData?["5"] as! String
                    print(self.qData)
                    self.questionLabel.text = self.qData.Question
                    self.questionLabel.adjustsFontSizeToFitWidth = true
//                    self.questionLabel = UILabel(frame: CGRect(x: 40, y: 396, width: 1258, height: 330))
            }
            )
       
        })
    }
    
    @IBAction func nextButton(_ sender: Any) {
        player?.pause()
        self.skipHandle = true
        if((self.qData.format == "y/n")||(self.qData.format=="two")){
                self.exitVC(segueIdentifier: "YNSegue")
              }
              else if(self.qData.format == "five"){
                self.exitVC(segueIdentifier: "FiveScaleSegue")
              }
              else if(self.qData.format == "four"){
                self.exitVC(segueIdentifier: "FourScaleSegue")
                }
              else if(self.qData.format == "three"){
                self.exitVC(segueIdentifier: "ThreeScaleSegue")
                }
                else if(self.qData.format == "long"){
                self.exitVC(segueIdentifier: "LongSegue")
                }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.personal = "true"
        
    }
    
    func exitVC(segueIdentifier:String){
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
       
       /*Pass data across view controllers*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.qData)
        if((self.qData.format == "y/n")||(self.qData.format == "two")){
            let vc = segue.destination as! YNResponse
            vc.config = self.config
            vc.qData = self.qData
        }
        else if(self.qData.format == "five"){
            let vc = segue.destination as! FiveScaleResponse
            vc.config = self.config
            vc.qData = self.qData
        }
        else if(self.qData.format == "four"){
            let vc = segue.destination as! FourScaleResponse
            vc.config = self.config
            vc.qData = self.qData
        }
        else if(self.qData.format == "three"){
            let vc = segue.destination as! ThreeScaleResponse
            vc.config = self.config
            vc.qData = self.qData
        }
        else if(self.qData.format == "long"){
            let vc = segue.destination as! LongAnswer
            vc.config = self.config
            vc.qData = self.qData
        }
    }
        
       
    
    @objc func finishVideo(note: NSNotification){
        DispatchQueue.main.asyncAfter(deadline:.now() + 1, execute: {
            if((self.qData.format == "y/n")||(self.qData.format=="two")){
            self.exitVC(segueIdentifier: "YNSegue")
          }
          else if(self.qData.format == "five"){
            self.exitVC(segueIdentifier: "FiveScaleSegue")
          }
          else if(self.qData.format == "four"){
            self.exitVC(segueIdentifier: "FourScaleSegue")
            }
          else if(self.qData.format == "three"){
            self.exitVC(segueIdentifier: "ThreeScaleSegue")
            }
            else if(self.qData.format == "long"){
            self.exitVC(segueIdentifier: "LongSegue")
            }
        })
      }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player?.replaceCurrentItem(with: nil)
        NotificationCenter.default.removeObserver(self)
    }
}
