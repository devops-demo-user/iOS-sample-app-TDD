//
//  TodoTests.swift
//  TodoTests
//

import UIKit
import XCTest

class APIManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Test to fetch task Data
    func testFetchTaskData() {
        
        let expectation = expectationWithDescription("")
        
        APIManager.sharedInstance.fetchAllTasks({(data, error) in
            
            
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
           
                do {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [NSObject] {
                        print("tasks \(jsonObject)")
                        for taskItem in jsonObject {
                            if let taskObject = taskItem as? [NSObject:AnyObject] {
                                let todoName = taskObject["task"] as! String!
                                let id = taskObject["id"] as! String!
                                let todoItem = TodoItem(itemName: todoName, id: id)
                                // Test the taskItem as valid
                                XCTAssertNotNil(todoItem)
                                XCTAssertNotNil(todoItem.itemName, "item cotnains itemName property")
                                
                                
                            }
                        }
                        expectation.fulfill()
                        
                    }
                }
                catch {
                    print("error2: " );
                }
            
        })
    
        
        waitForExpectationsWithTimeout(5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
        
    }
    
    func testAddTaskData() {
        
        let expectation = expectationWithDescription("")
        
        let todoItem = TodoItem(itemName: "XCTest add item", id: "")
        
        APIManager.sharedInstance.addTask(todoItem, onCompletion: {(data, error) in
            
            expectation.fulfill()
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")

            let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            if let parseJSON = json as NSDictionary! {
                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                let success = parseJSON["ok"] as? Int
                print("Succes: \(success!)")
                XCTAssert(success == 1)
                
                // clean up the added todo task by deleting it
                if let addedItemId = parseJSON["id"] as? String {
                    let todoItem = TodoItem(itemName: "", id: addedItemId)
                    APIManager.sharedInstance.deleteTask(todoItem, onCompletion: {(data, error) in
                        print("deleteTask for the added task is executed")
                    })
                }
                else {
                    XCTFail("add task operation failed without an id in response")
                }
            } else {
                XCTFail("add operation did not return proper json output")
            }
           
        })
        
        
        waitForExpectationsWithTimeout(5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
        
    }
    
    func testDeleteTaskData() {
        
        let expectation = expectationWithDescription("")
        
        let todoItem = TodoItem(itemName: "XCTest delete item", id: "")
        
        // first add a todo task
        APIManager.sharedInstance.addTask(todoItem, onCompletion: {(data, error) in
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            if let parseJSON = json as NSDictionary! {
                let addedItemId = parseJSON["id"] as? String
                XCTAssertNotNil(addedItemId!)
                let todoItem2 = TodoItem(itemName: "", id: addedItemId!)
                
                // then delete the added todo task
                APIManager.sharedInstance.deleteTask(todoItem2, onCompletion: {(data, error) in
                    
                    expectation.fulfill()
                    XCTAssertNotNil(data, "delete data should not be nil")
                    XCTAssertNil(error, "delete error should be nil")
                    
                    let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
                    if let parseJSON = json as NSDictionary! {
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        let success = parseJSON["ok"] as? Int
                        print("Succes: \(success!)")
                        XCTAssert(success == 1)
                        
                        let addedItemId2 = parseJSON["id"] as? String
                        XCTAssertNotNil(addedItemId2!)
                        
                    } else {
                        XCTFail("delete operation did not return proper json output")
                    }
                    
                })
                
            } else {
                XCTFail("delete operation did not return proper json output")
            }
            
        })
        
        
        waitForExpectationsWithTimeout(5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
        
    }

}
