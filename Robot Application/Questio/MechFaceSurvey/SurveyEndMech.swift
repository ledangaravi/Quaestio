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

class SurveyEndMech:UIViewController{
    var config = config_data()
    let ref = Database.database().reference()
    
    @IBOutlet weak var surveyID: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref.child("Current_Question").setValue(1)
        self.ref.child("Hardware_Interface").child("Current_State").setValue("End Screen")
        self.ref.child("Hardware_Interface").child("Face_State").setValue("celebrate")
        self.surveyID.text = self.config.surveyID
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        for vc in (self.navigationController?.viewControllers ?? []) {
            print(vc)
                   if vc is SurveyStartM {
                   self.navigationController?.popToViewController(vc, animated: true)
                   break
                }
    }
    }
    
       
        
    @IBAction func Home(_ sender: Any) {
        for vc in (self.navigationController?.viewControllers ?? []) {
                   if vc is Home {
                    ref.child("Hardware_Interface").child("Current_State").setValue("Welcome")
                   self.navigationController?.popToViewController(vc, animated: true)
                   break
                   }
               }
           
    }
    
       
}
