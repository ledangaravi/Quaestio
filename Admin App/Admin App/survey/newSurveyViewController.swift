//
//  newSurveyViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 04/12/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit
import FirebaseDatabase


class newSurveyViewController: UIViewController {
    var SessionID = ""
    var timeStarted = 0
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var surveyCountLabel: UILabel!
    @IBOutlet weak var waitingTimeLabel: UILabel!
    var responses = [Response]()
    @IBOutlet weak var questionCountLabel: UILabel!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        bg.layer.cornerRadius = 20
        bg.layer.shadowOffset = .init(width: 0, height: 3)
        bg.layer.shadowOpacity = 0.3
        
        startButton.layer.cornerRadius = 20
        startButton.layer.shadowOffset = .init(width: 0, height: 3)
        startButton.layer.shadowOpacity = 0.3
        
        endButton.layer.cornerRadius = 20
        endButton.layer.shadowOffset = .init(width: 0, height: 3)
        endButton.layer.shadowOpacity = 0.3

        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm | dd.MM.yyyy"
        timeLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStarted)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("test")
        fetchData()
    }
    @IBAction func endSession(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchData(){
        responses.removeAll()
        ref.child("Data_Human").child(SessionID).observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as? NSDictionary
            let keys = data?.allKeys
            for key in keys!{
                if (key as! String).count > 20{
                    var response = Response()
                    //ALL Survey IDs are in UUID format and have around 35 chars
                    let answers = data?[key] as! [String:Any]
                    response.shortCount = answers.keys.count
                    let qKeys = answers.keys
                    var startTime = 1000000000000000
                    var endtime = 0
                    for qKey in qKeys{
                        let time = (answers[qKey] as! [String: Any])["Time"] as! Int
                        if time < startTime{startTime = time}
                        if time > endtime{endtime = time}
                    }
                    response.startTime = startTime
                    response.endTime = endtime
                    self.responses.append(response)
                }

            }
            self.responses.sort{$0.startTime<$1.startTime}
            var i = 0
            while i < self.responses.count{
                if i == 0{
                    self.responses[i].waitingTime = self.responses[i].startTime - self.timeStarted
                }else{
                    self.responses[i].waitingTime = self.responses[i].startTime - self.responses[i-1].endTime
                }
             i += 1
            }
            
            
            self.initialise()
        })
        
    }
    
    func initialise(){
        surveyCountLabel.text = String(responses.count)
        
        var questionSum = 0
        var waitingSum = 0
        for response in responses{
            questionSum += response.shortCount
            waitingSum += response.waitingTime
        }
        if responses.count != 0{
            questionCountLabel.text = String(Float(questionSum)/Float(responses.count))
        }else{
            questionCountLabel.text = "0"
        }
        
        if responses.count != 0{
            let formatter = DateFormatter()
            formatter.dateFormat = "mm:ss"
            waitingTimeLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(waitingSum/responses.count)))
        }else{
            waitingTimeLabel.text = "0"
        }
        
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as? preSurveyViewController
        vc?.SessionID = self.SessionID
        
    }

}
