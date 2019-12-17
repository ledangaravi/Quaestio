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

class FiveScaleResponseM:UIViewController{
    var config = config_data()
    var objPlayer: AVAudioPlayer?
    var qData = questionData()

    @IBOutlet weak var Label1: UIView!
    @IBOutlet weak var Label2: UIView!
    @IBOutlet weak var Label3: UIView!
    @IBOutlet weak var Label4: UIView!
    @IBOutlet weak var Label5: UIView!
    @IBOutlet weak var GreenButton: UIView!
    
    @IBOutlet weak var L2Value: UILabel!
    @IBOutlet weak var L1Value: UILabel!
    @IBOutlet weak var L3Value: UILabel!
    @IBOutlet weak var L4Value: UILabel!
    @IBOutlet weak var L5Value: UILabel!
    
    @IBOutlet weak var QuestionLabel: UILabel!
    
    
    
    let f = functions()
    let ref = Database.database().reference()
    var sliderAnswer = ""
    
    let cv = ComputerVision()
    @IBOutlet weak var ExitButton: UIView!
    
    override func viewDidLoad() {
        print("ScreenLoad 5")

        self.ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).setValue("rest")

        self.Label1.layer.cornerRadius = 45
        self.Label2.layer.cornerRadius = 45
        self.Label3.layer.cornerRadius = 45
        self.Label4.layer.cornerRadius = 45
        self.Label5.layer.cornerRadius = 45

//        cv.setupCaptureSession()
//        cv.setupDevice()
//        cv.setupInputOutput()
//        cv.startRunningCaptureSession()
        
        super.viewDidLoad()
        self.GreenButton.layer.cornerRadius = 45
        self.ExitButton.layer.cornerRadius = 45

        self.L1Value.text = self.qData.optOne
        self.L2Value.text = self.qData.optTwo
        self.L3Value.text = self.qData.optThree
        self.L4Value.text = self.qData.optFour
        self.L5Value.text = self.qData.optFive

        self.L1Value.adjustsFontSizeToFitWidth = true
        self.L2Value.adjustsFontSizeToFitWidth = true
        self.L3Value.adjustsFontSizeToFitWidth = true
        self.L4Value.adjustsFontSizeToFitWidth = true
        self.L5Value.adjustsFontSizeToFitWidth = true

        self.QuestionLabel.text = self.qData.Question
        self.QuestionLabel.adjustsFontSizeToFitWidth = true

        if(self.qData.format == "three"){
            self.Label2.isHidden = true
            self.Label4.isHidden = true
            self.L2Value.isHidden = true
            self.L4Value.isHidden = true
            
            self.L3Value.text = self.qData.optTwo
            self.L5Value.text = self.qData.optThree
        }
            
        else if(self.qData.format == "four"){
            self.Label3.isHidden = true
            self.L3Value.isHidden = true
            
            self.L4Value.text = self.qData.optThree
            self.L5Value.text = self.qData.optFour
        }
        
        ref.child("Hardware_Interface").child("Current_State").setValue("Q"+self.config.Current_Question)
        ref.child("Hardware_Interface").child("Input").setValue("Slider")
        ref.child("Hardware_Interface").child("Current_Slider_Value").observe(.value, with: {snapshot in
        if let value = snapshot.value as? String{
            
            print(value)
            if(value=="1"){
                self.Label1.layer.backgroundColor = UIColor(red: 119/255, green: 203/255, blue: 185/255, alpha: 1.0).cgColor
                self.Label2.backgroundColor = .white
                self.Label3.backgroundColor = .white
                self.Label4.backgroundColor = .white
                self.Label5.backgroundColor = .white
                self.sliderAnswer = "1"
            }
            if(value=="2"){
                self.Label2.layer.backgroundColor = UIColor(red: 119/255, green: 203/255, blue: 185/255, alpha: 1.0).cgColor
                self.Label1.backgroundColor = .white
                self.Label3.backgroundColor = .white
                self.Label4.backgroundColor = .white
                self.Label5.backgroundColor = .white
                self.sliderAnswer = "2"
            }
            if(value=="3"){
                self.Label3.layer.backgroundColor = UIColor(red: 119/255, green: 203/255, blue: 185/255, alpha: 1.0).cgColor
                self.Label2.backgroundColor = .white
                self.Label1.backgroundColor = .white
                self.Label4.backgroundColor = .white
                self.Label5.backgroundColor = .white
                self.sliderAnswer = "3"
            }
            if(value=="4"){
                self.Label4.layer.backgroundColor = UIColor(red: 119/255, green: 203/255, blue: 185/255, alpha: 1.0).cgColor
                self.Label2.backgroundColor = .white
                self.Label3.backgroundColor = .white
                self.Label1.backgroundColor = .white
                self.Label5.backgroundColor = .white
                self.sliderAnswer = "4"
            }
            if(value=="5"){
                self.Label5.layer.backgroundColor = UIColor(red: 119/255, green: 203/255, blue: 185/255, alpha: 1.0).cgColor
                self.Label2.backgroundColor = .white
                self.Label3.backgroundColor = .white
                self.Label4.backgroundColor = .white
                self.Label1.backgroundColor = .white
                self.sliderAnswer = "5"
                }
            else if (value == "rest"){
                self.Label1.backgroundColor = .white
                self.Label2.backgroundColor = .white
                self.Label3.backgroundColor = .white
                self.Label4.backgroundColor = .white
                self.Label5.backgroundColor = .white
                }
            }
       
        })
        
        
        ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).observe(.value, with: {snapshot in
            print(snapshot)
             if let value = snapshot.value as? String{
                print("test")
                if(value == "Yes"){
                    print(self.config.surveySetID)
                    self.ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).setValue("rest")
                    self.nextVC()
                }
                
                else if (value == "Skip") {
                self.ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).setValue("rest")
                    self.sliderAnswer = "Skip"
                    self.nextVC()
                }
                else if (value == "Exit"){
                    self.ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).setValue("rest")
                    self.exitVC(segueIdentifier: "EndSegue5M")
                }
            }
    })
}
    
      func exitVC(segueIdentifier:String){
             self.performSegue(withIdentifier: segueIdentifier, sender: self)
             }
         
         
         func nextVC(){
             ref.child("Hardware_Interface").child("Q"+self.config.Current_Question).setValue("rest")

     //              cv.getResults()
     //               cv.group.notify(queue: .main){
                self.ref.child("Data")
                    .child(self.config.surveySetID)
                    .child(self.config.surveyID)
                    .child("Q"+self.config.Current_Question).child("Response")
                    .setValue(self.sliderAnswer)
     //                        self.ref.child("Data")
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
                     self.ref.child("Current_Question").setValue(1)
                     self.exitVC(segueIdentifier: "EndSegue5M")
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
