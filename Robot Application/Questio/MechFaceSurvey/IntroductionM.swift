//
//  Introduction.swift
//  Questio
//
//  Created by Rahul Berry on 05/12/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import AVKit
import Firebase

class IntroductionM:UIViewController{
    
    var player:AVPlayer?
    var config = config_data()
    let ref = Database.database().reference()

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var GreenButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GreenButton.layer.cornerRadius = 45

        ref.child("Hardware_Interface").child("Face_State").setValue("happy")
        ref.child("Hardware_Interface").child("Current_State").setValue("Introduction")
        ref.child("Hardware_Interface").child("Introduction").observe(.value, with: {snapshot in
            if let value = snapshot.value as? String{
                if(value == "Yes"){
                    self.player?.pause()
                    self.exitVC(segueIdentifier: "PrivSegueM")
                    self.ref.child("Hardware_Interface").child("Audio").setValue("End")
                    self.ref.child("Hardware_Interface").child("Face_State").setValue("End")
                }
            }
        })
        
        var videoName = "Guidelines"
        let pathURL = URL.init(fileURLWithPath:  Bundle.main.path(forResource: videoName, ofType: "mp4")!)
        let asset = AVURLAsset(url: pathURL, options: nil)
        let audioDuration = asset.duration
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        ref.child("Hardware_Interface").child("Audio").setValue(Int(audioDurationSeconds)-1)

        player = AVPlayer(playerItem: AVPlayerItem(url: pathURL))
        let playerLayer = AVPlayerLayer(player: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        playerLayer.frame = .init(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height)
        self.videoView.layer.addSublayer(playerLayer)
        player?.play()
    }
    
    func exitVC(segueIdentifier:String){
        ref.child("Hardware_Interface").child("Introduction").setValue("rest")
         self.performSegue(withIdentifier: segueIdentifier, sender: self)
     }
     
     /*Pass data across view controllers*/
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             let vc = segue.destination as! PrivacyM
             vc.config = self.config
     }
     
     @objc func finishVideo(note: NSNotification){
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.5, execute: {
                   self.exitVC(segueIdentifier: "PrivSegueM")
            })
    }
    
     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         NotificationCenter.default.removeObserver(self)
     }
}
