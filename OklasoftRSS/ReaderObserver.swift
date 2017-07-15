//
//  ReaderObserver.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/1/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
import OklasoftNetworking

public protocol ReaderObserver {
    
    func receavedNewFeed(aNotification: Notification)
    
    func receavedNewRSSStory(aNotification: Notification)
    
    func receavedNewAtomStory(aNotification: Notification)
    
    func receavedNewJSONStory(aNotification: Notification)
    
}
