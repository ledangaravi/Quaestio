import UIKit
import Firebase
import AVFoundation

class PrivacyM:UIViewController{
    var config = config_data()
    var objPlayer: AVAudioPlayer?
    let cv = ComputerVision()
    var qOrder = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42"]

    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    var AcceptPressed = false
    let ref = Database.database().reference()
    @IBOutlet weak var RedButton: UIView!
    @IBOutlet weak var GreenButton: UIView!

    override func viewDidAppear(_ animated: Bool) {
        self.AcceptPressed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AcceptPressed = false
//        cv.setupCaptureSession()
//        cv.setupDevice()
//        cv.setupInputOutput()
//        cv.startRunningCaptureSession()
//
        self.RedButton.layer.cornerRadius = 102
        self.GreenButton.layer.cornerRadius = 102

        guard let url = Bundle.main.url(forResource: "L1A", withExtension: "mp3") else { return }
        ref.child("Hardware_Interface").child("Face_State").setValue("suspicious")
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            let asset = AVURLAsset(url: url, options: nil)
            let audioDuration = asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            ref.child("Hardware_Interface").child("Audio").setValue(Int(audioDurationSeconds)-1)
            // For iOS 11
            objPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            // For iOS versions < 11
            objPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let aPlayer = objPlayer else { return }
            aPlayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
        
        ref.child("Hardware_Interface").child("Current_State").setValue("Privacy")
        ref.child("Hardware_Interface").child("Privacy").observe(.value, with: {snapshot in
            print(snapshot)
             if let value = snapshot.value as? String{
                print(value)
                if(value == "No"){
                    self.objPlayer?.pause()
                    self.ref.child("Hardware_Interface").child("Privacy").setValue("rest")
                    self.exitVC(segueIdentifier:"DeclinedM")
                }
                else if (value == "Yes") {
                    self.objPlayer?.pause()
                    self.AcceptPressed = true
                    self.ref.child("Hardware_Interface").child("Privacy").setValue("rest")
                    self.config.surveyID = self.randomString(length: 6)
                    //cv.getResults()
                    //cv.group.notify(queue: DispatchQueue.main){
                    // self.config.surveyID = self.randomString(length: 6)
                    // print(self.cv.final_answer)
                    // self.ref.child("Data").child(self.config.surveySetID).child(self.config.surveyID).child("Age").setValue(self.cv.final_answer.age)
                    //         self.ref.child("Data").child(self.config.surveySetID).child(self.config.surveyID).child("Mood_Start").setValue(self.cv.final_answer.emotion)
                    //            self.ref.child("Data").child(self.config.surveySetID).child(self.config.surveyID).child("Gender").setValue(self.cv.final_answer.gender)
                    self.exitVC(segueIdentifier:"PrivOutSegueM")
                }
            }
    })
}
    
    func exitVC(segueIdentifier:String){
        self.ref.child("Current_Question").setValue(1)
        self.ref.child("Hardware_Interface").child("Audio").setValue("End")
        self.ref.child("Hardware_Interface").child("Face_State").setValue("End")
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(self.AcceptPressed){
            let vc = segue.destination as! QuestionM
            vc.config = self.config
            vc.qOrder = self.qOrder
            self.AcceptPressed = false
        }
        else{
            let vc = segue.destination as! DeclinedM
            vc.config = self.config
        }
      }
}
