//
//  UserSettings.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/7/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import Foundation

private let _UserSettings = UserSettings()

public class UserSettings {
    
    struct Constants {
        static let PedalPoints = "PedalPoints"
        static let Distance = "Distance"
        static let Time = "Time"
    }
    
    public class var SharedInstance: UserSettings {
        return _UserSettings
    }
    
    public var PedalPoints:Int {
        get {
            if (NSUserDefaults.standardUserDefaults().integerForKey(Constants.PedalPoints) == 0) {
                return 5
            } else { return NSUserDefaults.standardUserDefaults().integerForKey(Constants.PedalPoints) }
        }
        set (newPedalPoints) {
            NSUserDefaults.standardUserDefaults().setInteger(newPedalPoints, forKey: Constants.PedalPoints)
        }
    }
    
    public var Distance:Double {
        get {
            return NSUserDefaults.standardUserDefaults().doubleForKey(Constants.Distance)
        }
        set (newDistance) {
            NSUserDefaults.standardUserDefaults().setDouble(newDistance, forKey: Constants.Distance)
        }
    }
    
    
    public var Time: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Constants.Time)
        }
        set (newTime) {
            NSUserDefaults.standardUserDefaults().setInteger(newTime, forKey: Constants.Distance)
        }
    }
}
