//
//  UserSettings.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/7/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import Foundation

private let _GlobalSettings = GlobalSettings()

public class GlobalSettings {
    
    struct Constants {
        static let PedalPoints = "PedalPoints"
        static let DistanceTraveled = "DistanceTraveled"
        static let TimeTraveled = "TimeTraveled"
        static let Font = "BoosterNextFY-Medium"
        static let Onboarded = "Onboarded"
        static let UserEmail = "UserEmail"
    }
    
    public class var SharedInstance: GlobalSettings {
        return _GlobalSettings
    }
    
    public var PedalPoints:Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Constants.PedalPoints) 
        }
        set (newPedalPoints) {
            NSUserDefaults.standardUserDefaults().setInteger(newPedalPoints, forKey: Constants.PedalPoints)
        }
    }
    
    public var DistanceTraveled:Double {
        get {
            return NSUserDefaults.standardUserDefaults().doubleForKey(Constants.DistanceTraveled)
        }
        set (newDistanceTraveled) {
            NSUserDefaults.standardUserDefaults().setDouble(newDistanceTraveled, forKey: Constants.DistanceTraveled)
        }
    }
    
    
    public var TimeTraveled: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Constants.TimeTraveled)
        }
        set (newTimeTraveled) {
            NSUserDefaults.standardUserDefaults().setInteger(newTimeTraveled, forKey: Constants.TimeTraveled)
        }
    }
    
    public var Font:String {
        get {
            if let currentFont = NSUserDefaults.standardUserDefaults().stringForKey(Constants.Font) {
                return currentFont
            } else {
                return "BoosterNextFY-Medium"
            }
        }
        set (newFont) {
            NSUserDefaults.standardUserDefaults().setObject(newFont, forKey: Constants.Font)
        }
    }
    
    public var LogoDictionary:[String: String] = ["":""]
    
    public var Onboarded:Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Constants.Onboarded)
        }
        set (newOnboarded) {
            NSUserDefaults.standardUserDefaults().setBool(newOnboarded, forKey: Constants.Onboarded)
        }
    }
    
    public var UserEmail: String {
        get {
            if let currentUserEmail = NSUserDefaults.standardUserDefaults().stringForKey(Constants.UserEmail) {
                return currentUserEmail
            } else {
                return ""
            }
        }
        set (newUserEmail) {
            NSUserDefaults.standardUserDefaults().setObject(newUserEmail, forKey: Constants.UserEmail)
        }
    }
}
