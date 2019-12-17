//
//  PrivacyDeclined.swift
//  Questio
//
//  Created by Rahul Berry on 15/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit


class PrivacyDeclined:UIViewController{
    var Face_Type = "animoji-vos"
    @IBOutlet weak var Animoji: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Animoji.image = UIImage(named: Face_Type)

        
    }
    @IBAction func ExitButton(_ sender: Any) {
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is SurveyHomeScreen {
                self.navigationController?.popToViewController(vc, animated: true)
            break
            }
        }
    }
}
