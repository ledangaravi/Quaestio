//
//  SetupListViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 11/11/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit
import Firebase

class SetupListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonDelete: UIButton!
    
    var setups = NSDictionary() //unsorted
    var keys_ordered = [String]() //keys of "setups" sorted by date-time created
    
    @IBOutlet weak var setupList: UITableView!
    @IBOutlet weak var detailsView: UIView!
    
    //Setup Details:
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var interfaceLabel: UILabel!
    @IBOutlet weak var dataNoticeLabel: UILabel!
    @IBOutlet weak var hypothesisLabel: UILabel!
    @IBOutlet weak var shortQuestionsLabel: UILabel!
    @IBOutlet weak var personalQuestionsLabel: UILabel!
    @IBOutlet weak var shuffledLabel: UILabel!
    @IBOutlet weak var dataCodeLabel: UILabel!
    @IBOutlet weak var experimentTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    var dbIsEmpty = true
    let ref = Database.database().reference()

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
    var chosenIndex = 0
    
    var chosenConfig = config_data()
    
    @IBAction func deleteButton(_ sender: Any) { //chose configuration
        self.exitVC(segueIdentifier: "SegueToSurveyForm")
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        setupList.layer.cornerRadius = 53
        setupList.layer.borderWidth = 1
        setupList.layer.borderColor = .init(srgbRed: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        setupList.tableFooterView = UIView()

        //Cannot add shadow to UITableView. Todo(If can be arsed): Have it as a subview of a container view with shadow
        setupList.delegate = self
        setupList.dataSource = self
        
        detailsView.layer.cornerRadius = 53
        detailsView.layer.borderWidth = 1
        detailsView.layer.borderColor = .init(srgbRed: 112/255, green: 112/255, blue: 112/255, alpha: 1)
//        detailsView.layer.shadowOffset = .init(width: 0, height: 3)
//        detailsView.layer.shadowOpacity = 0.2
        
        fetchSetups(index: 0)
        keys_ordered = ["init"]
        setups = ["init": ["Title": "Fetching..."]]
        
        interfaceLabel.text = "..."
        dataNoticeLabel.text = "..."
        hypothesisLabel.text = "..."
        shortQuestionsLabel.text = "..."
        personalQuestionsLabel.text = "..."
        shuffledLabel.text = "..."
        dataCodeLabel.text = "..."
        experimentTypeLabel.text = "..."
        
        timeLabel.text = ""
        creatorLabel.text = ""
        
        
        buttonDelete.layer.cornerRadius = 10
        buttonDelete.layer.shadowOffset = .init(width: 0, height: 3)
        buttonDelete.layer.shadowOpacity = 0.5
        
    }
    

    
    func fetchSetups(index: Int) {
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
    ref.child("Configurations").observeSingleEvent(of: .value, with: { (snapshot) in
        let configs = snapshot.value as? NSDictionary
        if (configs != nil){
            self.dbIsEmpty = false
            self.setups = configs!
            
            self.keys_ordered = self.setups.allKeys as! [String]
            self.keys_ordered.sort(by: {(self.setups[$0]! as! [String: Any])[self.key_timeCreated]! as! Int > (self.setups[$1]! as! [String: Any])[self.key_timeCreated]! as! Int})
            self.setupList.reloadData()
            self.setupList.selectRow(at: [0,index], animated: true, scrollPosition: .top)
            self.updateDetails(survey_index: index)
            
        }else{
            self.dbIsEmpty = true
            self.keys_ordered = ["init"]
            self.setups = ["init": ["Title": "No Setup Available"]]
            
            self.interfaceLabel.text = "..."
            self.dataNoticeLabel.text = "..."
            self.hypothesisLabel.text = "..."
            self.shortQuestionsLabel.text = "..."
            self.personalQuestionsLabel.text = "..."
            self.shuffledLabel.text = "..."
            self.dataCodeLabel.text = "..."
            self.experimentTypeLabel.text = "..."
            
            self.timeLabel.text = ""
            self.creatorLabel.text = ""
            self.setupList.reloadData()
            self.setupList.selectRow(at: [0,index], animated: true, scrollPosition: .top)
            self.titleLabel.text = "No Setup Selected"
            
        }
      }) { (error) in
        print(error.localizedDescription)
        }
    }
    
    func updateDetails(survey_index: Int){
        chosenConfig.Title = dbValue(surveyIndex: survey_index, key: key_title) as! String
        chosenConfig.Data_Notice = dbValue(surveyIndex: survey_index, key: key_dataNotice) as! Bool
        chosenConfig.Experiment_Type = dbValue(surveyIndex: survey_index, key: key_experimentType) as! String
        chosenConfig.Face_Type = dbValue(surveyIndex: survey_index, key: key_faceType) as! String
        chosenConfig.Hypothesis = dbValue(surveyIndex: survey_index, key: key_hypothesis) as! String
        chosenConfig.Personal_Limit = dbValue(surveyIndex: survey_index, key: key_personalLimit) as! Int
        chosenConfig.Short_Limit = dbValue(surveyIndex: survey_index, key: key_shortLimit) as! Int
        chosenConfig.Short_Timed = dbValue(surveyIndex: survey_index, key: key_shortTimed) as! Bool
        chosenConfig.shuffled = dbValue(surveyIndex: survey_index, key: key_shuffled) as! Bool
        chosenConfig.Privacy_Code = dbValue(surveyIndex: survey_index, key: key_privacyCode) as! Bool


        titleLabel.text = dbValue(surveyIndex: survey_index, key: key_title) as! String
        
        interfaceLabel.text = dbValue(surveyIndex: survey_index, key: key_faceType) as! String
        
        if dbValue(surveyIndex: survey_index, key: key_dataNotice) as! Bool{
            dataNoticeLabel.text = "Video"
        }else{
            dataNoticeLabel.text = "Tickbox"
        }
        
        hypothesisLabel.text = dbValue(surveyIndex: survey_index, key: key_hypothesis) as! String
        
        if dbValue(surveyIndex: survey_index, key: key_shortTimed) as! Bool{
            shortQuestionsLabel.text = String(dbValue(surveyIndex: survey_index, key: key_shortLimit) as! Int) + "min"
        }else{
            shortQuestionsLabel.text = "x" + String(dbValue(surveyIndex: survey_index, key: key_shortLimit) as! Int)
        }
        
        if dbValue(surveyIndex: survey_index, key: key_personalTimed) as! Bool{
            personalQuestionsLabel.text = String(dbValue(surveyIndex: survey_index, key: key_personalLimit) as! Int) + "min"
        }else{
            personalQuestionsLabel.text = "x" + String(dbValue(surveyIndex: survey_index, key: key_personalLimit) as! Int)
        }
        
        if dbValue(surveyIndex: survey_index, key: key_shuffled) as! Bool{
            shuffledLabel.text = "Yes"
        }else{
            shuffledLabel.text = "No"
        }
        
        if dbValue(surveyIndex: survey_index, key: key_privacyCode) as! Bool{
            dataCodeLabel.text = "Yes"
        }else{
            dataCodeLabel.text = "No"
        }
        
        experimentTypeLabel.text = dbValue(surveyIndex: survey_index, key: key_experimentType) as! String
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy @HH:mm"
        timeLabel.text = "Created on " + formatter.string(from: Date(timeIntervalSince1970: dbValue(surveyIndex: survey_index, key: key_timeCreated) as! Double))

        creatorLabel.text = "By " + (dbValue(surveyIndex: survey_index, key: key_creator) as! String)
    }
    
    func dbValue(surveyIndex:Int, key:String) -> Any{
        return (setups[self.keys_ordered[surveyIndex]] as! [String: Any])[key]!
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  dbValue(surveyIndex: indexPath.row, key: key_title) as! String

        return cell

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView()
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: 375, height: 78))
        header.backgroundColor = .white
        let title = UILabel()
        title.text = "Setups"
        title.textColor = .black
        title.font = UIFont(name: "OpenSans-Extrabold", size: 23)
        title.frame = CGRect(x: 37, y: 41, width: 338, height: 37)
        header.addSubview(title)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenIndex = indexPath.row
        if !dbIsEmpty{
            updateDetails(survey_index: indexPath.row)
        }
    }
    func exitVC(segueIdentifier:String){
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
              
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SurveyDetailsForm
        vc.config = self.chosenConfig
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


