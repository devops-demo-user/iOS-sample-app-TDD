//
//  APIManager.swift
//  Todo
//  Created by gchen on 1/7/16.
//

import UIKit

typealias APIResponse = (NSData, NSError?) -> Void

class APIManager :NSObject {

    static let sharedInstance = APIManager()
    let TASK_LIST_URL = "https://tasklistdemo.mybluemix.net/api/task/list"
    
    
    func fetchAllTasks(onCompletion: APIResponse) {
        
        makeAPIRequest(TASK_LIST_URL, method: "GET", postData: "", onCompletion: { data, err in
            onCompletion(data, err)
        })

    }
    
    func addTask(todoItem: TodoItem, onCompletion: APIResponse) {
        let postData  = "task=" + todoItem.itemName
        makeAPIRequest(TASK_LIST_URL, method: "POST", postData: postData, onCompletion: { data, err in
            onCompletion(data, err)
        })
        
    }
    
    func deleteTask(todoItem: TodoItem, onCompletion: APIResponse) {
        let deleteUrl = TASK_LIST_URL + "/" + todoItem.id
        makeAPIRequest(deleteUrl, method: "DELETE", postData: "", onCompletion: { data, err in
            onCompletion(data, err)
        })
        
    }
    
    func makeAPIRequest(path: String, method: String, postData: String, onCompletion: APIResponse) {
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        request.HTTPMethod = method
        
        if "POST" == method {
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //Set the ToDoItem Array here
            onCompletion(data!, error)
        })
        task.resume()
    }
    
}
