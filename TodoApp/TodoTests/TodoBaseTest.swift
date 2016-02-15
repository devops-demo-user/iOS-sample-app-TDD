//
//  TodoBaseTest.swift
//  Todo
//
//

import XCTest

class TodoBaseTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: TodoItem Model Tests
    // Tests to confirm that the TodoItem initalize and stores the correct property.
    
    func testTodoItemInitialization() {
        
        let testTodoItem = TodoItem(itemName: "Test task 0", id: "id0", completed: false);
        XCTAssertNotNil(testTodoItem);
        XCTAssertEqual(testTodoItem.itemName, "Test task 0", "itemName should always be set")
    }

}
