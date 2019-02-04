//
//  NotificationApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2019/02/04.
//  Copyright © 2019 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NotificationApi {
    var REF_NOTIFICATION = FIRDatabase.database().reference().child("notification")
    
    func observeNotification(withId id: String, completion: @escaping (Notification) -> Void) {
        
        REF_NOTIFICATION.child(id).observe(.childAdded, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let newNoti = Notification.transform(dict: dict, key: snapshot.key)
                completion(newNoti)
            }
        })
    }
}
