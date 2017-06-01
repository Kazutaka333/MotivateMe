//
//  FavoriteTableViewController.swift
//  Meigen
//
//  Created by Kazutaka Homma on 10/29/15.
//  Copyright © 2015 Kazutaka Homma. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {

    var quotes = [AnyObject]()
    var cellNum = 0
    let button   = UIButton(type: UIButtonType.System) as UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0);
        self.tableView.estimatedRowHeight = 90
    }
    
    override func viewWillAppear(animated: Bool) {        
        updateQuotesData()
        if quotes.count > 0 {
            button.removeFromSuperview()
            self.tableView.reloadData()
        } 
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
        viewController.quoteText = quotes[indexPath.row].valueForKey("quote") as? String
        viewController.sourceText = quotes[indexPath.row].valueForKey("source") as? String
        viewController.favorited = (quotes[indexPath.row].valueForKey("favorited") as? Bool)!
        viewController.quoteId = quotes[indexPath.row].valueForKey("objectId") as? String
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func updateQuotesData(){
        quotes = QuoteData().getFavoritedEnglishQuotes() as! [(AnyObject)]
        self.tableView.reloadData()
    }

}
