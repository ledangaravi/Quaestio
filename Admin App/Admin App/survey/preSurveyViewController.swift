//
//  preSurveyViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 29/11/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class preSurveyViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var bg: UIView!
    var ref: DatabaseReference!
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var bg3: UIView!
    var SessionID = ""
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        bg.layer.cornerRadius = 29
        bg.layer.shadowOffset = .init(width: 0, height: 3)
        bg.layer.shadowOpacity = 0.3
        
        bg2.layer.cornerRadius = 29
        bg2.layer.shadowOffset = .init(width: 0, height: 3)
        bg2.layer.shadowOpacity = 0.3
        
        bg3.layer.cornerRadius = 29
        bg3.layer.shadowOffset = .init(width: 0, height: 3)
        bg3.layer.shadowOpacity = 0.3
        
        startButton.layer.cornerRadius = 29
        startButton.layer.shadowOffset = .init(width: 0, height: 3)
        startButton.layer.shadowOpacity = 0.3
        self.ref.child("Current_Question_Human").setValue(1)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        (segue.destination as? privacyViewController)?.UID = NSUUID().uuidString
        (segue.destination as? privacyViewController)?.SessionID = self.SessionID
    }


}
