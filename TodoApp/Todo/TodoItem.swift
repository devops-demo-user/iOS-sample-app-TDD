//
//  TodoItem.swift
//  Todo
//

import Foundation

class TodoItem: NSObject {
    let itemName: String
    var completed: Bool
    var id: String
    
    init(itemName: String, id: String, completed: Bool = false) {
        self.itemName = itemName
        self.id = id
        self.completed = completed
    }
}
