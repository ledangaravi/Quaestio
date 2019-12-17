//
//  PrivacyPolicy.swift
//  Questio
//
//  Created by Rahul Berry on 13/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation


class PrivacyPolicy: UIViewController {
    var config = config_data()
    @IBOutlet weak var NextButtonOutlet: UIButton!
    @IBOutlet weak var videoView: UIView!
    var player:AVPlayer?
   override func viewDidLoad() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    super.viewDidLoad()
    var videoName = "L5" + self.config.Face_Type
    let pathURL = URL.init(fileURLWithPath:  Bundle.main.path(forResource: videoName, ofType: "mp4")!)
    player = AVPlayer(playerItem: AVPlayerItem(url: pathURL))
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = .init(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height)
    self.videoView.layer.addSublayer(playerLayer)
    player?.play()
    }
    
    func exitVC(segueIdentifier:String){
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
              
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PrivacyResponse
        vc.config = self.config
    }
    
    @IBAction func NextButton(_ sender: Any) {
        player?.pause()
        self.exitVC(segueIdentifier: "PrivacyResponse")
    }

       override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
           NotificationCenter.default.removeObserver(self)
       }
}
