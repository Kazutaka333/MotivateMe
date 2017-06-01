//
//  MeigenData.swift
//  Meigen
//
//  Created by Kazutaka Homma on 8/23/15.
//  Copyright (c) 2015 Kazutaka Homma. All rights reserved.
//

import UIKit
import Parse
import CoreData


class QuoteData: NSObject {
    var lastEnglishUpdateDate = NSDate()
    func downLoadJapaneseQuotes() -> Bool{
        let context = getContext()
        let fetchRequest = NSFetchRequest(entityName: "JapaneseQuotes")
        fetchRequest.fetchLimit = 1
        let results = try! context.executeFetchRequest(fetchRequest)
        if results.count > 0 {
            return true
        } else {
            let query = PFQuery(className: "japaneseQuotes")
//            query.limit = 100
            let error: NSErrorPointer = nil
            
            if (error != nil) {
                print(error.debugDescription)
                return false
            }
            // The find succeeded.
            if let objects = query.findObjects(error) {
                for object in objects {
                    let context:NSManagedObjectContext = self.getContext()
                    let newQuote = NSEntityDescription.insertNewObjectForEntityForName("JapaneseQuotes", inManagedObjectContext: context) 
                    if object.valueForKey("character") != nil {
                        newQuote.setValue(object.valueForKey("character"), forKey: "character")
                    }
                    if object.valueForKey("quote") != nil {
                        newQuote.setValue(object.valueForKey("quote"), forKey: "quote")
                    }
                    if object.valueForKey("quote_en") != nil {
                        newQuote.setValue(object.valueForKey("quote_en"), forKey: "quote_en")
                    }
                    if object.valueForKey("objectId") != nil {
                        newQuote.setValue(object.valueForKey("objectId"), forKey: "objectId")
                    }
                    if object.valueForKey("reference") != nil {
                        newQuote.setValue(object.valueForKey("reference"), forKey: "reference")
                    }
                    if object.valueForKey("source") != nil {
                        newQuote.setValue(object.valueForKey("source"), forKey: "source")
                    }
                    if object.valueForKey("tags") != nil {
                        newQuote.setValue(object.valueForKey("tags"), forKey: "tags")
                    }
                    if object.valueForKey("views") != nil {
                        newQuote.setValue(object.valueForKey("views"), forKey: "views")
                    }
                    if object.valueForKey("updatedAt") != nil {
                        newQuote.setValue(object.valueForKey("updatedAt"), forKey: "updatedAt")
                    }
                    if object.valueForKey("author") != nil {
                        newQuote.setValue(object.valueForKey("author"), forKey: "author")
                    }
                    do {
                        try context.save()
                    } catch _ {
                    }
                }
            }
            return true
        }
    }
    
    func downLoadEnglishQuotes() -> Bool{
        let context = getContext()
        let fetchRequest = NSFetchRequest(entityName: "EnglishQuotes")
        fetchRequest.fetchLimit = 10
        let results = try! context.executeFetchRequest(fetchRequest)
        if results.count > 0 {
            return true
        }else{
            let query = PFQuery(className: "englishQuotes")
            let error: NSErrorPointer = nil
            query.limit = 1000
            if let objects = query.findObjects(error) {
            // The find succeeded.
                for object in objects {
                    let context:NSManagedObjectContext = self.getContext()
                    let newQuote = NSEntityDescription.insertNewObjectForEntityForName("EnglishQuotes", inManagedObjectContext: context)
                    if object.valueForKey("character") != nil {
                        newQuote.setValue(object.valueForKey("character"), forKey: "character")
                    }
                    if object.valueForKey("quote") != nil {
                        newQuote.setValue(object.valueForKey("quote"), forKey: "quote")
                    }
                    if object.valueForKey("quote_en") != nil {
                        newQuote.setValue(object.valueForKey("quote_en"), forKey: "quote_en")
                    }
                    if object.valueForKey("objectId") != nil {
                        newQuote.setValue(object.valueForKey("objectId"), forKey: "objectId")
                    }
                    if object.valueForKey("reference") != nil {
                        newQuote.setValue(object.valueForKey("reference"), forKey: "reference")
                    }
                    if object.valueForKey("source") != nil {
                        newQuote.setValue(object.valueForKey("source"), forKey: "source")
                    }
                    if object.valueForKey("tags") != nil {
                        newQuote.setValue(object.valueForKey("tags"), forKey: "tags")
                    }
                    if let views = object.valueForKey("views") {
                        newQuote.setValue(views, forKey: "views")
                    }
                    if object.valueForKey("updatedAt") != nil {
                        newQuote.setValue(object.valueForKey("updatedAt"), forKey: "updatedAt")
                    }
                    if object.valueForKey("author") != nil {
                        newQuote.setValue(object.valueForKey("author"), forKey: "author")
                    }
                    newQuote.setValue(false, forKey: "favorited")
                    do {
                        try context.save()
                    } catch _ {
                    }
                }
            }else {
                return false
            }
            lastEnglishUpdateDate = NSDate()
            return true
        }
    }
    
    func getJapaneseQuotes() -> AnyObject {
        let context = getContext()
        let fetchRequest = NSFetchRequest(entityName: "JapaneseQuotes")
        let results = try! context.executeFetchRequest(fetchRequest)
        if results.count > 0 {
            print("getJapaneseQuotes--")
        } else {
            print("no japanese quotes data...")
        }
        return results
    }
    
    func getEnglishQuotes() -> AnyObject {
        let context = getContext()
        let fetchRequest = NSFetchRequest(entityName: "EnglishQuotes")
//        fetchRequest.fetchLimit = 10
        let results = try! context.executeFetchRequest(fetchRequest)
        if results.count > 0 {
            print("got English Quotes...")
        }else{
            print("no english quotes data...")
        }
        return results
    }
    
    func getFavoritedEnglishQuotes() -> AnyObject {
        let context = getContext()
        let fetchRequest = NSFetchRequest(entityName: "EnglishQuotes")
        fetchRequest.predicate = NSPredicate(format: "favorited == true")
        let results = try! context.executeFetchRequest(fetchRequest)
        if results.count > 0 {
            print("got favorited English Quotes...")
        }else{
            print("no favorited english quotes data...")
        }
        return results
    }
    
    func setFavorite(objectId: String, favorited: Bool) {
        let context = getContext()
        let fetchRequest = NSFetchRequest(entityName: "EnglishQuotes")
        fetchRequest.predicate = NSPredicate(format: "objectId == %@", objectId)
        let results = try! context.executeFetchRequest(fetchRequest)
        if results.count == 1 {
            results[0].setValue(favorited, forKey: "favorited")
        }
        do {
            try context.save()
        } catch _ {
        }
    }
    
    func getQuoteByObjectId(objectId: String) -> AnyObject {
        let context = getContext()
        let fetchRequest = NSFetchRequest(entityName: "EnglishQuotes")
        fetchRequest.predicate = NSPredicate(format: "objectId == %@", objectId)
        let results = try! context.executeFetchRequest(fetchRequest)
        if results.count == 1 {
            return results[0]
        }else if results.count > 1{
            print("multiple quotes with the same ID exist")
        }else if results.count == 0 {
            print("quote object with the chosen ID does not exist")
        }
        return 0
    }
    func increaseViewsByOneAndUpdate(objectId: String) {
        let query = PFQuery(className:"englishQuotes")
        query.getObjectInBackgroundWithId(objectId) {
            (updatedQuote: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let updatedQuote = updatedQuote {
                updatedQuote["views"] = updatedQuote["views"] as! NSInteger + 1
                updatedQuote.saveEventually()
            }
        }
    }
    
    func updateEnglishQuotes() {
        let context = getContext()
        let fetchRequest = NSFetchRequest(entityName: "EnglishQuotes")
        fetchRequest.fetchLimit = 1
        let results = try! context.executeFetchRequest(fetchRequest)
        if results.count > 0 {
//            let datePredicate = NSPredicate(format: "updatedAt >= %@", lastEnglishUpdateDate)
            let query = PFQuery(className: "englishQuotes")
            let error: NSErrorPointer = nil
            query.limit = 1000
            let objects = query.findObjects(error)
            // The find succeeded.
            if objects?.count > 0 {
                for object in objects! {
                    let context:NSManagedObjectContext = self.getContext()
                    let fetchRequest = NSFetchRequest(entityName: "EnglishQuotes")
                    fetchRequest.predicate = NSPredicate(format: "objectId== %@", object.valueForKey("objectId") as! String)
                    fetchRequest.fetchLimit = 1
                    let results = try! context.executeFetchRequest(fetchRequest)
                    let localQuote = results[0]
                    localQuote.setValue(object.valueForKey("views"), forKey: "views")
                    do {
                        try context.save()
                    } catch _ {
                    }
                }
//                lastEnglishUpdateDate = NSDate()
            }
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDel.managedObjectContext!
    }

}
