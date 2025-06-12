//
//  FireBaseObserver.swift
//  Gofer
//
//  Created by trioangle on 04/06/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

enum FireBaseEnvironment : String{
    case live
    case demo
}



enum FireBaseNodeKey : String{
    case rider
    case driver
    case trip
    case trip_chat = "driver_rider_trip_chats"
    case live_tracking
    
    case refresh_payment = "refresh_payment_screen"
    case _polyline_path = "path"
    case _eta_min = "eta_min"
    
    
    func ref() -> DatabaseReference{
        return Database.database()
            .reference()
            .child(firebaseEnvironment.rawValue)
            .child(self.rawValue)
    }
    func ref(forID : String,conType:ConversationType) -> DatabaseReference{
        return self.ref()
            .child(forID).child(conType.rawValue)
    }
    func setValue(_ json : JSON){
        self.ref().setValue(json) { (error, dataRef) in
            
        }
    }
    func getReference(for keyPath : String...) -> DatabaseReference{
        var reference = self.ref()
        for path in keyPath{
            reference = reference.child(path)
        }
        return reference
    }
    func setValue(_ value : Any,for keyPath : String...){
        var reference = self.ref()
        for path in keyPath{
            reference = reference.child(path)
        }
        reference.setValue(value)
    }
    func removeObject(for keyPath : String...){
        var reference = self.ref()
        for path in keyPath{
            reference = reference.child(path)
        }
        reference.removeValue()
    }
    func addObserver(_ event : DataEventType,for keyPath : String...,response :@escaping (DataSnapshot)->()){
        
        var reference = self.ref()
        for path in keyPath{
            reference = reference.child(path)
        }
        
        reference.observe(event) { (snapshot) in
            response(snapshot)
        }
    }
}

/*

class FIRObserver{
    
    private init(){}
    static let instance = FIRObserver()
    
    private var riderRefernce : FIRDatabaseReference?
    private var tripReference : FIRDatabaseReference?
   
    func initialize(_ node : FireBaseNodeKey,forID id : String){
        if node == .rider{
            self.riderRefernce = node.ref(forID: id)
        }else{
            self.tripReference = node.ref(forID: id)
        }
        
    }
    func startObservingRider(_ node: FireBaseNodeKey){
        let reference : FIRDatabaseReference?
        reference = node == .rider ? self.riderRefernce : self.tripReference
        guard reference != nil else{return}
        reference!.observe(FIRDataEventType.childChanged,
                              with : { (snapShot) in
                                self.handleValueChange(forNode: node, snapShotJSON: snapShot )
        })
    }
    func stopObservingRider(_ node : FireBaseNodeKey){
        switch node {
        case .rider:
            riderRefernce?.removeAllObservers()
        case .driver:
            break
        case .trip:
            tripReference?.removeAllObservers()
        default:
            break
      
        }
      
    }
    func update(_ node : FireBaseNodeKey,with model : FIRModel?){
        switch node {
        case .rider:
            
            break//riderRefernce?.updateChildValues(model.updateValue)
        case .driver:
            break
        case .trip:
            break
         
        default:
            break
        }
    }
    
    func handleValueChange(forNode node : FireBaseNodeKey,snapShotJSON : FIRDataSnapshot){
        debug(print: "from firebase")
        let tripID = Int(snapShotJSON.value as? String ?? String()) ?? 0
        switch node {
        case .rider:
                if tripID != UserDefaults.value(for: .current_trip_id){
                Shared.instance.resumeTripHitCount = 0
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.onSetRootViewController(viewCtrl: nil)
            }
        case .trip:
            break
        case .driver:
            break
        default:
            break
        }
    }
}


*/
