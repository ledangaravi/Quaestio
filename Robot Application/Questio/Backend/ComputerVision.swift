import Foundation
import UIKit
import AVFoundation

class ComputerVision:UIViewController {
    
var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamrera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    
    var image : UIImage?
    
    var load_image : UIImage!
    
    let group = DispatchGroup()
    let backGroundqueue = DispatchQueue.global(priority: .default)
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    struct answer: Codable{
        var age: Int
        var gender: String
        var emotion: String
    }
    
    var final_answer =  answer(age:0,gender:"blah",emotion:"blah")

    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInTrueDepthCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
      //  print(devices)
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamrera = frontCamera
    }
    
    
    func setupInputOutput(){
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamrera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
        
    }
    
    
    func startRunningCaptureSession(){
        
        captureSession.startRunning()
        
    }

    func getResults(){
        group.enter()
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        print(photoOutput == nil)
    }
    

}
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

extension ComputerVision: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        struct User: Codable {
            var faceID: String
            var faceRectangle: String
            var faceAttributes: String
        }
        
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data:imageData)
            let newImage = image?.rotate(radians: .pi/(2/3))
            let png_format = newImage?.jpegData(compressionQuality: 0.6)
            load_image = newImage
            let url = URL(string: "https://surveybot12.cognitiveservices.azure.com/face/v1.0/detect?returnFaceAttributes=gender,emotion,age")!
                    var request = URLRequest(url: url)
                    request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
                    request.setValue("240ca093ef6841c287611049c55a06f1", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
                    request.httpMethod = "POST"
                    
                    request.httpBody = png_format
                                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data,
                            let response = response as? HTTPURLResponse,
                            error == nil else {                                              // check for fundamental networking error
                            print("error", error ?? "Unknown error")
                            return
                        }

                        guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                            print("statusCode should be 2xx, but is \(response.statusCode)")
                            print("response = \(response)")
                            let responseString = String(data: data, encoding: .utf8)
                            return
                        }
                        let responseString = String(data: data, encoding: .utf8)
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                            let save = json[safe: 0]
                            
                            
                            if (save == nil) {
                                self.final_answer.age = 0
                                self.final_answer.gender = "No gender"
                                self.final_answer.emotion = "No emotion"
                                
                            } else {
                                let age = (save?["faceAttributes"] as! [String:Any]) ["age"] as! Int
                                let gender = (save?["faceAttributes"] as! [String:Any]) ["gender"] as! String
                                let emotion_dictionary: Dictionary<String,Double> = (save?["faceAttributes"] as! [String:Any]) ["emotion"] as! Dictionary<String, Double>
                                let max_value = emotion_dictionary.max{ a , b  in a.value < b.value }
                                
                                self.final_answer.age = age
                                self.final_answer.gender = gender
                                self.final_answer.emotion = max_value!.key
                            }
                            
                            self.group.leave()
                          //  print("actual answer",self.final_answer)
                        }
                        catch{
                        print("Error")
                        }

                    }

                    task.resume()
            
        }
    
    }
}
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
