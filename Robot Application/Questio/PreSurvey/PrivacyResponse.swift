//
//  PrivacyResponse.swift
//  Questio
//
//  Created by Rahul Berry on 15/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import Firebase

class PrivacyResponse:UIViewController{
    @IBOutlet weak var DeclineButtonOutlet: UIButton!
    @IBOutlet weak var AcceptButtonOutlet: UIButton!
    @IBOutlet weak var Animoji: UIImageView!
    
    var uid = ""
    var AcceptPressed = false
    var config = config_data()
    var qOrder = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42"]

    let ref = Database.database().reference()
    let cv = ComputerVision()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cv.setupCaptureSession()
        cv.setupDevice()
        cv.setupInputOutput()
        cv.startRunningCaptureSession()
        if(self.config.Face_Type == "F"){
            self.Animoji.image = UIImage(named: "animoji-vos")
        }
        else{
            //setup
        }
        self.AcceptButtonOutlet.layer.cornerRadius = 55
        self.DeclineButtonOutlet.layer.cornerRadius = 55
    }
    
    func randomString(length: Int) -> String {
         let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
         return String((0..<length).map{ _ in letters.randomElement()! })
       }
    
    func exitVC(segueIdentifier:String){
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
                 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(self.AcceptPressed){
            self.config.surveyID = self.randomString(length: 6)
            let vc = segue.destination as! Question
            vc.config = self.config
            vc.qOrder = self.qOrder
        }
    }
    
    @IBAction func DeclineButton(_ sender: Any) {
        self.exitVC(segueIdentifier: "DeclinedSegue")
    }
     @IBAction func AcceptButton(_ sender: Any) {
        /*Set user ID & transition*/
        self.AcceptPressed = true
        self.ref.child("Current_Question").setValue(1)

        if(self.config.shuffled){
            self.qOrder.shuffle()
        }
        self.exitVC(segueIdentifier: "StartSurvey")
        cv.getResults()
        cv.group.notify(queue: .main){
            print(self.cv.final_answer)
       self.ref.child("Data").child(self.config.surveySetID).child(self.config.surveyID).child("Age").setValue(self.cv.final_answer.age)
        print(self.config)
        self.ref.child("Data").child(self.config.surveySetID).child(self.config.surveyID).child("Mood_Start").setValue(self.cv.final_answer.emotion)
        self.ref.child("Data").child(self.config.surveySetID).child(self.config.surveyID).child("Gender").setValue(self.cv.final_answer.gender)
        }
      
    }
}
