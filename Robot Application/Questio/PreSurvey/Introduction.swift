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

class Introduction:UIViewController{
    
    var config = config_data()
    var player: AVPlayer?
    @IBOutlet weak var videoView: UIView!
    
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        var videoName = "Guidelines"
        let pathURL = URL.init(fileURLWithPath:  Bundle.main.path(forResource: videoName, ofType: "mp4")!)
        player = AVPlayer(playerItem: AVPlayerItem(url: pathURL))
        let playerLayer = AVPlayerLayer(player: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        playerLayer.frame = .init(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height)
        self.videoView.layer.addSublayer(playerLayer)
        player?.play()
    }
    func exitVC(segueIdentifier:String){
         self.performSegue(withIdentifier: segueIdentifier, sender: self)
     }
     
     /*Pass data across view controllers*/
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if(self.config.Data_Notice){
                        let vc = segue.destination as! PrivacyResponse
                        vc.config = self.config
                    }else{
                        let vc = segue.destination as! PrivacyPolicy
                        vc.config = self.config
                    }
     }
     
     @objc func finishVideo(note: NSNotification){
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.5, execute: {
                    if(self.config.Data_Notice){
                        self.exitVC(segueIdentifier: "ResponseSegue")
                    }else{
                        self.exitVC(segueIdentifier: "PrivacySegue")
                    }
            })
    
    
    }
    
    @IBAction func nextButton(_ sender: Any) {
        player?.pause()
        if(self.config.Data_Notice){
            self.exitVC(segueIdentifier: "ResponseSegue")
        }else{
            self.exitVC(segueIdentifier: "PrivacySegue")
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         NotificationCenter.default.removeObserver(self)
     }
}
