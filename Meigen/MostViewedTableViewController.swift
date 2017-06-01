//
//  MostViewedTableViewController.swift
//  Meigen
//
//  Created by Kazutaka Homma on 10/23/15.
//  Copyright © 2015 Kazutaka Homma. All rights reserved.
//

import UIKit

class MostViewedTableViewController: UITableViewController {

    var quotes = [AnyObject]()
    var cellNum = 0
    let button   = UIButton(type: UIButtonType.System) as UIButton
    let quoteDataInst = QuoteData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0);
        self.tableView.estimatedRowHeight = 90
        self.tableView.delegate = self
        self.tableView.dataSource = self
        refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl!)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        updateQuotesData()
        if quotes.count > 0 {
            button.removeFromSuperview()
            self.tableView.reloadData()
        } else {
            let buttonWidth = CGFloat(200)
            let buttonHeight = CGFloat(50)
            button.frame = CGRectMake(self.view.frame.size.width/2 - buttonWidth/2, self.view.frame.size.height/2 - buttonHeight/2, buttonWidth, buttonHeight);
            button.backgroundColor = UIColor.whiteColor()
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.grayColor().CGColor
            button.setTitle("Download Quotes", forState: UIControlState.Normal)
            button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.navigationController!.view.addSubview(button)
        }
    }
    
    func sortQuotes() {
        quotes = quotes.sort({ $0.valueForKey("views") as! NSInteger > $1.valueForKey("views") as! NSInteger})
        self.tableView.reloadData()
    }
    
    func buttonPressed(sender:UIButton!) {
        sender.removeFromSuperview()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("firstLaunchViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        QuoteData().updateEnglishQuotes()
        quotes = QuoteData().getEnglishQuotes() as! [(AnyObject)]
        sortQuotes()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return quotes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("quoteCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .ByWordWrapping;
        cell.textLabel?.text = quotes[indexPath.row].valueForKey("quote") as? String
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("quoteDetailViewController") as! QuoteDetailViewController
        let quote = quotes[indexPath.row]
        let objId = quote.valueForKey("objectId") as! String
        viewController.quoteText = quote.valueForKey("quote") as? String
        viewController.sourceText = quote.valueForKey("source") as? String
        viewController.favorited = (quote.valueForKey("favorited") as? Bool)!
        viewController.quoteId = objId
        quoteDataInst.increaseViewsByOneAndUpdate(objId)

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func updateQuotesData(){
        quotes = QuoteData().getEnglishQuotes() as! [(AnyObject)]
        sortQuotes()

    }
}






