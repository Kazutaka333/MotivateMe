//
//  QuoteDetailViewController.swift
//  Meigen
//
//  Created by Kazutaka Homma on 10/26/15.
//  Copyright © 2015 Kazutaka Homma. All rights reserved.
//

import UIKit

class QuoteDetailViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var quoteText: String?
    var sourceText: String?
    var favorited: Bool = false
    var quoteId: String?
    var quoteData: QuoteData = QuoteData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        quoteLabel.text = (quoteText ?? "Unavailable")
        quoteLabel.adjustsFontSizeToFitWidth = true
        sourceLabel.text = (sourceText ?? "Unavailable")
        sourceLabel.adjustsFontSizeToFitWidth = true
        if favorited {
            self.favoriteButton.setImage(UIImage(named: "bookmarkStar"), forState: .Normal)
        } else {
            self.favoriteButton.setImage(UIImage(named: "bookmarkStarOff"), forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func starPressed(sender: UIButton) {
        if favorited {
            sender.setImage(UIImage(named: "bookmarkStarOff"), forState: .Normal)
            quoteData.setFavorite(quoteId!, favorited: false)
            favorited = false
        } else {
            sender.setImage(UIImage(named: "bookmarkStar"), forState: .Normal)
            quoteData.setFavorite(quoteId!, favorited: true)
            favorited = true
        }
    }
    
    func setQuoteLabelText(text: String?) {
        self.quoteLabel.text = text
    }
    
    func setSourceLabelText(source: String?) {
        self.sourceLabel.text = source
    }
}
