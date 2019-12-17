//
//  DeclinedM.swift
//  Questio
//
//  Created by Rahul Berry on 27/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DeclinedM:UIViewController{
    let ref = Database.database().reference()
    var config = config_data()

    @IBOutlet weak var GreenButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.GreenButton.layer.cornerRadius = 102
        ref.child("Hardware_Interface").child("Current_State").setValue("Declined")
            ref.child("Hardware_Interface").child("Declined").observe(.value, with: {snapshot in
                print(snapshot)
                 if let value = snapshot.value as? String{
                    print(value)
                       if (value == "Yes") {
                        self.ref.child("Hardware_Interface").child("Declined").setValue("rest")
                        for vc in (self.navigationController?.viewControllers ?? []) {
                        if vc is SurveyStartM {
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
            }
        })
    }
    
    @IBAction func BackButton(_ sender: Any) {
        for vc in (self.navigationController?.viewControllers ?? []) {
            self.ref.child("Hardware_Interface").child("Current_State").child("Welcome")
                   if vc is SurveyStartM  {
                   self.navigationController?.popToViewController(vc, animated: true)
                   break
             }
        }
    }
}
