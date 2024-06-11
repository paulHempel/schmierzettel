//
//  Item.swift
//  schmierzettel
//
//  Created by Paul Hempel on 11.06.24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
