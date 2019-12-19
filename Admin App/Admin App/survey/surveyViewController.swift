//
//  surveyViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 29/11/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct Question{
    var id = 0
    var text = ""
    var option1 = ""
    var option2 = ""
    var option3 = ""
    var option4 = ""
    var option5 = ""
    var type = ""
    var QID = ""
    
}

class surveyViewController: UIViewController {
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    var SessionID = ""
    var UID = String()
    
    var ref: DatabaseReference!
    
    var question = Question()
    
    @IBAction func choseEnd(_ sender: Any) {
        endSurvey()
    }
    @IBAction func chose1(_ sender: Any) {
        self.ref.child("Data_Human").child(SessionID).child(UID).child(question.QID).setValue(
        [
            "Time":Int(Date().timeIntervalSince1970),
            "Response": question.option1
        ]
    )
        transit()
    }
    @IBAction func chose2(_ sender: Any) {
        self.ref.child("Data_Human").child(SessionID).child(UID).child(question.QID).setValue(
            [
                "Time":Int(Date().timeIntervalSince1970),
                "Response": question.option2
            ]
        )
        transit()
    }
    @IBAction func chose3(_ sender: Any) {
        self.ref.child("Data_Human").child(SessionID).child(UID).child(question.QID).setValue(
            [
                "Time":Int(Date().timeIntervalSince1970),
                "Response": question.option3
            ]
        )
        transit()
    }
    @IBAction func chose4(_ sender: Any) {
        self.ref.child("Data_Human").child(SessionID).child(UID).child(question.QID).setValue(
            [
                "Time":Int(Date().timeIntervalSince1970),
                "Response": question.option4
            ]
        )
        transit()
    }
    @IBAction func chose5(_ sender: Any) {
        self.ref.child("Data_Human").child(SessionID).child(UID).child(question.QID).setValue(
            [
                "Time":Int(Date().timeIntervalSince1970),
                "Response": question.option5
            ]
        )
        transit()
    }
    
    
    @IBAction func skip(_ sender: Any) {
        transit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UID)
        ref = Database.database().reference()

        bg.layer.cornerRadius = 29
        bg.layer.shadowOffset = .init(width: 0, height: 3)
        bg.layer.shadowOpacity = 0.3
        
        b1.layer.cornerRadius = 29
        b1.layer.shadowOffset = .init(width: 0, height: 3)
        b1.layer.shadowOpacity = 0.3
        
        b2.layer.cornerRadius = 29
        b2.layer.shadowOffset = .init(width: 0, height: 3)
        b2.layer.shadowOpacity = 0.3
        
        b3.layer.cornerRadius = 29
        b3.layer.shadowOffset = .init(width: 0, height: 3)
        b3.layer.shadowOpacity = 0.3
        
        b4.layer.cornerRadius = 29
        b4.layer.shadowOffset = .init(width: 0, height: 3)
        b4.layer.shadowOpacity = 0.3
        
        b5.layer.cornerRadius = 29
        b5.layer.shadowOffset = .init(width: 0, height: 3)
        b5.layer.shadowOpacity = 0.3
        
        skipButton.layer.cornerRadius = 29
        skipButton.layer.shadowOffset = .init(width: 0, height: 3)
        skipButton.layer.shadowOpacity = 0.3
        
        endButton.layer.cornerRadius = 29
        endButton.layer.shadowOffset = .init(width: 0, height: 3)
        endButton.layer.shadowOpacity = 0.3
        
        b1.alpha = 0
        b2.alpha = 0
        b3.alpha = 0
        b4.alpha = 0
        b5.alpha = 0
        skipButton.alpha = 0
        
        fetchData()
        
    }
    
    func fetchData(){
        ref.child("Current_Question_Human").observeSingleEvent(of: .value, with: { (snapshot) in
            self.question.id = snapshot.value as! Int
        
            self.question.QID = "Q" + String(self.question.id)
        
            self.ref.child("Questions").child("short").child(self.question.QID).observeSingleEvent(of: .value, with: { (snapshot) in
                let questionDictionary = snapshot.value as? NSDictionary
                self.question.type = questionDictionary?["Type"] as! String
                self.question.text = questionDictionary?["Question"] as! String
                self.question.option1 = questionDictionary?["1"] as! String
                self.question.option2 = questionDictionary?["2"] as! String
                self.question.option3 = questionDictionary?["3"] as! String
                self.question.option4 = questionDictionary?["4"] as! String
                self.question.option5 = questionDictionary?["5"] as! String
                self.initialise()
            })
        })
    }
    
    func initialise(){
        b1.titleLabel?.text = question.option1
        b2.titleLabel?.text = question.option2
        b3.titleLabel?.text = question.option3
        b4.titleLabel?.text = question.option4
        b5.titleLabel?.text = question.option5
        
        if question.option1 != "e"{b1.alpha = 1}
        if question.option2 != "e"{b2.alpha = 1}
        if question.option3 != "e"{b3.alpha = 1}
        if question.option4 != "e"{b4.alpha = 1}
        if question.option5 != "e"{b5.alpha = 1}
        skipButton.alpha = 1
        questionLabel.text = question.text
        
    }
    
    func transit(){
        if question.id < 42{
            nextQuestion()
        }else{
            endSurvey()
        }
    }
    
    func nextQuestion(){
    self.ref.child("Current_Question_Human").setValue(question.id+1)
        b1.alpha = 0
        b2.alpha = 0
        b3.alpha = 0
        b4.alpha = 0
        b5.alpha = 0
        skipButton.alpha = 0
        endButton.alpha = 0
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "survey") as! surveyViewController
        vc.UID = UID
        vc.SessionID = SessionID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func endSurvey(){

        b1.alpha = 0
        b2.alpha = 0
        b3.alpha = 0
        b4.alpha = 0
        b5.alpha = 0
        skipButton.alpha = 0
        endButton.alpha = 0
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "submit") as! submitViewController
    self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    

    


}
