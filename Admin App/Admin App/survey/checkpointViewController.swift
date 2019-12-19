//
//  checkpointViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 29/11/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit

class checkpointViewController: UIViewController {

    @IBOutlet weak var no: UIButton!
    @IBOutlet weak var yes: UIButton!
    @IBOutlet weak var bg: UIView!
    var UID = String()
    
    @IBAction func yesPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "survey") as! surveyViewController
        vc.UID = UID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func noPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "submit") as! submitViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bg.layer.cornerRadius = 29
        bg.layer.shadowOffset = .init(width: 0, height: 3)
        bg.layer.shadowOpacity = 0.3
        
        yes.layer.cornerRadius = 29
        yes.layer.shadowOffset = .init(width: 0, height: 3)
        yes.layer.shadowOpacity = 0.3
        
        no.layer.cornerRadius = 29
        no.layer.shadowOffset = .init(width: 0, height: 3)
        no.layer.shadowOpacity = 0.3
        
        // Do any additional setup after loading the view.
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
