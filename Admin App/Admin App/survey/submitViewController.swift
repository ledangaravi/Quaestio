//
//  submitViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 29/11/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit

class submitViewController: UIViewController {

    @IBAction func submit(_ sender: Any) {

        self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
        
    }
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.cornerRadius = 29
        submitButton.layer.shadowOffset = .init(width: 0, height: 3)
        submitButton.layer.shadowOpacity = 0.3
        
        bg.layer.cornerRadius = 29
        bg.layer.shadowOffset = .init(width: 0, height: 3)
        bg.layer.shadowOpacity = 0.3
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
