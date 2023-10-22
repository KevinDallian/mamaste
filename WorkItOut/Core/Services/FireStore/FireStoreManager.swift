//
//  FireStoreManager.swift
//  WorkItOut
//
//  Created by Elvin Sestomi on 21/10/23.
//

import Foundation
import FirebaseFirestore

struct FireStoreManager {
    
    static let shared = FireStoreManager();
    
    let db = Firestore.firestore()
    
    
    func getCollection(collectionName : String, completion : @escaping (_ : QuerySnapshot) -> Void) async {
        db.collection(collectionName).getDocuments() { (querySnapshot, err) in
            if err != nil {
                fatalError("error : \(String(describing: err?.localizedDescription))")
            }
            
            guard let qss = querySnapshot else {
                fatalError("No data found in querry SnapShot")
            }
            
            completion(qss);
        }
    }
    
}
