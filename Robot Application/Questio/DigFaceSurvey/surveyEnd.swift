//
//  File.swift
//  Questio
//
//  Created by Rahul Berry on 27/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SurveyEnd:UIViewController{
    var config = config_data()
    let ref = Database.database().reference()
    
    @IBOutlet weak var surveyID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.config)
        self.surveyID.text = self.config.surveyID
        self.ref.child("Personal_Start").setValue(false)
        self.ref.child("Current_Question").setValue(1)
    }
   
    @IBAction func NextSurveyButton(_ sender: Any) {
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is SurveyHomeScreen {
            self.navigationController?.popToViewController(vc, animated: true)
            break
            }
        }
    }
    @IBAction func RestartSurveyButton(_ sender: Any) {
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is Home {
            self.navigationController?.popToViewController(vc, animated: true)
            break
            }
        }
    }
}
