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
    }
    
    func addTodo(todoItem: TodoItem) {
    }
    
    func removeTodo(todoItem: TodoItem) {
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
