//
//  Question1Response.swift
//  Questio
//
//  Created by Rahul Berry on 17/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class FourScaleResponse:UIViewController{
    let ref = Database.database().reference()
    var config = config_data()
    var qData = questionData()
    var response = ""
    let sr = SpeechProcessing()
    let cv = ComputerVision()
    
    
    @IBOutlet weak var Animoji: UIImageView!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        print(config)
        super.viewDidLoad()
        cv.setupCaptureSession()
        cv.setupDevice()
        cv.setupInputOutput()
        cv.startRunningCaptureSession()
        
        if(self.config.Face_Type == "F"){
            self.Animoji.image = UIImage(named: "animoji-vos")

        }else{
            
        }
        
        self.questionLabel.text = qData.Question
        self.buttonOne.setTitle(qData.optOne, for: .normal)
        self.buttonTwo.setTitle(qData.optTwo, for: .normal)
        self.buttonThree.setTitle(qData.optThree, for: .normal)
        self.buttonFour.setTitle(qData.optFour, for: .normal)
       
        self.buttonOne.layer.cornerRadius = 50
        self.buttonTwo.layer.cornerRadius = 50
        self.buttonThree.layer.cornerRadius = 50
        self.buttonFour.layer.cornerRadius = 50

        self.buttonOne.titleLabel?.adjustsFontSizeToFitWidth = true;
        self.buttonTwo.titleLabel?.adjustsFontSizeToFitWidth = true;
        self.buttonThree.titleLabel?.adjustsFontSizeToFitWidth = true;
        self.buttonFour.titleLabel?.adjustsFontSizeToFitWidth = true;
    }
    
       func exitVC(segueIdentifier:String){
            self.performSegue(withIdentifier: segueIdentifier, sender: self)

    }
        func nextVC(){
            print(self.cv.final_answer)
            print(self.config.Current_Question)
              cv.getResults()
              cv.group.notify(queue: .main){
                self.ref.child("Data")
                    .child(self.config.surveySetID)
                    .child(self.config.surveyID)
                    .child("Q"+self.config.Current_Question).child("Response")
                    .setValue(self.response)
                self.ref.child("Data")
                    .child(self.config.surveySetID)
                    .child(self.config.surveyID)
                    .child("Q"+self.config.Current_Question).child("Mood")
                    .setValue(self.cv.final_answer.emotion)
                self.ref.child("Data")
                    .child(self.config.surveySetID)
                    .child(self.config.surveyID)
                    .child("Q"+self.config.Current_Question).child("Time")
                    .setValue(Date().timeIntervalSince1970)
                    
            }
             if(self.config.Short_Limit == Int(self.config.Current_Question)){
                self.ref.child("Current_Question").setValue(1)
                                   self.exitVC(segueIdentifier: "EndSegue4")
                               }
//            else if(((Int(self.config.Current_Question) ?? 0) % 5) != 0){
                self.ref.child("Current_Question").setValue((Int(self.config.Current_Question) ?? 0)+1)
                    for vc in (self.navigationController?.viewControllers ?? []) {
                          if vc is Question {
                          self.navigationController?.popToViewController(vc, animated: true)
                          break
                    }
                }
//            }
//           
//                    else{
//                        self.exitVC(segueIdentifier: "MoreSegue4")
//                    }
            }
                
                /*Pass data across view controllers*/
                override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                        let vc = segue.destination as! SurveyEnd
                        vc.config = self.config
                    
//                    else{
//                        let vc = segue.destination as! More
//                        vc.config = self.config
//                    }
                }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
    
    @IBAction func buttoneOneAction(_ sender: Any) {
        self.response = self.buttonOne.currentTitle!
              self.nextVC()
    }
    
    @IBAction func buttonTwoAction(_ sender: Any) {
        self.response = self.buttonTwo.currentTitle!
        self.nextVC()
    }
    
    @IBAction func buttonThree(_ sender: Any) {
        self.response = self.buttonThree.currentTitle!
             self.nextVC()
    }
    
    @IBAction func buttonFourAction(_ sender: Any) {
        self.response = self.buttonFour.currentTitle!
             self.nextVC()
        
    }
    @IBAction func exitButton(_ sender: Any) {
        self.response = "End"
        self.exitVC(segueIdentifier: "EndSegue4")
    }
    override func viewDidDisappear(_ animated: Bool) {
          self.dismiss(animated:true, completion: nil)
      }
    @IBAction func skipButton(_ sender: Any) {
        self.response = "Skip"
        self.nextVC()
    }
}
