//
//  privacyViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 02/12/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit

class privacyViewController: UIViewController {
    
    var UID = String()
    var SessionID = ""

    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var qr: UIView!
    @IBOutlet weak var declineButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        qr.layer.cornerRadius = 29
        qr.layer.shadowOffset = .init(width: 0, height: 3)
        qr.layer.shadowOpacity = 0.3
        
    acceptButton.layer.cornerRadius = 29
    acceptButton.layer.shadowOffset = .init(width: 0, height: 3)
    acceptButton.layer.shadowOpacity = 0.3
    
    declineButton.layer.cornerRadius = 29
    declineButton.layer.shadowOffset = .init(width: 0, height: 3)
    declineButton.layer.shadowOpacity = 0.3
    }
    
    @IBAction func decline(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        (segue.destination as? surveyViewController)?.UID = NSUUID().uuidString
        (segue.destination as? surveyViewController)?.SessionID = self.SessionID
    }
}
