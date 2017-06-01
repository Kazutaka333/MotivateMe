//
//  FirstLaunchViewController.swift
//  Meigen
//
//  Created by Kazutaka Homma on 9/11/15.
//  Copyright (c) 2015 Kazutaka Homma. All rights reserved.
//

import UIKit

class FirstLaunchViewController: UIViewController {


    var QuoteDataInstance = QuoteData()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setBool(false, forKey: "firstLaunch")
        userDefault.synchronize()
    }
    
    override func viewDidAppear(animated: Bool) {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        let queue = dispatch_queue_create("quoteDownloadQueue", DISPATCH_QUEUE_SERIAL)
        if reachability.isReachable() {
            dispatch_async(queue, { () -> Void in
                let result = self.QuoteDataInstance.downLoadEnglishQuotes()
                if  result == false {
                    let mainQueue = dispatch_get_main_queue()
                    dispatch_async(mainQueue, { () -> Void in
                        let alert = UIAlertView(title: "", message: "Connection Error", delegate: self, cancelButtonTitle: "Dismiss")
                        alert.show()
                    })
                }
            })
        }else {
            let alert = UIAlertView(title: "", message: "Connection Error\nConnect to Wi-Fi or cellular network", delegate: self, cancelButtonTitle: "Dismiss")
            alert.show()
        }
        dispatch_async(queue, { () -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        })
    }

    @IBAction func buttonPressed(sender: AnyObject) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
