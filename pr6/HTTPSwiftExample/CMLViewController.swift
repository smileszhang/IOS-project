//
//  CMLViewController.swift
//  HTTPSwiftExample
//
//  Created by Eric Larson on 11/2/17.
//  Copyright © 2017 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion
import CoreML

class CMLViewController: UIViewController {

    
    var ringBuffer = RingBuffer()
    let animation = CATransition()
    let motion = CMMotionManager()
    
    let motionOperationQueue = OperationQueue()
    
    var magValue = 0.1
    var isCalibrating = false
    
    var isWaitingForMotionData = true
    
    @IBOutlet weak var upArrow: UILabel!
    @IBOutlet weak var rightArrow: UILabel!
    @IBOutlet weak var downArrow: UILabel!
//    @IBOutlet weak var leftArrow: UILabel!
    @IBOutlet weak var largeMotionMagnitude: UIProgressView!
    
    @IBOutlet weak var pipeLabel: UILabel!
    @IBOutlet weak var randamlabel: UILabel!
    
    @IBOutlet weak var svmlabel: UILabel!
    
    var modelRf = RandomForestAccel()
    var modelSvm = SVMAccel()
    var modelPipe = PipeAccel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startMotionUpdates()
    }

    @IBAction func magnitudeChanged(_ sender: UISlider) {
        self.magValue = Double(sender.value)
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
            
            DispatchQueue.main.async{
                //show magnitude via indicator
                self.largeMotionMagnitude.progress = Float(mag)/0.2
            }
            
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
            
            guard let outputSvm = try? modelSvm.prediction(input: seq) else {
                fatalError("Unexpected runtime error.")
            }
            
            guard let outputPipe = try? modelPipe.prediction(input: seq) else {
                fatalError("Unexpected runtime error.")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self.pipeLabel.text = outputPipe.classLabel
                self.randamlabel.text = outputRf.classLabel
                self.svmlabel.text = outputSvm.classLabel
            })
            displayLabelResponse(outputPipe.classLabel)
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
        label.backgroundColor = UIColor.white
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
            break
        case "down":
            blinkLabel(downArrow)
            break
//        case "left":
//            blinkLabel(leftArrow)
//            break
        case "right":
            blinkLabel(rightArrow)
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

    

}
