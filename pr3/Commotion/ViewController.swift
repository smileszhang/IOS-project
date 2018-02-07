//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    //MARK: class variables
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let motion = CMMotionManager()
    var yestodayTotalStep = UserDefaults.standard.integer(forKey: "dailyStepGoal")
    var todaysTotalStep = 0
    var totalSteps: Float =  0.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                //self.stepsSlider.setValue(newtotalSteps,animated: true)
                //self.stepsSlider.value =  UserDefaults.standard.float(forKey: "dailyStepGoal")
                //self.stepsLabel.text = "Goal: \(self.stepsSlider.value)"
                //self.stepsLabel.text = "Goal: \(UserDefaults.standard.integer(forKey: "dailyStepGoal"))"
            }
        }
    }
    
    //MARK: UI Elements
    @IBOutlet weak var stepsSlider: UISlider!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var isWalking: UILabel!
    @IBOutlet weak var pastPedCounter: UILabel!
    @IBOutlet weak var instantPedCounterLabel: UILabel!
    @IBOutlet weak var todaysstep: UILabel!
    @IBOutlet weak var yestodayStep: UILabel!
    
    @IBOutlet weak var playGameButton: UIButton!
    
    
    @IBAction func playGameTouched(_ sender: UIButton) {
      
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        // use slider set default goal
        DispatchQueue.main.async{
            let stepDefault = UserDefaults.standard
            stepDefault.set(self.stepsSlider.value,forKey:"dailyStepGoal")
            
            self.stepsLabel.text = "Goal: \(UserDefaults.standard.integer(forKey: "dailyStepGoal"))"
            //self.stepsLabel.text = "Goal: \(self.stepsSlider.value)"
            
            if( self.yestodayTotalStep >= UserDefaults.standard.integer(forKey: "dailyStepGoal")){
                self.playGameButton.isEnabled = true
            }
            else /*if(self.yestodayTotalStep < UserDefaults.standard.integer(forKey: "dailyStepGoal")) */{
                self.playGameButton.isEnabled = false
            }
            
            
        }
    }
    
    
    //MARK: View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.stepsSlider.value = Float(UserDefaults.standard.integer(forKey: "dailyStepGoal"))
        self.stepsSlider.setValue(UserDefaults.standard.float(forKey: "dailyStepGoal"), animated: true)
        self.stepsLabel.text = "Goal: \(UserDefaults.standard.integer(forKey: "dailyStepGoal"))"
       // self.setDefaultGoal()
        
        
        self.totalSteps = 0.0
        self.startActivityMonitoring()
        self.startPedometerMonitoring()

        self.startMotionUpdates()
        
        self.stepCounterOfToday()
        self.stepCounterYesterdayAndToday()
        self.playGameWhenMeetTheGoal()
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Raw Motion Functions
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device 
        
        // TODO: should we be doing this from the MAIN queue? You will need to fix that!!!....
        if self.motion.isDeviceMotionAvailable{
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main,
                                                 withHandler: self.handleMotion)
 
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let gravity = motionData?.gravity {
            let rotation = atan2(gravity.x, gravity.y) - Double.pi
            self.isWalking.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
        }
        

    }
    
    // MARK: Activity Functions
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: self.handleActivity)
        }
        
    }
    
    func handleActivity(_ activity:CMMotionActivity?)->Void{
        // unwrap the activity and disp
        if let unwrappedActivity = activity {
            DispatchQueue.main.async{
                self.isWalking.text = "Walking: \(unwrappedActivity.walking)\n Still: \(unwrappedActivity.stationary)\n running: \(unwrappedActivity.running)\n cycling: \(unwrappedActivity.cycling)\n driving: \(unwrappedActivity.automotive)\n unkown: \(unwrappedActivity.unknown)"
            }
        }
    }
    
    // MARK: Pedometer Functions
    func startPedometerMonitoring(){
        //separate out the handler for better readability
        if CMPedometer.isStepCountingAvailable(){
            pedometer.startUpdates(from: Date())
            {(pedData: CMPedometerData?, error: Error?) -> Void in
                if let ped = pedData {
                    self.instantPedCounterLabel.text = "\(ped.numberOfSteps)"
                    if(ped.numberOfSteps.intValue >= UserDefaults.standard.integer(forKey: "dailyStepGoal")){
                        self.instantPedCounterLabel.text = "User reached the goal"
            
                    }
                }
            }
        }
    }
    
    //ped handler
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?)->(){
        if let steps = pedData?.numberOfSteps {
            self.totalSteps = steps.floatValue
        }
    }
    
   /* func setDefaultGoal(){
        
        let stepDefault = UserDefaults.standard
        stepDefault.set(self.stepsSlider.value*10,forKey:"dailyStepGoal")
        //stepDefault.set(100,forKey:"dailyStepGoal")
    } */
    
    // Module A 1st question
    func stepCounterYesterdayAndToday(){
        let now = NSDate()
        let todayCalendar = Calendar.current
        
        var component = todayCalendar.dateComponents([.year, .month, .day], from: Date())
        component.day = component.day! - 1
        component.hour = 0
        component.minute = 0
        component.second = 0
        let midnightOfYestoday = todayCalendar.date(from: component)!
        //let from = now.addingTimeInterval(-60*60*24)
        self.pedometer.queryPedometerData(from: midnightOfYestoday ,to: now as Date)
        {(pedData: CMPedometerData?, error:Error?) -> Void in
            let aggregated_string = "\(pedData!.numberOfSteps)"
            
            DispatchQueue.main.async(){
                self.pastPedCounter.text = aggregated_string
            }
        }
        
    }
    
    func stepCounterOfToday(){
        let now1 = NSDate()
        let todaysCalendar = Calendar.current
        
        var componentOfToday = todaysCalendar.dateComponents([.year, .month, .day], from: Date())
        componentOfToday.hour = 0
        componentOfToday.minute = 0
        componentOfToday.second = 0
        let midnightOfToday = todaysCalendar.date(from: componentOfToday)!
        //let from = now.addingTimeInterval(-60*60*24)
        self.pedometer.queryPedometerData(from: midnightOfToday ,to: now1 as Date)
        {(pedData: CMPedometerData?, error:Error?) -> Void in
            let today_string = "\(pedData!.numberOfSteps)"
            self.todaysTotalStep = pedData!.numberOfSteps.intValue
            DispatchQueue.main.async(){
                self.todaysstep.text = today_string
                let stepDefault = UserDefaults.standard
                stepDefault.set(self.todaysTotalStep,forKey:"todayTotalStep")
                
            }
        }
        
    }
    func playGameWhenMeetTheGoal(){
        let theCalendar = Calendar.current
        
        var component = theCalendar.dateComponents([.year, .month, .day], from: Date())
        component.day = component.day! - 1
        component.hour = 0
        component.minute = 0
        component.second = 0
        let midnightOfYestoday = theCalendar.date(from: component)!
        var todayComponent = theCalendar.dateComponents([.year, .month, .day], from: Date())
        todayComponent.day = todayComponent.day! 
        todayComponent.hour = 0
        todayComponent.minute = 0
        todayComponent.second = 0
        let midnightOfToday = theCalendar.date(from: todayComponent)!
        
        self.pedometer.queryPedometerData(from: midnightOfYestoday ,to: midnightOfToday)
        {(pedData: CMPedometerData?, error:Error?) -> Void in
            self.yestodayTotalStep = pedData!.numberOfSteps.intValue
            let yestoday_string = "\(pedData!.numberOfSteps)"
            
            DispatchQueue.main.async(){
                self.yestodayStep.text = yestoday_string
            }
    }


}

}
