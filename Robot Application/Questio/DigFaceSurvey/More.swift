//
//  Motr.swift
//  Questio
//
//  Created by Rahul Berry on 30/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class More:UIViewController{
    var config = config_data()
    let ref = Database.database().reference()

    @IBOutlet weak var YesButtonOutlet: UIButton!
    @IBOutlet weak var NoButtonOutlet: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.YesButtonOutlet.layer.cornerRadius = 50
        self.NoButtonOutlet.layer.cornerRadius = 50
    }
    
     func exitVC(segueIdentifier:String){
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let vc = segue.destination as! SurveyEnd
           vc.config = self.config
       }
    
    @IBAction func YesButton(_ sender: Any) {
        self.ref.child("Current_Question").setValue((Int(self.config.Current_Question) ?? 0)+1)
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is Question {
                self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    @IBAction func NoButton(_ sender: Any) {
        self.ref.child("Current_Question").setValue(1)
        self.exitVC(segueIdentifier: "SurveyEndSegue")
    }
}

