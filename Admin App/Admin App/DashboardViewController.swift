//
//  DashboardViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 27/11/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase



class DashboardViewController: UIViewController {
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var humanRobot: PieChartView!
    @IBOutlet weak var digitalMechanical: PieChartView!
    @IBOutlet weak var privacy: PieChartView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var ref: DatabaseReference!
    var responses = [Response]()
    var responsesHuman = [Response]()
    var sessionResponses = [Response]()
    
    var humanCount = 0
    var robotCount = 0
    var ponCount = 0
    var poffCount = 0
    var foxCount = 0
    var mechCount = 0
    var sageCount = 0

    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Fetching..."
        ref = Database.database().reference()
        
        fetchData()
        
        bg.layer.cornerRadius = 29
        bg.layer.shadowOffset = .init(width: 0, height: 3)
        bg.layer.shadowOpacity = 0.3
        
        humanRobot.alpha = 0
        digitalMechanical.alpha = 0
        privacy.alpha = 0


    }
    
    func drawCharts(){
        humanRobot.alpha = 1
        digitalMechanical.alpha = 1
        privacy.alpha = 1
        titleLabel.text = "Responses"
        var colors = [NSUIColor]()
        colors.append(.init(red: 119/255, green: 203/255, blue: 185/255, alpha: 1))
        colors.append(.init(red: 35/255, green: 38/255, blue: 83/255, alpha: 1))
        colors.append(.init(red: 35/255, green: 38/255, blue: 83/255, alpha: 1))
        
        var colorsEmpty = [NSUIColor]()
        colorsEmpty.append(.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1))
        //------
        var entries = [ChartDataEntry]()
        if humanCount>0{entries.append(PieChartDataEntry.init(value: Double(humanCount),label: "Human"))}
        if robotCount>0{entries.append(PieChartDataEntry.init(value: Double(robotCount),label: "Robot"))}
        if humanCount == 0 && robotCount == 0{
            entries.append(PieChartDataEntry.init(value: 0.1,label: "No Responses"))
        }
        
        var set = PieChartDataSet(entries: entries, label: "Count of Responses")
        set.drawIconsEnabled = false
        set.sliceSpace = 5
        
        
        
        if humanCount == 0 && robotCount == 0{
            set.colors = colorsEmpty
        }else{
            set.colors = colors
        }
        
        var data = PieChartData()
        data.addDataSet(set)
        var pFormatter = NumberFormatter()
        pFormatter.numberStyle = .decimal
        pFormatter.maximumFractionDigits = 0
        pFormatter.multiplier = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        data.setValueFont(.systemFont(ofSize: 15, weight: .bold))
        data.setValueTextColor(.white)

        humanRobot.legend.font = UIFont(name: "OpenSans-Extrabold", size:15)!
        humanRobot.legend.enabled = false
        humanRobot.data = data
        humanRobot.highlightValues(nil)
        
        //------
        entries = [ChartDataEntry]()
        if mechCount>0{entries.append(PieChartDataEntry.init(value: Double(mechCount),label: "Mech."))}
        if foxCount>0{entries.append(PieChartDataEntry.init(value: Double(foxCount),label: "Fox"))}
        if sageCount>0{entries.append(PieChartDataEntry.init(value: Double(sageCount),label: "Sage"))}
        if mechCount == 0 && foxCount == 0 && sageCount == 0{entries.append(PieChartDataEntry.init(value: 0.1,label: "No Responses"))}

        
        set = PieChartDataSet(entries: entries, label: "Count of Responses")
        set.drawIconsEnabled = false
        set.sliceSpace = 5
        
        if mechCount == 0 && foxCount == 0 && sageCount == 0{
            set.colors = colorsEmpty
        }else{
            set.colors = colors
        }
            
        data = PieChartData()
        data.addDataSet(set)
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        data.setValueFont(.systemFont(ofSize: 15, weight: .bold))
        data.setValueTextColor(.white)

        digitalMechanical.legend.font = UIFont(name: "OpenSans-Extrabold", size:15)!
        digitalMechanical.legend.enabled = false
        digitalMechanical.data = data
        digitalMechanical.highlightValues(nil)
        
        //------
        entries = [ChartDataEntry]()
        if ponCount>0{entries.append(PieChartDataEntry.init(value: Double(ponCount),label: "P. On"))}
        if poffCount>0{entries.append(PieChartDataEntry.init(value: Double(poffCount),label: "P. Off"))}
        if poffCount == 0 && ponCount == 0{entries.append(PieChartDataEntry.init(value: 0.1,label: "No Responses"))}
        
        set = PieChartDataSet(entries: entries, label: "Count of Responses")
        set.drawIconsEnabled = false
        set.sliceSpace = 5
        
        if poffCount == 0 && ponCount == 0{
            set.colors = colorsEmpty
        }else{
            set.colors = colors
        }
        data = PieChartData()
        data.addDataSet(set)
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        data.setValueFont(.systemFont(ofSize: 15, weight: .bold))
        data.setValueTextColor(.white)

        privacy.legend.font = UIFont(name: "OpenSans-Extrabold", size:15)!
        privacy.legend.enabled = false
        privacy.data = data
        privacy.highlightValues(nil)
    }
    
    func fetchData() {
    //        var ref: DatabaseReference!
    //        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let allData = snapshot.value as? NSDictionary
            let expData = allData?["Data"] as? NSDictionary
            if (expData != nil){
                let expKeys = expData?.allKeys as! [String]
                for expKey in expKeys{
                    var surveyKeys = (expData?[expKey] as! [String:Any]).keys
                    for surveyKey in surveyKeys{
                        if surveyKey != "SurveySetInfo"{
                            var response = Response()
                            response.identifier = surveyKey
                            print(surveyKey)
                            response.faceType = ((expData?[expKey] as! [String:Any])["SurveySetInfo"] as! [String:Any])["Face_Type"] as! String
//                            ShortCount:
                            var counterShort = 0
                            var counterPersonal = 0
                            let isPersonal = (((expData?[expKey] as! [String:Any])["SurveySetInfo"] as! [String:Any])["Personal_Limit"] as! Int) > 0
                            /////
                            var startTime = 1000000000000000
                            var endtime = 0
                            //////////
                            
                            for questionKey in ((expData?[expKey] as! [String:Any])[surveyKey] as! [String:Any]).keys{
                                if questionKey.prefix(1) == "Q"{
                                    if isPersonal {counterPersonal += 1}
                                    else {counterShort += 1}
                                    
                                    let time = Int((((expData?[expKey] as! [String:Any])[surveyKey] as! [String:Any])[questionKey] as! [String: Any])["Time"] as! NSNumber)
                                    if time < startTime{startTime = time}
                                    if time > endtime{endtime = time}
                                }
                                
                            }
                            response.shortCount = counterShort
                            response.personalCount = counterPersonal
                            response.privacyEnabled = ((expData?[expKey] as! [String:Any])["SurveySetInfo"] as! [String:Any])["Data_Notice"] as! Bool
                            response.startTime = startTime
                            response.endTime = endtime
                            

                            self.sessionResponses.removeAll()
                            self.sessionResponses.append(response)
                            self.filterValidResponses()
                            self.calculateWaitTime(timeStarted:  Int(((expData?[expKey] as! [String:Any])["SurveySetInfo"] as! [String:Any])["Creation_Time"] as! NSNumber))
                        }
                    }
                }
            }
            
            let humanData = allData?["Data_Human"] as? NSDictionary
            if (humanData != nil){
                let sessionKeys = humanData?.allKeys as! [String]
                for sessionkey in sessionKeys{
                    let sessionData = (allData?["Data_Human"] as! [String:Any])[sessionkey] as! [String:Any]
                    let surveyKeys = sessionData.keys
                    
                    for surveyKey in surveyKeys{
                        if surveyKey.count > 20{
                            let answers = sessionData[surveyKey] as! [String:Any]
                            let qKeys = answers.keys
                            var response = Response()
                            response.identifier = surveyKey
                            response.faceType = "H"
                            response.shortCount = (sessionData[surveyKey] as! [String:Any]).keys.count
                            var startTime = 1000000000000000
                            var endtime = 0
                            for qKey in qKeys{
                                let time = (answers[qKey] as! [String: Any])["Time"] as! Int
                                if time < startTime{startTime = time}
                                if time > endtime{endtime = time}
                            }
                            response.startTime = startTime
                            response.endTime = endtime
                           self.sessionResponses.append(response)
                            self.filterValidResponses()
                            self.calculateWaitTime(timeStarted: sessionData["start_time"] as! Int)
                        }
                    }
                }

            }
            
            if (humanData != nil || expData != nil){
                self.countResponses()
            }
            self.drawCharts()
            self.evaluate()
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func countResponses(){
        for response in responses{
            if response.shortCount>0 && response.personalCount == 0{
                if response.faceType == "F"{
                    foxCount += 1
                }else if response.faceType == "M"{
                    mechCount += 1
                }else if response.faceType == "S"{
                    sageCount += 1
                }
            }
            if response.personalCount>0 {
                if response.privacyEnabled{
                    ponCount += 1
                }else{
                    poffCount += 1
                }
            }
            
            if response.shortCount >= 10 && response.personalCount == 0{
                if response.faceType == "H"{
                    humanCount += 1
                }else{
                    robotCount += 1
                }
            }
            
        }
//        drawCharts()
    }
    
    func filterValidResponses(){
        var i = 0
        while i < self.sessionResponses.count{
            if sessionResponses[i].personalCount < 4 && sessionResponses[i].shortCount < 5{
                sessionResponses.remove(at: i)
            }else{
                i += 1
            }
        }
    }
    
    func calculateWaitTime( timeStarted:Int){
        self.sessionResponses.sort{$0.startTime<$1.startTime}
        var i = 0
        while i < self.sessionResponses.count{
            if i == 0{
                self.sessionResponses[i].waitingTime = self.sessionResponses[i].startTime - timeStarted
            }else{
                self.sessionResponses[i].waitingTime = self.sessionResponses[i].startTime - self.sessionResponses[i-1].endTime
            }
         i += 1
        }
        self.responses.append(contentsOf: self.sessionResponses)
        self.sessionResponses.removeAll()
    }
    
    func evaluate(){
        var waitH1Human = 0
        var waitH1Robot = 0
        var countH1Human = 0
        var countH1Robot = 0
        for response in responses{
            if response.faceType == "H"{
                waitH1Human += response.waitingTime
                countH1Human += 1
            }else if response.personalCount == 0{
                waitH1Robot += response.waitingTime
                countH1Robot += 1
            }
            
        }
        print(waitH1Human/countH1Human)
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
