//
//  DashboardVC.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/3/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit
import CoreLocation

class DashboardVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var adView: UIImageView!
    @IBOutlet weak var milesBottomlabel: UILabel!
    @IBOutlet weak var durationBottomLabel: UILabel!
    @IBOutlet weak var speedBottomLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var bottomHr: UIView!
    
    @IBOutlet weak var distanceBottomHr: UIView!
    @IBOutlet weak var speedDurationHr: UIView!
    @IBOutlet weak var buttonTopHr: UIView!
    
    var distance = 0.0
    var duration:NSTimer?
    var startTime:NSTimeInterval?
    var speed:CLLocationSpeed = CLLocationSpeed()
    let locationManager = CLLocationManager()
    lazy var locations = [CLLocation]()
    var presentedWarning = false

    let fontOfChoice = GlobalSettings.SharedInstance.Font
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adView.image = UIImage(named: "carShopLogo")
        self.titleLabel.text = "Track Your Miles"
        self.view.backgroundColor = UIColor.init(hex:0xcef4f5)
        
        self.startButton.layer.cornerRadius = 10
        self.startButton.setTitle("Start", forState: .Normal)
        self.startButton.backgroundColor = UIColor.greenColor()
        self.startButton.layer.opacity = 0.5
        
        self.stopButton.layer.cornerRadius = 10
        self.stopButton.setTitle("Stop", forState: .Normal)
        self.stopButton.backgroundColor = UIColor.redColor()
        self.stopButton.layer.opacity = 0.5
        
        self.distanceLabel.font = UIFont(name: fontOfChoice, size: 75.0)
        self.durationLabel.font = UIFont(name: fontOfChoice, size: 40.0)
        self.speedLabel.font = UIFont(name: fontOfChoice, size: 40.0)
        self.stopButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 34.0)
        self.startButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 34.0)
        self.milesBottomlabel.font = UIFont(name: fontOfChoice, size: 14.0)
        self.durationBottomLabel.font = UIFont(name: fontOfChoice, size: 14.0)
        self.speedBottomLabel.font = UIFont(name: fontOfChoice, size: 14.0)
        self.titleLabel.font = UIFont(name: fontOfChoice, size: 21.0)
        
        bottomHr.layer.shadowColor = UIColor.blackColor().CGColor
        bottomHr.layer.shadowOffset = CGSizeMake(0, 1)
        bottomHr.layer.shadowOpacity = 0.5
        bottomHr.layer.shadowRadius = 1.0
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.activityType = .Fitness
        locationManager.requestAlwaysAuthorization()
        
        self.resetTimer()
        self.resetDistance()
        self.resetSpeed()
        self.stopButton.enabled = false
        self.stopButton.backgroundColor = UIColor.grayColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations \(locations)")
        for location in locations {
            if location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    if (self.speed < 24.0) {
                        distance += location.distanceFromLocation(self.locations.last!)
                    } else {
                        self.reportUserIsGoingTooFast()
                    }
                }
                
                //save location
                self.locations.append(location)
            }
        }
        self.updateDistanceLabel()
        self.updateSpeedLabel()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error \(error)")
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        self.resetTimer()
        self.resetDistance()
        self.resetSpeed()
        
        self.startButton.enabled = true
        self.stopButton.enabled = false
        self.stopButton.backgroundColor = UIColor.grayColor()
        self.startButton.backgroundColor = UIColor.greenColor()
        
        locationManager.stopUpdatingLocation()
        
        self.presentCongratsAlert()
    }

    @IBAction func startPressed(sender: AnyObject) {
        duration = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.updateRun), userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        locationManager.startUpdatingLocation()
        
        self.distanceLabel.text = "0.0"
        self.speedLabel.text = "0.0"
        self.distance = 0.0
        
        self.startButton.enabled = false
        self.stopButton.enabled = true
        self.startButton.backgroundColor = UIColor.grayColor()
        self.stopButton.backgroundColor = UIColor.redColor()
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateRun() {
        self.updateDurationLabel()
    }
    
    func updateDurationLabel() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime!
        
        //calculate the hours in elapsted time.
        let hours = UInt8(elapsedTime / 360.0)
        elapsedTime -= (NSTimeInterval(hours) * 360)
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //add the leading zero for hours, minutes and seconds and store them as string constants
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minutes, seconds and milliseconds as assign it to the UILabel
        durationLabel.text = "\(strHours):\(strMinutes):\(strSeconds)"
    }
    
    func updateSpeedLabel() {
        if (locations.count != 0) {
            // convert to mph from m/s, and round to 2 decimal places
            let currentSpeed = round((locations.last?.speed)! * 223.694 / 100)
            self.speed = currentSpeed
            self.speedLabel.text = "\(currentSpeed) MPH"
        }
    }
    
    func updateDistanceLabel() {
        if (locations.count == 0) {
            self.distanceLabel.text = "0.0"
        } else {
            let currentDistance = round((distance * 0.000621371)*100) / 100
            self.distanceLabel.text = "\(currentDistance) Miles"
        }
    }
    
    func resetTimer() {
        self.durationLabel.text = "N/a"
        
        // invalidate timer if it's going
        if let timer = duration {
            timer.invalidate()
        }
    }
    
    func resetDistance() {
        self.distanceLabel.text = "N/a"
    }
    
    func resetSpeed() {
        self.speedLabel.text = "N/a"
    }
    
    func presentCongratsAlert() {
        // calculate points earned
        let pointsEarned = Int((round((distance * 0.000621371)*100) / 100)/5.0)
        GlobalSettings.SharedInstance.PedalPoints += pointsEarned
        
        if (pointsEarned > 0) {
            let alert = UIAlertController(title: "Congratulations!", message: "You earned \(pointsEarned) Pedal Points!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Nice", style: .Default, handler: nil)
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func reportUserIsGoingTooFast() {
        if (!self.presentedWarning) {
            self.presentedWarning = true
            
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> () in
                let alert = UIAlertController(title: "Woah There!", message: "We clocked you at \(self?.speed), which is awesome, but it's a little too fast! Speed over 24 mph won't count towards Pedal Points", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(OKAction)
                self?.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
}
