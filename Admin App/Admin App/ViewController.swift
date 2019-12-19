//
//  ViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 07/11/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var setupsButton: UIView!
    @IBOutlet weak var newSurveyButton: UIView!
    @IBOutlet weak var dashboardButton: UIView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var surveyButton: UIView!
    @IBOutlet weak var controlButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        

        setupsButton.layer.cornerRadius = 59
        setupsButton.layer.shadowOffset = .init(width: 0, height: 3)
        setupsButton.layer.shadowOpacity = 0.3

        dashboardButton.layer.cornerRadius = 59
        dashboardButton.layer.shadowOffset = .init(width: 0, height: 3)
        dashboardButton.layer.shadowOpacity = 0.3
        
        newSurveyButton.layer.cornerRadius = 59
        newSurveyButton.layer.shadowOffset = .init(width: 0, height: 3)
        newSurveyButton.layer.shadowOpacity = 0.3
        
        surveyButton.layer.cornerRadius = 59
        surveyButton.layer.shadowOffset = .init(width: 0, height: 3)
        surveyButton.layer.shadowOpacity = 0.3
        
        controlButton.layer.cornerRadius = 59
        controlButton.layer.shadowOffset = .init(width: 0, height: 3)
        controlButton.layer.shadowOpacity = 0.3
        
        bg.layer.zPosition = -1
                
    }
    
    


}

