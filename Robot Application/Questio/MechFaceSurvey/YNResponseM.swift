//
//  Question1M.swift
//  Questio
//
//  Created by Rahul Berry on 27/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVFoundation

class YNResponseM:UIViewController{
    var config = config_data()
    var qData = questionData()
    var objPlayer: AVAudioPlayer?
    var response = ""
    
    let cv = ComputerVision()
    let f = functions()    
    let ref = Database.database().reference()

    @IBOutlet weak var RedButton: UIView!
    @IBOutlet weak var GreenButton: UIView!
    @IBOutlet weak var YellowButton: UIView!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var YesLabel: UILabel!
    @IBOutlet weak var NoLabel: UILabel!
    @IBOutlet weak var ExitButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ScreenLoad YN")
        self.ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).setValue("rest")

//        cv.setupCaptureSession()
//        cv.setupDevice()
//        cv.setupInputOutput()
//        cv.startRunningCaptureSession()
        
        self.QuestionLabel.text = self.qData.Question
        self.QuestionLabel.adjustsFontSizeToFitWidth = true
        self.QuestionLabel = UILabel(frame: CGRect(x: 40, y: 396, width: 1258, height: 330))
        
        self.RedButton.layer.cornerRadius = 110
        self.GreenButton.layer.cornerRadius = 110
        self.YellowButton.layer.cornerRadius = 45
        self.ExitButton.layer.cornerRadius = 45
        
        if(self.qData.format == "two"){
            self.YesLabel.text = self.qData.optTwo
            self.NoLabel.text = self.qData.optTwo

        }
        
        ref.child("Hardware_Interface").child("Current_State").setValue("Q"+self.config.Current_Question)
        ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).setValue("rest")

        ref.child("Hardware_Interface").child("Input").setValue("Buttons")
        ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).observe(.value, with: {snapshot in
            print(snapshot)
             if let value = snapshot.value as? String{
                print("test")
                if(value == "Yes"){
                    self.response = self.qData.optOne
                    self.nextVC()
                }
                else if (value == "No") {
                    self.response = self.qData.optTwo
                    self.nextVC()
                }
                else if (value == "Skip") {
                    self.response = "Skip"
                    self.nextVC()
                }
                else if (value == "Exit"){
                    self.exitVC(segueIdentifier: "EndSegueYNM")
                }
            }
    })
}
    func exitVC(segueIdentifier:String){
        self.ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).setValue("rest")
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    
    
    func nextVC(){
        ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).setValue("rest")

//              cv.getResults()
//                    cv.group.notify(queue: .main){
                        self.ref.child("Data")
                            .child(self.config.surveySetID)
                            .child(self.config.surveyID)
                            .child("Q"+self.config.Current_Question).child("Response")
                           .setValue(self.response)
//                         self.ref.child("Data")
//                            .child(self.config.surveySetID)
//                            .child(self.config.surveyID)
//                            .child("Q"+self.config.Current_Question).child("Mood")
//                            .setValue(self.cv.final_answer.emotion)
                        self.ref.child("Data")
                            .child(self.config.surveySetID)
                            .child(self.config.surveyID)
                            .child("Q"+self.config.Current_Question).child("Time")
                            .setValue(Date().timeIntervalSince1970)
                        
//                    }
            print("THIS IS THE SHORT LIMIT")
            print(self.config.Short_Limit)
            if(self.config.Short_Limit == Int(self.config.Current_Question)){
                self.exitVC(segueIdentifier: "EndSegueYNM")
            }else{
        self.ref.child("Current_Question").setValue((Int(self.config.Current_Question) ?? 0)+1)
            for vc in (self.navigationController?.viewControllers ?? []) {
                      if vc is QuestionM {
                      self.navigationController?.popToViewController(vc, animated: true)
                      break
                }
                }
           }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          let vc = segue.destination as! SurveyEndMech
          vc.config = self.config
      }
}

