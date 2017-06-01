//
//  MeigenTabBarController.swift
//  Meigen
//
//  Created by Kazutaka Homma on 8/9/15.
//  Copyright (c) 2015 Kazutaka Homma. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class QuoteTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDel.managedObjectContext!
    }

    @IBAction func saveDateAndBackToTabViewController(segue:UIStoryboardSegue) {
        setNotification()
    }
    
    @IBAction func cancelToTabViewController(segue:UIStoryboardSegue) {
        
    }

    @IBAction func saveButtonPushed() {
        //Save data as NSdate
//        var context:NSManagedObjectContext = getContext()
//        var newUser = NSEntityDescription.insertNewObjectForEntityForName("Quotes", inManagedObjectContext: context) as! NSManagedObject
//        newUser.setValue(quoteView.text, forKey: "quote")
//        context.save(nil)
        setNotification()
    }
    func setNotification() {
        let newNotification = UILocalNotification()
        let standardDef = NSUserDefaults.standardUserDefaults()
        let context:NSManagedObjectContext = getContext()
        let request = NSFetchRequest(entityName: "EnglishQuotes")
        let results:NSArray = try! context.executeFetchRequest(request)
        newNotification.alertAction = "Detail"
        request.returnsObjectsAsFaults = false
        // resest notification pool
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        if(results.count > 0) {
            let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
            let res: AnyObject = results[randomIndex]
            newNotification.alertBody = res.valueForKey("quote") as? String
            newNotification.userInfo = ["objectId": (res.valueForKey("objectId") as? String)!]
            
            if(standardDef.boolForKey("daily")) {
                newNotification.repeatInterval = NSCalendarUnit.Day
                newNotification.fireDate = getNearestDateAtSameTime(standardDef.valueForKey("dailyTime") as! NSDate)
                UIApplication.sharedApplication().scheduleLocalNotification(newNotification)
            }else{
                for i in 0...6 {
                    var dayOfW = ""
                    switch i {
                    case 0:
                        dayOfW = "Sunday"
                    case 1:
                        dayOfW = "Monday"
                    case 2:
                        dayOfW = "Tuesday"
                    case 3:
                        dayOfW = "Wednesday"
                    case 4:
                        dayOfW = "Thursday"
                    case 5:
                        dayOfW = "Friday"
                    case 6:
                        dayOfW = "Saturday"
                    default:
                        print("That day of week doesn't exist")
                    }
                    newNotification.repeatInterval = NSCalendarUnit.WeekOfYear
                    newNotification.fireDate = getNearestDateAtSameTimeOnChosenDayOfWeek((standardDef.valueForKey("weeklyTime") as! [NSDate])[i], dayOfWeek: dayOfW)
                    UIApplication.sharedApplication().scheduleLocalNotification(newNotification)
                }
            }
        }
    }
    func getNearestDateAtSameTime(givenDate: NSDate) -> NSDate {
        let presentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateFlag: NSCalendarUnit = [NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute]
        let timeFlag: NSCalendarUnit = [.Hour, .Minute]
        let newComp = calendar.components(dateFlag, fromDate: presentDate)
//        let presentComp = calendar.components(timeFlag, fromDate: presentDate)
        let givenComp = calendar.components(timeFlag, fromDate: givenDate)
        newComp.hour = givenComp.hour
        newComp.minute = givenComp.minute
//        let presentTime = calendar.dateFromComponents(presentComp)!
//        let scheduledTime = calendar.dateFromComponents(givenComp)!
        let newDate = calendar.dateFromComponents(newComp)!
        return newDate
    }
    func getNearestDateAtSameTimeOnChosenDayOfWeek(givenDate: NSDate, dayOfWeek: NSString) -> NSDate {
        let presentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateFlag: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute]
        let timeFlag: NSCalendarUnit = [.Hour, .Minute]
        let newComp = calendar.components(dateFlag, fromDate: presentDate)
//        let presentComp = calendar.components(timeFlag, fromDate: presentDate)
        let givenComp = calendar.components(timeFlag, fromDate: givenDate)
        newComp.hour = givenComp.hour
        newComp.minute = givenComp.minute
//        let presentTime = calendar.dateFromComponents(presentComp)!
//        let scheduledTime = calendar.dateFromComponents(givenComp)!
        let newDate = calendar.dateFromComponents(newComp)!
        let dayOfWeekFormatter = NSDateFormatter()
        dayOfWeekFormatter.dateFormat = "EEEE"
        var nearestDate = NSDate()
        for i in 0...6 {
            let dayAdditionComp = NSDateComponents()
            dayAdditionComp.day = i
            nearestDate = calendar.dateByAddingComponents(dayAdditionComp, toDate: newDate, options: .MatchStrictly)!
            if(dayOfWeekFormatter.stringFromDate(nearestDate) == dayOfWeek) {
                break;
            }
        }
        return nearestDate
    }
    
    
    @IBAction func saveDateAndBackToMeigenViewController(segue:UIStoryboardSegue) {
        setNotification()
    }
    @IBAction func cancelToMeigenViewController(segue:UIStoryboardSegue) {
    }

}
