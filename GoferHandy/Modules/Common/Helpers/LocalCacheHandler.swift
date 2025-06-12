//
//  LocalCacheHandler.swift
//  GoferDriver
//
//  Created by trioangle on 17/03/21.
//  Copyright © 2021 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class CacheResult{
    var model : Data?
    var json : JSON?
    init()
    {
        model = Data()
        json = JSON()
    }
}
class LocalCacheHandler{
    private let appDelegate : AppDelegate
    private let context : NSManagedObjectContext
    
    init(){
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = self.appDelegate.persistentContainer.viewContext
        // test commit by yamini
    }
    private func getEntity() -> NSEntityDescription?{
        //test
        return NSEntityDescription.entity(forEntityName: "Cache",
                                          in: self.context)
    }
    private func saveEntity(_ object : NSManagedObject){
        debug(print: "Cache")
        do{
            
            try object.managedObjectContext?.save()// context.save()
        }catch{
            print("Core data save failed for entity : \(object.description)")
        }
    }

    func store(data : Data,apiName: String,json: JSON){
        guard let entity = self.getEntity() else{return}
        let object = NSManagedObject(entity: entity, insertInto: self.context)
        if !isExist(key: apiName, data: data,json: json) {
            do{
                object.setValue(data, forKey: "model")
                object.setValue(apiName, forKey: "api_name")
                object.setValue(json, forKey: "json")
                self.saveEntity(object)
            }
        }
    }

    func isExist(key: String,data:Data,json: JSON) -> Bool {
        var list: NSManagedObject? = nil
        let lists = fetchRecords(key: key)
        if let listRecord = lists.first{
            list = listRecord
        }
        if let list = list {
            print(list)
            if list.value(forKey: "api_name") != nil {
                list.setValue(key, forKey: "api_name")
            }
            if list.value(forKey: "model") != nil {
                list.setValue(data, forKey: "model")
            }
            if list.value(forKey: "json") != nil {
                list.setValue(json, forKey: "json")
            }
        }else{
            print("unable to fetch")
        }
        do {
            try context.save()
        }catch{
            print("unable to save managed object context")
        }

        return lists.count > 0 ? true : false
    }
    func fetchRecords(key: String) -> [NSManagedObject]
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cache")
        fetchRequest.predicate = NSPredicate(format: "(api_name = %@)", key as CVarArg)
        var result = [NSManagedObject]()
        do {
            let records = try context.fetch(fetchRequest)
            if let records = records as? [NSManagedObject]{
                result = records
            }
        }
        catch{
            print("unable to fetch managed objects for entity")
        }
        return result
    }
    
    func getData(key: String,_ onFetch :@escaping([CacheResult?]) -> Void ){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cache")
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "(api_name = %@)", key as CVarArg)
//        key1 = %@ AND key2 = %@
//        if page != 0 {
//            predicate = NSPredicate(format: "(api_name = %@ AND page = %@)", key as CVarArg,page as CVarArg)
//        }
        request.predicate = predicate
        var objects = [CacheResult?]()

        do {
            let result = try context.fetch(request)
            for data in result as? [NSManagedObject] ?? [NSManagedObject](){
                let dict = CacheResult()
                dict.model = data.value(forKey: "model") as? Data
                dict.json = data.value(forKey: "json") as? JSON
                objects.append(dict)
            }
        } catch let error{
            
            print("ƒFailed"+error.localizedDescription)
        }
        DispatchQueue.main.async {
            onFetch(objects)
        }
    }
    func removeAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cache")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in Cache error :", error)
        }
    }

}
