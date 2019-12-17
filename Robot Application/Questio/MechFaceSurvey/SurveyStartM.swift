//
//  SurveyStartM.swift
//  Questio
//
//  Created by Rahul Berry on 20/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Foundation

class SurveyStartM: UIViewController{
    @IBOutlet weak var GreenButton: UIView!
    @IBOutlet weak var PressLabel: UILabel!
    var stringOne = "Press the green button to start"
    let stringTwo = "green"
    
    var config = config_data()
    let ref = Database.database().reference()
    var objPlayer: AVAudioPlayer?
    var url = Bundle.main.url(forResource: "approachAudio", withExtension: "mp3")
    
    override func viewWillAppear(_ animated: Bool) {
        ref.child("Hardware_Interface").child("Current_State").setValue("Welcome")

    }
    override func viewDidLoad(){
        super.viewDidLoad()
        ref.child("Reset").observe(.value, with: {snapshot in
               if let value = snapshot.value as? Bool{
                   if(value){
                       self.ref.child("Reset").setValue(false)
                       for vc in (self.navigationController?.viewControllers ?? []) {
                           if vc is SurveyStartM {
                               self.navigationController?.popToViewController(vc, animated: true)
                               break
                       }
                   }
               }
           }
           })
        objPlayer?.delegate = self as? AVAudioPlayerDelegate

        let range = (stringOne as NSString).range(of: stringTwo)
        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green , range: range)
        self.PressLabel.attributedText = attributedText
        self.GreenButton.layer.cornerRadius = 110
        
        self.playAudio()
        ref.child("Hardware_Interface").child("Current_State").setValue("Welcome")
        ref.child("Hardware_Interface").child("Welcome").observe(.value, with: {snapshot in
            print(snapshot)
             if let value = snapshot.value as? String{
                print(value)
                if value == "Yes"{
                    self.objPlayer?.pause()
                    self.ref.child("Hardware_Interface").child("Audio").setValue("End")
                    self.ref.child("Hardware_Interface").child("Face_State").setValue("End")
                    self.ref.child("Hardware_Interface").child("Welcome").setValue("rest")
                    self.exitVC(segueIdentifier:"IntroSegueM")
                }
            }
        })
        ref.child("Approach_Question").observe(.value, with: {snapshot in
            print(snapshot)
             if let value = snapshot.value as? String{
                print(value)
                if(value == "V0"){
                    self.url = Bundle.main.url(forResource: "approachAudio", withExtension: "mp3")
                }
                 else  if(value == "V1"){
                    self.url = Bundle.main.url(forResource: "Please-come-back", withExtension: "mp3")
                }
                else if (value == "V2"){
                    self.url = Bundle.main.url(forResource: "Youre-making-me-sad", withExtension: "mp3")

                }
                else if (value == "V3"){
                    self.url = Bundle.main.url(forResource: "Im-going-to-cry-now", withExtension: "mp3")

                }
                else if (value == "V4"){
                    self.url = Bundle.main.url(forResource: "Why?", withExtension: "mp3")

                }
                else if (value == "V5"){
                    self.url = Bundle.main.url(forResource: "approachAudio", withExtension: "mp3")

                }
                self.playAudio()

            }
        })
    }
    
    func playAudio(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            let asset = AVURLAsset(url: self.url!, options: nil)
            let audioDuration = asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            ref.child("Hardware_Interface").child("Audio").setValue(Int(audioDurationSeconds)-1)
        
            // For iOS 11
            objPlayer = try AVAudioPlayer(contentsOf: self.url!, fileTypeHint: AVFileType.mp3.rawValue)
            print("test")

            objPlayer?.play()
            DispatchQueue.main.asyncAfter(deadline:.now() + audioDurationSeconds, execute: {
                self.ref.child("Hardware_Interface").child("Face_State").setValue("R")
            })

        } catch let error {
            print(error.localizedDescription)
        }
    }
    func exitVC(segueIdentifier:String){
           self.performSegue(withIdentifier: segueIdentifier, sender: self)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          let vc = segue.destination as! IntroductionM
          vc.config = self.config
      }
}

