import UIKit
import Speech

public class SpeechProcessing: NSObject, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-UK"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var answer = ""
    private var foundAnswer = false
    private var calledBack = false
    @IBOutlet var textView: UITextView!

    public func sharedVars(_ textView: UITextView!) {
        self.textView = textView
    }


    public func initialize() {
        // Configure the SFSpeechRecognizer object already
        // stored in a local member variable.
        speechRecognizer.delegate = self
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    break
                case .denied:
                    break
                case .restricted:
                    break
                case .notDetermined:
                    break
                default:
                    break
                }
            }
        }
    }

    private func listenForAnswer(keywords: Array<String>, callBack: @escaping (_ answer: String) -> ()) throws {
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        self.answer = ""
        self.foundAnswer = false
        // Configure the audio session for the app.

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true

        // Keep speech recognition data on device
        //        if #available(iOS 13, *) {
        //            recognitionRequest.requiresOnDeviceRecognition = false
        //        }

        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        calledBack = false
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {

                // Update the text view with the results.
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                let comparator = " " + result.bestTranscription.formattedString + " "
                for keyword in keywords {
                    if (comparator.localizedCaseInsensitiveContains(" " + keyword + " ")) {
                        self.textView.text = keyword
                        self.answer = keyword
                        self.foundAnswer = true
                        self.recognitionTask?.cancel()
                        self.recognitionTask?.finish()
                        break

                    }

                }

            }

            

            if error != nil || isFinal || self.foundAnswer {

                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.foundAnswer = true
                if (!self.calledBack) {
                    self.calledBack = true
                    callBack(self.answer)
                }
            }
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        // Let the user know to start talking.
        textView.text = "(Go ahead, I'm listening)"
    }


    private func listen(callBack: @escaping (_ answer: String) -> ()) throws {
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        self.answer = ""
        self.foundAnswer = false
        // Configure the audio session for the app.

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        // Keep speech recognition data on device
        //        if #available(iOS 13, *) {
        //            recognitionRequest.requiresOnDeviceRecognition = false
        //        }

        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        self.calledBack = false
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                // Update the text view with the results.
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                let comparator = " " + result.bestTranscription.formattedString + " "
                if (comparator.localizedCaseInsensitiveContains(" Done ")) {
                    self.answer = result.bestTranscription.formattedString
                    self.answer = String(self.answer.dropLast(5))
                    self.textView.text = self.answer
                    self.foundAnswer = true
                    self.recognitionTask?.cancel()
                    self.recognitionTask?.finish()
                }
            }

            

            if error != nil || isFinal || self.foundAnswer {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.foundAnswer = true
                if (!self.calledBack) {
                    self.calledBack = true
                    callBack(self.answer)
                }
            }
        }

        

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        

        audioEngine.prepare()
        try audioEngine.start()

        // Let the user know to start talking.
        textView.text = "(Go ahead, I'm listening)"

    }

    

    public func cancelRecognition() {
        // Stop recognizing speech if there is a problem.
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
    }

    

    public func begin(keywords: Array<String>, callBack: @escaping (_ answer: String) -> ()) {
        textView.text = "Authorized"
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            do {
                try listenForAnswer(keywords: keywords, callBack: callBack)
            } catch {
            }
        }
    }

    public func beginLongAnswer(callBack: @escaping (_ answer: String) -> ()) {
        textView.text = "Authorized"
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            do {
                try listen(callBack: callBack)
            } catch {
            }
        }
    }
}

