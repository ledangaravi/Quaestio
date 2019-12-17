//
//  Home.swift
//  Questio
//
//  Created by Rahul Berry on 13/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

var setupCheck = 0

class Home: UIViewController{
    @IBOutlet weak var SurveyCountButtonOutlet: UIButton!
    @IBOutlet weak var StartButtonOutlet: UIButton!
    @IBOutlet weak var SurveyLabel: UILabel!
    @IBOutlet weak var CompletedLabel: UILabel!
    @IBOutlet weak var CSContainer: UIView!
    @IBOutlet weak var SetupsOutlet: UIButton!
    @IBOutlet weak var SetupsContainer: UIView!
    @IBOutlet weak var textSR: UITextView!
    @IBOutlet weak var p: UIImageView!
    
    let f = functions()
    let ref = Database.database().reference()
    var cvResults = cvData(Mood: "", Age: 0, Gender: "")
    let cv = ComputerVision()
    let sr = SpeechProcessing()
    
    var word = ""
    func giveKeyWord(keyWord: String){
        self.word = keyWord
        print("got answer")
       // sr.cancelRecognition()
    }
    
override func viewDidLoad() {
        super.viewDidLoad()
    cv.setupCaptureSession()
    cv.setupDevice()
    cv.setupInputOutput()
    cv.startRunningCaptureSession()
        navigationController?.setNavigationBarHidden(true, animated: false)
        sr.initialize()
        //sr.begin(keywords: ["Yes","No","Skip"], callBack: giveKeyWord)
        //sr.beginLongAnswer(callBack: giveKeyWord)
        
        
        
        self.StartButtonOutlet.layer.cornerRadius = 150
        self.SurveyCountButtonOutlet.layer.cornerRadius = 35
        self.CSContainer.layer.cornerRadius = 35
        self.SetupsOutlet.layer.cornerRadius = 35
        self.SetupsContainer.layer.cornerRadius = 35
        let currentDateTime = Date()
        self.SurveyLabel.transform = CGAffineTransform(rotationAngle: 3*CGFloat.pi / 2)
        self.CompletedLabel.transform = CGAffineTransform(rotationAngle: 3*CGFloat.pi / 2)
        print(word)
        
       
    }
       
           
        func exitVC(segueIdentifier:String){
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
        }
           
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        }
           
        @IBAction func SetupsButton(_ sender: Any) {
           
        }
        
        @IBAction func SurveyCountButton(_ sender: Any) {

        }
    
        @IBAction func StartButton(_ sender: Any) {
           // print(self.textSR.text)
            //sr.cancelRecognition()
            self.exitVC(segueIdentifier: "SegueToSetup")
        }
    
        @IBAction func SetupButton(_ sender: Any){
            cv.getResults()
            cv.group.notify(queue: .main){
                print(self.cv.final_answer)
                self.p.image = self.cv.load_image
            }
           // self.exitVC(segueIdentifier: "SetupSegue")
        }
    
        

    }
