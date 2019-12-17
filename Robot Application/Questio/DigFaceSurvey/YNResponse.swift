//
//  Question1Response.swift
//  Questio
//
//  Created by Rahul Berry on 17/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import Firebase

class YNResponse:UIViewController{
    var word = ""
    let ref = Database.database().reference()
    var config = config_data()
    var qData = questionData()
    var response = ""
    let sr = SpeechProcessing()
    let cv = ComputerVision()
    var repeated = 0
    
    func giveKeyWord(keyWord: String){
        self.response = keyWord
        print("got answer " + keyWord)
        print(self.response)
        if (keyWord == "") {
            if (self.repeated < 10) {
                self.repeated = self.repeated + 1
                sr.begin(keywords: ["Yes", "No", "Know", "Skip"], callBack: giveKeyWord)
                return
            }
        }
        self.exitVC(segueIdentifier: "More")
    }
    
    @IBOutlet weak var Animoji: UIImageView!
    @IBOutlet weak var YesButtonOutlet: UIButton!
    @IBOutlet weak var NoButtonOutlet: UIButton!
    @IBOutlet weak var SkipLabel: UILabel!
    @IBOutlet weak var textSR: UITextView!
    @IBOutlet weak var QuestionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.QuestionLabel.text = self.qData.Question
        self.QuestionLabel.center = self.view.center
        self.QuestionLabel = UILabel(frame: CGRect(x: 40, y: 396, width: 1258, height: 330))
        
        print(config)
       
        cv.setupCaptureSession()
        cv.setupDevice()
        cv.setupInputOutput()
        cv.startRunningCaptureSession()
        sr.sharedVars(textSR!)
       // sr.begin(keywords: ["Yes", "No", "Know", "Skip"], callBack: giveKeyWord)
        
        if(self.config.Face_Type == "F"){
            self.Animoji.image = UIImage(named: "animoji-vos")
        }
        else{
            
        }
        self.YesButtonOutlet.layer.cornerRadius = 50
        self.NoButtonOutlet.layer.cornerRadius = 50
        
        if(self.qData.format == "two"){
            self.YesButtonOutlet.setTitle(qData.optOne, for: .normal)
            self.NoButtonOutlet.setTitle(qData.optTwo, for: .normal)
                      
            self.YesButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true;
            self.NoButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true;
        }
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
        print("THIS IS THE SHORT LIMIT")
        print(self.config.Short_Limit)
        if(self.config.Short_Limit == Int(self.config.Current_Question)){
            self.exitVC(segueIdentifier: "EndSegueYN")
        }
        
//        else if(((Int(self.config.Current_Question) ?? 0) % 5) != 0){
        self.ref.child("Current_Question").setValue((Int(self.config.Current_Question) ?? 0)+1)
        for vc in (self.navigationController?.viewControllers ?? []) {
                  if vc is Question {
                  self.navigationController?.popToViewController(vc, animated: true)
                  break
            }
       }
//    }
        
//        else{
//            self.exitVC(segueIdentifier: "MoreSegueYN")
//        }
}
    
    /*Pass data across view controllers*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let vc = segue.destination as! SurveyEnd
            vc.config = self.config
        }
//        else{
//            let vc = segue.destination as! More
//            vc.config = self.config
//        }
    
    
    @IBAction func YesButton(_ sender: Any) {
        self.response = "Yes"
        self.nextVC()
    }
   
    @IBAction func NoButton(_ sender: Any) {
        self.response = "No"
        self.nextVC()
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
    
    @IBAction func SkipButton(_ sender: Any) {
        self.response="Skip"
        self.nextVC()
    }
    
    @IBAction func exitButton(_ sender: Any) {
        self.response = "End"
        self.exitVC(segueIdentifier: "EndSegueYN")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated:true, completion: nil)
    }
}


