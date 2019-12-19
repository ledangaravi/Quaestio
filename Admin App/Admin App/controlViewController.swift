//
//  controlViewController.swift
//  Admin App
//
//  Created by XIN ZHOU on 04/12/2019.
//  Copyright © 2019 Quaestio. All rights reserved.
//

import UIKit
import FirebaseDatabase


class controlViewController: UIViewController {
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var servoSegments: UISegmentedControl!
    @IBOutlet weak var bg2: UIImageView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resetSurveyButton: UIButton!
    @IBOutlet weak var v1: UIButton!
    @IBOutlet weak var v2: UIButton!
    @IBOutlet weak var v3: UIButton!
    @IBOutlet weak var v4: UIButton!
    @IBOutlet weak var v5: UIButton!
    
    @IBOutlet weak var m0: UIButton!
    @IBOutlet weak var m1: UIButton!
    @IBOutlet weak var m2: UIButton!
    @IBOutlet weak var m3: UIButton!
    @IBOutlet weak var m4: UIButton!
    @IBOutlet weak var m5: UIButton!
    @IBOutlet weak var m6: UIButton!
    @IBOutlet weak var m7: UIButton!
    @IBOutlet weak var m8: UIButton!
    
    let unselectedGrey = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    let selectedBlue = UIColor.init(red: 35/255, green: 38/255, blue: 83/255, alpha: 1)
    
    var ref: DatabaseReference!

    
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func style(_ object: AnyObject){
        object.layer.cornerRadius = 29
        object.layer.shadowOffset = .init(width: 0, height: 3)
        object.layer.shadowOpacity = 0.3    }
    
    func styleSmall(_ object: AnyObject){
        object.layer.cornerRadius = 10
        object.layer.shadowOffset = .init(width: 0, height: 3)
        object.layer.shadowOpacity = 0.3    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        style(bg)
        styleSmall(requestButton)
        styleSmall(resetButton)
        styleSmall(resetSurveyButton)
        styleSmall(v1)
        styleSmall(v2)
        styleSmall(v3)
        styleSmall(v4)
        styleSmall(v5)
        styleSmall(m0)
        styleSmall(m1)
        styleSmall(m2)
        styleSmall(m3)
        styleSmall(m4)
        styleSmall(m5)
        styleSmall(m6)
        styleSmall(m7)
        styleSmall(m8)
        
        servoSegments.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
         bg2.layer.zPosition = -1
        
        self.servoSegments.alpha = 0.5
        
        ref.child("Hardware_Interface").child("Face_State").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let state = snapshot.value as! String
            if state == "on"{
                self.servoSegments.selectedSegmentIndex = 0
            }else{
                self.servoSegments.selectedSegmentIndex = 1
            }
            self.servoSegments.alpha = 1
        })
            
    }
    @IBAction func servoChanged(_ sender: Any) {
        var state = "servos_disable"
        if servoSegments.selectedSegmentIndex == 0{
            state = "servos_enable"
        }
        self.ref.child("Hardware_Interface").child("Face_State").setValue(
           state
        )
    }
    
    @IBAction func resetInput(_ sender: Any) {
    self.ref.child("Hardware_Interface").child("Current_State").setValue(
           "Reset"
        )
        resetButton.isEnabled = false
        resetButton.alpha = 0.5
//        resetButton.setTitle("Resetting...", for: .normal)
        
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.resetButton.isEnabled = true
            self.resetButton.alpha = 1.0
            self.ref.child("Hardware_Interface").child("Current_State").setValue(
               "Welcome"
            )
        }


//        resetButton.titleLabel?.text = "Reset"
    
        
    }
    @IBAction func resetSurvey(_ sender: Any) {
         self.ref.child("Reset").setValue(
                   true
                )
                resetSurveyButton.isEnabled = false
                resetSurveyButton.alpha = 0.5
        //        resetButton.setTitle("Resetting...", for: .normal)
                
                let seconds = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.resetSurveyButton.isEnabled = true
                    self.resetSurveyButton.alpha = 1.0
                }
    }
    
    @IBAction func surveyRequest(_ sender: Any) {
        self.ref.child("Approach_Question").setValue(
           "V0"
        )
        requestButton.isEnabled = false
        requestButton.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.requestButton.isEnabled = true
            self.requestButton.alpha = 1.0
        }
    }
    
    @IBAction func v1Pressed(_ sender: Any) {
        self.ref.child("Approach_Question").setValue(
           "V1"
        )
        v1.isEnabled = false
        v1.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.v1.isEnabled = true
            self.v1.alpha = 1.0
        }
    }
    
    @IBAction func v2Pressed(_ sender: Any) {
        self.ref.child("Approach_Question").setValue(
           "V2"
        )
        v2.isEnabled = false
        v2.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.v2.isEnabled = true
            self.v2.alpha = 1.0
        }
    }
    
    @IBAction func v3Pressed(_ sender: Any) {
        self.ref.child("Approach_Question").setValue(
           "V3"
        )
        v3.isEnabled = false
        v3.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.v3.isEnabled = true
            self.v3.alpha = 1.0
        }
    }
    
    @IBAction func v4Pressed(_ sender: Any) {
        self.ref.child("Approach_Question").setValue(
           "V4"
        )
        v4.isEnabled = false
        v4.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.v4.isEnabled = true
            self.v4.alpha = 1.0
        }
    }
    
    
    @IBAction func v5Pressed(_ sender: Any) {
        self.ref.child("Approach_Question").setValue(
           "V5"
        )
        v5.isEnabled = false
        v5.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.v5.isEnabled = true
            self.v5.alpha = 1.0
        }
    }
    
    @IBAction func angry(_ sender: Any) {
        self.ref.child("Hardware_Interface").child("Face_State").setValue(
           "angry"
        )
        m0.isEnabled = false
        m0.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.m0.isEnabled = true
            self.m0.alpha = 1.0
        }
    }
    
    @IBAction func annoyed(_ sender: Any) {
    self.ref.child("Hardware_Interface").child("Face_State").setValue(
           "annoyed"
        )
        m1.isEnabled = false
        m1.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.m1.isEnabled = true
            self.m1.alpha = 1.0
        }
    }
    
    
    @IBAction func flap(_ sender: Any) {
    self.ref.child("Hardware_Interface").child("Face_State").setValue(
           "ears_flapping"
        )
        m2.isEnabled = false
        m2.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.m2.isEnabled = true
            self.m2.alpha = 1.0
        }
    }
    
    @IBAction func flirt(_ sender: Any) {
    self.ref.child("Hardware_Interface").child("Face_State").setValue(
           "flirt"
        )
        m3.isEnabled = false
        m3.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.m3.isEnabled = true
            self.m3.alpha = 1.0
        }
    }
    
    @IBAction func happy(_ sender: Any) {
    self.ref.child("Hardware_Interface").child("Face_State").setValue(
           "happy"
        )
        m4.isEnabled = false
        m4.alpha = 0.5
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.m4.isEnabled = true
            self.m4.alpha = 1.0
        }
    }
    
    @IBAction func sad(_ sender: Any) {
       self.ref.child("Hardware_Interface").child("Face_State").setValue(
              "sad"
           )
           m5.isEnabled = false
           m5.alpha = 0.5
           let seconds = 2.0
           DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
               self.m5.isEnabled = true
               self.m5.alpha = 1.0
           }
       }
    
    @IBAction func surprised(_ sender: Any) {
       self.ref.child("Hardware_Interface").child("Face_State").setValue(
              "surprised"
           )
           m6.isEnabled = false
           m6.alpha = 0.5
           let seconds = 2.0
           DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
               self.m6.isEnabled = true
               self.m6.alpha = 1.0
           }
       }
    
    @IBAction func suspicious(_ sender: Any) {
       self.ref.child("Hardware_Interface").child("Face_State").setValue(
              "suspicious"
           )
           m7.isEnabled = false
           m7.alpha = 0.5
           let seconds = 2.0
           DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
               self.m7.isEnabled = true
               self.m7.alpha = 1.0
           }
       }
    
    @IBAction func wink(_ sender: Any) {
       self.ref.child("Hardware_Interface").child("Face_State").setValue(
              "wink"
           )
           m8.isEnabled = false
           m8.alpha = 0.5
           let seconds = 2.0
           DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
               self.m8.isEnabled = true
               self.m8.alpha = 1.0
           }
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
