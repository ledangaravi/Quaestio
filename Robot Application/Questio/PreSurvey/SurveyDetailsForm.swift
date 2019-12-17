//
//  SurveySetupForm.swift
//  Questio
//
//  Created by Rahul Berry on 13/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import Firebase

class SurveyDetailsForm: UIViewController{
    
    let ref = Database.database().reference()
         var config = config_data()

    /*used to set survey ID*/
    func randomString(length: Int) -> String {
        /*Code needs to be added to make sure no 2 IDs are the same*/
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBOutlet weak var NotesBox: UIView!
    @IBOutlet weak var LocationBox: UIView!
    @IBOutlet weak var IDBox: UIView!
    @IBOutlet weak var Duration: UIView!
    @IBOutlet weak var SurveyTitleBox: UIView!
    @IBOutlet weak var StartButtonOutlet: UIButton!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var TitleTB: UITextView!
    @IBOutlet weak var LocationTB: UITextView!
    @IBOutlet weak var DurationTB: UITextView!
    @IBOutlet weak var NotesTB: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.NotesBox.layer.cornerRadius = 50
        self.LocationBox.layer.cornerRadius = 50
        self.SurveyTitleBox.layer.cornerRadius = 50
        self.IDBox.layer.cornerRadius = 50
        self.Duration.layer.cornerRadius = 50
        self.StartButtonOutlet.layer.cornerRadius = 150
        self.config.surveySetID = randomString(length: 10)
        self.IDLabel.text = self.config.surveySetID
    }
    
    func exitVC(segueIdentifier:String){
        self.uploadData()
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    func uploadData(){
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Survey_Conductors").setValue(self.TitleTB.text!)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Location").setValue(self.LocationTB.text!)

        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Data_Notice").setValue(self.config.Data_Notice)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Experiment_Type").setValue(self.config.Experiment_Type)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Face_Type").setValue(self.config.Face_Type)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Hypothesis").setValue(self.config.Hypothesis)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Personal_Limit").setValue(self.config.Personal_Limit)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Personal_Timed").setValue(self.config.Personal_Timed)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Privacy_Code").setValue(self.config.Privacy_Code)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Short_Limit").setValue(self.config.Short_Limit)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Short_Timed").setValue(self.config.Short_Timed)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Title").setValue(self.config.Title)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("shuffled").setValue(self.config.shuffled)
        self.ref.child("Data").child(self.config.surveySetID).child("SurveySetInfo").child("Creation_Time").setValue(Date().timeIntervalSince1970)
    }
              
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(self.config.Face_Type != "M"){
            let vc = segue.destination as! SurveyHomeScreen
            vc.config = self.config
        }
        else{
            let vc = segue.destination as! SurveyStartM
            vc.config = self.config
        }
    }
    @IBAction func StartButton(_ sender: Any) {
        if(self.config.Face_Type == "M"){
            self.exitVC(segueIdentifier:"MechanicalSegue")
        }
        else{
            self.exitVC(segueIdentifier: "SegueToSurvey")
        }
    }
     @IBAction func BackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)      
    }
}


