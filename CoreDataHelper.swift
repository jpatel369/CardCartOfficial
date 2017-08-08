//
//  CoreDataHelper.swift
//  CardCartOfficial
//
//  Created by Jay Patel on 7/24/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum DataType: String{
    case BUSINESS_CARD = "BusinessCardData", RECEIPT = "ReceiptData"
}

struct CoreDataHelper{
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    static func newBusinessCard() -> BusinessCardData {
        let entity = NSEntityDescription.insertNewObject(forEntityName: DataType.BUSINESS_CARD.rawValue, into: managedContext) as! BusinessCardData
        return entity
    }
    
    static func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func newReceipt() -> ReceiptData {
        let entity = NSEntityDescription.insertNewObject(forEntityName: DataType.RECEIPT.rawValue, into: managedContext) as! ReceiptData
        return entity
    }

    
//    static func saveReceiptCard(title: String, store: String, info: String, image: UIImage?){
//        let entity =
//            NSEntityDescription.entity(forEntityName: "ReceiptData",
//                                       in: managedContext)!
//        let receipt = ReceiptData(entity: entity,
//                                    insertInto: managedContext)
//        receipt.title = title
//        receipt.info = info
//        receipt.store = store
//        
//        if image != nil {
//            
//            receipt.image = UIImagePNGRepresentation(image!)! as NSData
//            
//        }
//        
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
    
    static func loadData(type: DataType) -> [NSManagedObject]{
        var returnData: [NSManagedObject] = []
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: type.rawValue)
        do {
            returnData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
     return returnData
    }
    
    static func deleteAt(type: DataType, index: Int){
        let returnList = loadData(type: type)
        // remove your object
        managedContext.delete(returnList[index])
        do{
        // save your changes 
        try managedContext.save()
        } catch let _ as NSError{
            print("error")
        }
    }
    
}

