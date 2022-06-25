//
//  NotificationsManager.swift
//  OctoDollop
//
//  Created by alber848 on 19/04/2022.
//

import Foundation


enum OctodollopNotification {
    case ratingSaved
    
    fileprivate var name: Notification.Name {
        switch self {
        case .ratingSaved: return Notification.Name("OctodollopRatingSaved")
        }
    }
}

class NotificationsManager {
    
    // MARK: - Public methods
    
    
    /// Posts a notification
    ///
    /// - Parameter notoification: the notification to be posted
    public func post(notification: OctodollopNotification) {
        NotificationCenter.default.post(name: notification.name, object: nil)
    }
    
    /// Subscribes for notification events
    public func subscribe(observer: Any, selector: Selector, notification: OctodollopNotification) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notification.name, object: nil)
    }
}
