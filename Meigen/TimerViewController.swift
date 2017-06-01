//
//  TimerViewController.swift
//  Meigen
//
//  Created by Kazutaka Homma on 7/19/15.
//  Copyright (c) 2015 Kazutaka Homma. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var daySegumentControl: UISegmentedControl!
    @IBOutlet weak var dailySwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    var comps = NSDateComponents()
    var timeArray = [NSDate]()
    var segumentIndex = 0
    var switchDefault: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        comps.hour = 7
        comps.minute = 0
        let currentCalendar = NSCalendar.currentCalendar()
        let dateAt7AM = currentCalendar.dateFromComponents(comps)
        for _ in 0...6 {
            timeArray.append(dateAt7AM!)
        }
        let standardDef = NSUserDefaults.standardUserDefaults()
        if(standardDef.valueForKey("weeklyTime") != nil) {
            timeArray = standardDef.valueForKey("weeklyTime") as! [NSDate]
        }
        //Set segumentControll to Sunday
        daySegumentControl.selectedSegmentIndex = 0
        
        switchDefault = standardDef.boolForKey("daily")
        if(switchDefault) {
            dailySwitch.on = switchDefault
            daySegumentControl.enabled = !switchDefault
            if(standardDef.valueForKey("dailyTime") != nil) {
                datePicker.date = standardDef.valueForKey("dailyTime") as! NSDate
            }
        }else{
            datePicker.date = timeArray[0]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        daySegumentControl.frame.size.height = daySegumentControl.frame.size.width/7
        let heightConstraint = NSLayoutConstraint(item: daySegumentControl, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: daySegumentControl.frame.size.width/7)
        daySegumentControl.addConstraint(heightConstraint)
    }

    @IBAction func dailyTypeChanged(sender: UISwitch) {
        if(sender.on){
            daySegumentControl.enabled = false
        } else {
            daySegumentControl.enabled = true
        }
    }

    
    @IBAction func daySegumentControlChanged(sender: UISegmentedControl) {
        timeArray[segumentIndex] = datePicker.date
        datePicker.date = timeArray[daySegumentControl.selectedSegmentIndex]
        segumentIndex = daySegumentControl.selectedSegmentIndex
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "save"){
            let standardDef = NSUserDefaults.standardUserDefaults()
            standardDef.setBool(dailySwitch.on, forKey: "daily")
            if(dailySwitch.on){
                standardDef.setValue(datePicker.date, forKey: "dailyTime")
            }else{
                timeArray[segumentIndex] = datePicker.date
                standardDef.setValue(timeArray, forKey: "weeklyTime")
            }
        }
    }
    
}
