//
//  SetupViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 22/11/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit
import FirebaseDatabase


class SetupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var hypothesisSegments: UISegmentedControl!
    @IBOutlet weak var typeSegments: UISegmentedControl!
    
    @IBOutlet weak var faceView1: UIView!
    
    @IBOutlet weak var faceView3: UIView!
    @IBOutlet weak var faceView2: UIView!
    
    @IBOutlet weak var shuffledSegments: UISegmentedControl!
    @IBOutlet weak var shortTypeSegments: UISegmentedControl!
    
    @IBOutlet weak var personalTypeSegments: UISegmentedControl!
    
    @IBOutlet weak var privacyNoticeSegments: UISegmentedControl!
    
    @IBOutlet weak var privacyCodeSegments: UISegmentedControl!
    @IBOutlet weak var shortSliderLabel: UILabel!
    @IBOutlet weak var personalSliderLabel: UILabel!
    @IBOutlet weak var shortSlider: UISlider!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var creatorTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    let unselectedGrey = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    let selectedBlue = UIColor.init(red: 35/255, green: 38/255, blue: 83/255, alpha: 1)
    
    
    @IBAction func saveButton(_ sender: Any) {
        writeToDatabase()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Database Variables
    var hypothesis = ["H1","H2","H3"]
    var expType = ["Timed","Number of Surveys","Unlimited"]
    var faceType = "M"
    var shortValue = 0
    var personalValue = 0

    
    var ref: DatabaseReference!
    
    //Setup Detail Keys:
    let key_creator = "Creator" //String
    let key_dataNotice = "Data_Notice" //Bool
    let key_experimentDuration = "Experiment_Duration" //Int
    let key_experimentType = "Experiment_Type" //String ("Number of Surveys","Timed","Unlimited Surveys")
    let key_faceType = "Face_Type" //String ("Fox", "Leonard", "Mechanical")
    let key_hypothesis = "Hypothesis" //String ("H1", "H2", "H3")
    let key_personalLimit = "Personal_Limit" //Int
    let key_personalTimed = "Personal_Timed" //Bool (true: Personal_Limit in minutes; false: Personal_Limit in #)
    let key_privacyCode = "Privacy_Code" //Bool
    let key_shortLimit = "Short_Limit" //Int
    let key_shortTimed = "Short_Timed" //Bool (true: Short_Limit in minutes; false: Short_Limit in #)
    let key_timeCreated = "Time_Created" //Int (seconds since 1970)
    let key_title = "Title" //String
    let key_shuffled = "shuffled" //Bool
    
    @IBAction func viewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func titleEdited(_ sender: Any) {
        if titleTextField.text != "" && creatorTextField.text != ""{
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    @IBAction func creatorEdited(_ sender: Any) {
        if titleTextField.text != "" && creatorTextField.text != ""{
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func shortSliderChanged(_ sender: UISlider) {
        self.shortValue = Int(sender.value)
        shortSliderLabel.text = String(self.shortValue)
    }
    
    @IBAction func personalSliderChanged(_ sender: UISlider) {
        self.personalValue = Int(sender.value)
        personalSliderLabel.text = String(self.personalValue)
    }
    
    
    @IBAction func face1Tapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2){
            self.faceView1.backgroundColor = self.selectedBlue
            self.faceView2.backgroundColor = self.unselectedGrey
            self.faceView3.backgroundColor = self.unselectedGrey
        }
        self.faceType = "M"
    }
    
    @IBAction func face2Tapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2){
            self.faceView1.backgroundColor = self.unselectedGrey
            self.faceView2.backgroundColor = self.selectedBlue
            self.faceView3.backgroundColor = self.unselectedGrey
        }
        self.faceType = "F"
        
    }
    
    @IBAction func face3Tapped(_ sender: Any) {
         UIView.animate(withDuration: 0.2){
            self.faceView1.backgroundColor = self.unselectedGrey
            self.faceView2.backgroundColor = self.unselectedGrey
            self.faceView3.backgroundColor = self.selectedBlue
         }
        self.faceType = "S"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        self.titleTextField.delegate = self
        self.creatorTextField.delegate = self

        bgView.layer.cornerRadius = 29
        bgView.layer.shadowOffset = .init(width: 0, height: 3)
        bgView.layer.shadowOpacity = 0.3
        
        faceView1.layer.cornerRadius = 29
        faceView1.backgroundColor = selectedBlue

        
        faceView2.layer.cornerRadius = 29
        faceView2.backgroundColor = unselectedGrey

        
        
        faceView3.layer.cornerRadius = 29
        faceView3.backgroundColor = unselectedGrey

    hypothesisSegments.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

    typeSegments.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    shuffledSegments.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    shortTypeSegments.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    personalTypeSegments.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    privacyNoticeSegments.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    privacyCodeSegments.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    
        
        ref = Database.database().reference()
        
    }
    
    func writeToDatabase(){

        self.ref.child("Configurations").child(NSUUID().uuidString).setValue([
            key_title: titleTextField.text,
            key_creator: creatorTextField.text,
            key_dataNotice: privacyNoticeSegments.selectedSegmentIndex == 0,
            key_experimentType: expType[typeSegments.selectedSegmentIndex],
            key_faceType: faceType,
            key_hypothesis: hypothesis[hypothesisSegments.selectedSegmentIndex],
            key_personalLimit: personalValue,
            key_personalTimed: personalTypeSegments.selectedSegmentIndex == 0,
            key_shortLimit: shortValue,
            key_shortTimed: shortTypeSegments.selectedSegmentIndex == 0,
            key_shuffled: shuffledSegments.selectedSegmentIndex == 0,
            key_privacyCode: privacyCodeSegments.selectedSegmentIndex == 0,
            key_timeCreated: Int(Date().timeIntervalSince1970)
        ])
    }

    


    

}
