//
//  ViewController2.swift
//  Questio
//
//  Created by Rahul Berry on 03/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import Firebase
import AVKit

class GDPR1: UIViewController {
    
    let ref = Database.database().reference()
    let data = cvData(Mood: "", Age: 0, Gender: "")
    var Face_Type:String = "animoji-vos"
    var uid:String = ""
    var config = config_data()

    
    @IBOutlet weak var Animoji: UIImageView!
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        var videoName = "HowWeUseYourData"
        let pathURL = URL.init(fileURLWithPath:  Bundle.main.path(forResource: videoName, ofType: "mp4")!)
        let player = AVPlayer(playerItem: AVPlayerItem(url: pathURL))
        let playerLayer = AVPlayerLayer(player: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        playerLayer.frame = .init(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height)
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
        //fix state management        
    }
    
    /*Pass data across view controllers*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PrivacyResponse
        vc.config = self.config
    }

    class func postData(){
       // self.ref.child("Data").setValue("Test")
    }
    func exitVC(segueIdentifier:String){
          // self.postData()
           self.performSegue(withIdentifier: segueIdentifier, sender: self)
        
    }

    @objc func finishVideo(note: NSNotification){
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.2, execute: {
               self.exitVC(segueIdentifier: "PrivacyResponse2")
        })
        }
    
    @IBAction func NextButton(_ sender: Any) {
        self.exitVC(segueIdentifier: "PrivacyResponse2")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
