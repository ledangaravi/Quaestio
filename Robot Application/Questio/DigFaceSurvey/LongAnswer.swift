//
//  LongAnswer.swift
//  Questio
//
//  Created by Rahul Berry on 18/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//


import UIKit
import Firebase

class LongAnswer:UIViewController{
    
    var config = config_data()
    var word = ""
    let ref = Database.database().reference()
    var qData = questionData()
    var response = ""
    let sr = SpeechProcessing()
    let cv = ComputerVision()
    var repeated = 0

    @IBOutlet weak var Animoji: UIImageView!
    @IBOutlet weak var SkipLabel: UILabel!
    @IBOutlet weak var textSR: UITextView!
    @IBOutlet weak var QuestionLabel: UILabel!
    
    func giveKeyWord(keyWord: String){
        self.word = keyWord
        print("got answer")
       // sr.cancelRecognition()
        self.nextVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.QuestionLabel.text = self.qData.Question
        self.QuestionLabel.center = self.view.center
        self.QuestionLabel = UILabel(frame: CGRect(x: 40, y: 396, width: 1258, height: 330))
        cv.setupCaptureSession()
        cv.setupDevice()
        cv.setupInputOutput()
        cv.startRunningCaptureSession()
        sr.initialize()
        sr.sharedVars(textSR!)
        //sr.begin(keywords: ["Yes","No","Skip"], callBack: giveKeyWord)
        sr.beginLongAnswer(callBack: giveKeyWord)
    }
    
    @IBAction func endButton(_ sender: Any) {
        
    }
    
    @IBAction func nextQ(_ sender: Any) {
            
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
                .setValue(self.textSR.text)
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
            print("THIS IS THE SHORT LIMIT")
            print(self.config.Short_Limit)
            if(self.config.Short_Limit == Int(self.config.Current_Question)){
                self.exitVC(segueIdentifier: "EndSegueLong")
            }
            
    //        else if(((Int(self.config.Current_Question) ?? 0) % 5) != 0){
            self.ref.child("Current_Question").setValue((Int(self.config.Current_Question) ?? 0)+1)
            for vc in (self.navigationController?.viewControllers ?? []) {
                      if vc is Question {
                      self.navigationController?.popToViewController(vc, animated: true)
                      break
                }
           }
    }
        
        /*Pass data across view controllers*/
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                let vc = segue.destination as! SurveyEnd
                vc.config = self.config
            }
}
