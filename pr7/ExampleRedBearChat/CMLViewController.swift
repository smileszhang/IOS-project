//
//  CMLViewController.swift
//  ExampleRedBearChat
//
//  Created by smile on 2017/12/6.
//  Copyright © 2017年 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion
import CoreML

class CMLViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var imageMLArray = [UIImage]()
    var nameArray = [String]()
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var upArrow: UILabel!
    @IBOutlet weak var downArrow: UILabel!
    @IBOutlet weak var rightArrow: UILabel!
    
    @IBOutlet weak var startMLbutton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var ringBuffer = RingBuffer()
    let animation = CATransition()
    let motion = CMMotionManager()
    
    let motionOperationQueue = OperationQueue()
    var magValue = 0.1
    var isCalibrating = false
    
    var isWaitingForMotionData = true
    
    var modelRf = RandomForestAccel()
    lazy var bleShield:BLE = (UIApplication.shared.delegate as! AppDelegate).bleShield

    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        // Do any additional setup after loading the view.
        collectionview.layer.borderColor = UIColor.brown.cgColor
        collectionview.layer.borderWidth = 1
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        
        startMotionUpdates()
        stopButton.isEnabled = true
        startMLbutton.isEnabled = false
    }
    @IBAction func stopAction(_ sender: UIButton) {
        self.motion.stopDeviceMotionUpdates()
        startMLbutton.isEnabled = true
    }
    // MARK: Core Motion Updates
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device
        
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 1.0/200
            self.motion.startDeviceMotionUpdates(to: motionOperationQueue, withHandler: self.handleMotion )
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let accel = motionData?.userAcceleration {
            self.ringBuffer.addNewData(xData: accel.x, yData: accel.y, zData: accel.z)
            let mag = fabs(accel.x)+fabs(accel.y)+fabs(accel.z)
            
//            DispatchQueue.main.async{
//                //show magnitude via indicator
//                self.largeMotionMagnitude.progress = Float(mag)/0.2
//            }
//
            if mag > self.magValue {
                // buffer up a bit more data and then notify of occurrence
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                    // something large enough happened to warrant
                    self.largeMotionEventOccurred()
                })
            }
        }
    }
    
    //MARK: Calibration procedure
    func largeMotionEventOccurred(){
        
        if(self.isWaitingForMotionData)
        {
            self.isWaitingForMotionData = false
            //predict a label
            let seq = toMLMultiArray(self.ringBuffer.getDataAsVector())
            guard let outputRf = try? modelRf.prediction(input: seq) else {
                fatalError("Unexpected runtime error.")
            }
            
//            guard let outputSvm = try? modelSvm.prediction(input: seq) else {
//                fatalError("Unexpected runtime error.")
//            }
//
//            guard let outputPipe = try? modelPipe.prediction(input: seq) else {
//                fatalError("Unexpected runtime error.")
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
//                self.resultLabel.text = outputRf.classLabel
//            })
            displayLabelResponse(outputRf.classLabel)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self.collectionview.reloadData()
                
                })
            setDelayedWaitingToTrue(2.0)
            
            //            if(outputRf.classLabel == outputSvm.classLabel){
            //                displayLabelResponse(outputSvm.classLabel)
            //                // dont predict again for a bit
            //                setDelayedWaitingToTrue(2.0)
            //            }
            //            else{
            //                displayLabelResponse("Unknown")
            //                self.isWaitingForMotionData = true
            //            }
            
            
            
        }
    }
    func setDelayedWaitingToTrue(_ time:Double){
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
            self.isWaitingForMotionData = true
        })
    }
    
    func setAsCalibrating(_ label: UILabel){
        label.layer.add(animation, forKey:nil)
        label.backgroundColor = UIColor.red
    }
    
    func setAsNormal(_ label: UILabel){
        label.layer.add(animation, forKey:nil)
        label.backgroundColor = UIColor.black
    }
    
    // convert to ML Multi array
    // https://github.com/akimach/GestureAI-CoreML-iOS/blob/master/GestureAI/GestureViewController.swift
    private func toMLMultiArray(_ arr: [Double]) -> MLMultiArray {
        guard let sequence = try? MLMultiArray(shape:[150], dataType:MLMultiArrayDataType.double) else {
            fatalError("Unexpected runtime error. MLMultiArray could not be created")
        }
        let size = Int(truncating: sequence.shape[0])
        for i in 0..<size {
            sequence[i] = NSNumber(floatLiteral: arr[i])
        }
        return sequence
    }
    
    func displayLabelResponse(_ response:String){
        switch response {
        case "up":
            blinkLabel(upArrow)
            imageMLArray.append(UIImage(named:"9")!)
            nameArray.append("9")
            
            break
        case "down":
            blinkLabel(downArrow)
            imageMLArray.append(UIImage(named:"8")!)
            nameArray.append("8")
            break
        case "right":
            blinkLabel(rightArrow)
            imageMLArray.append(UIImage(named:"7")!)
            nameArray.append("7")
            break
        default:
            print("Unknown")
            break
        }
    }
    
    func blinkLabel(_ label:UILabel){
        DispatchQueue.main.async {
            self.setAsCalibrating(label)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.setAsNormal(label)
            })
        }
        
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        var s = "";
        for str in nameArray{
            s+=str
        }
        let d = s.data(using: String.Encoding.utf8)!
        bleShield.write(d)
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        imageMLArray.removeAll()
        nameArray.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.collectionview.reloadData()
            
        })
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageMLArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath)as! ImageCollectionViewCell
        cell.imgMLImage.image = imageMLArray[indexPath.row]
        return cell
    }
}
