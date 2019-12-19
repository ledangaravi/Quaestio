//
//  startSessionViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 04/12/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class startSessionViewController: UIViewController {
    @IBOutlet weak var conductor: UITextField!
    @IBOutlet weak var conductorView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    var ref: DatabaseReference!
    var SessionID = ""
    var timeStarted = 0

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        conductorView.layer.cornerRadius = 20
        conductorView.layer.shadowOffset = .init(width: 0, height: 3)
        conductorView.layer.shadowOpacity = 0.3
        
        locationView.layer.cornerRadius = 20
        locationView.layer.shadowOffset = .init(width: 0, height: 3)
        locationView.layer.shadowOpacity = 0.3
        
        startButton.layer.cornerRadius = 20
        startButton.layer.shadowOffset = .init(width: 0, height: 3)
        startButton.layer.shadowOpacity = 0.3
        
        location.text = "Business School Entrance"
        SessionID = NSUUID().uuidString
    }
    
    @IBAction func durationChanged(_ sender: Any) {
        durationLabel.text = String(quantDuration(duration: durationSlider.value)) + "min"
    }
    @IBAction func viewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func quantDuration(duration: Float) -> Int{
        return Int(duration) - Int(duration)%10
    }
    
    @IBAction func start(_ sender: Any) {
//        timeStarted = Int(Date().timeIntervalSince1970)
//        writeToDatabase()
    }
    
    func writeToDatabase(){
        self.ref.child("Data_Human").child(SessionID).setValue([
            "conductor": self.conductor.text,
            "duration": 0,
            "location": self.location.text,
            "start_time": self.timeStarted
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as? newSurveyViewController
        if vc != nil{
            timeStarted = Int(Date().timeIntervalSince1970)
            writeToDatabase()
        }
        vc?.SessionID = self.SessionID
        print(timeStarted)
        vc?.timeStarted = self.timeStarted
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
