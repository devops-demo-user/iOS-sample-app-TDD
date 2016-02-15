//
//  ToDoListTableTableViewController.swift
//  Todo
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    var todoItems: [TodoItem] = [
        TodoItem(itemName: "Build base iOS Swift app", id: "1"),
        TodoItem(itemName: "Cloud enable the app", id: "2"),
        TodoItem(itemName: "Test-Driven Development", id: "3")
    ]

    
    @IBAction func unwindAndAddToList(segue: UIStoryboardSegue) {
        let source = segue.sourceViewController as! AddTodoItemViewController
        let todoItem:TodoItem = source.todoItem
        
        if todoItem.itemName != "" {
            self.todoItems.append(todoItem)
            addTodo(todoItem)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func editPressed(sender: AnyObject) {
        print("edit pressed")
        tableView.editing = !tableView.editing
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let tappedItem = todoItems[indexPath.row] as TodoItem
        tappedItem.completed = !tappedItem.completed
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tempCell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell")! as UITableViewCell
        let todoItem = todoItems[indexPath.row]
        
        // Downcast from UILabel? to UILabel
        let cell = tempCell.textLabel as UILabel!
        cell.text = todoItem.itemName
        
        if (todoItem.completed) {
            tempCell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        } else {
            tempCell.accessoryType = UITableViewCellAccessoryType.None;
        }
        
        return tempCell
    }
    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            // If the table view is asking to commit a delete command...
            if editingStyle == .Delete {
                let item = todoItems[indexPath.row]
                
                let title = "Delete \(item.itemName)?"
                let message = "Are you sure you want to delete this item?"
                
                let ac = UIAlertController(title: title,
                    message: message,
                    preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                ac.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                    // Remove the item from the store
                    let todoItem = self.todoItems[indexPath.row]
                    self.removeTodo(todoItem)
                    
                    self.todoItems.removeAtIndex(indexPath.row)

                    // Also remove that row from the table view with an animation
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
                ac.addAction(deleteAction)
                
                ac.modalPresentationStyle = .Popover
                
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    ac.popoverPresentationController?.sourceView = cell
                    ac.popoverPresentationController?.sourceRect = cell.bounds
                }
                
                presentViewController(ac, animated: true, completion: nil)
            }
    }
    
    func fetchAllTasks() {
        #if CLOUD
        todoItems = []
        APIManager.sharedInstance.fetchAllTasks({(data, error) in
            
            do {
                if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [NSObject] {
                    print("TDD tasks \(jsonObject)")
                    for taskItem in jsonObject {
                        if let taskObject = taskItem as? [NSObject:AnyObject] {
                            let todoName = taskObject["task"] as! String!
                            let id = taskObject["id"] as! String!
                            let todoItem = TodoItem(itemName: todoName, id: id)
                            self.todoItems.append(todoItem)
                            
                            
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.tableView.reloadData()
                    }
                    
                }
            }
            catch {
                print("error2: " );
            }
            
        })
        #endif
    }
    
    func addTodo(todoItem: TodoItem) {
        #if CLOUD
        APIManager.sharedInstance.addTask(todoItem, onCompletion: {(data, error) in
            let strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            print("result data: ");
            print(json)
            //completion(result: json as NSDictionary?)
            
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(error != nil) {
                print(error!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                print("addTodo: Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json as NSDictionary! {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    let success = parseJSON["ok"] as? Int
                    print("Succes: \(success!)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    _ = NSString(data: data, encoding: NSUTF8StringEncoding)
                    // println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        #endif
    }
    
    func removeTodo(todoItem: TodoItem) {
        #if CLOUD
        APIManager.sharedInstance.deleteTask(todoItem, onCompletion: checkOperationResult)
        #endif
    }
   
    func checkOperationResult(data: NSData, error: NSError?) {
        let strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("Body: \(strData)")
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
        print("result data: ");
        print(json)
        //completion(result: json as NSDictionary?)
        
        
        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
        if(error != nil) {
            print(error!.localizedDescription)
            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            print("addTodo: Error could not parse JSON: '\(jsonStr)'")
        }
        else {
            // The JSONObjectWithData constructor didn't return an error. But, we should still
            // check and make sure that json has a value using optional binding.
            if let parseJSON = json as NSDictionary! {
                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                let success = parseJSON["ok"] as? Int
                print("Succes: \(success!)")
            }
            else {
                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                _ = NSString(data: data, encoding: NSUTF8StringEncoding)
                // println("Error could not parse JSON: \(jsonStr)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("fetch all tasks")
        fetchAllTasks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
}
