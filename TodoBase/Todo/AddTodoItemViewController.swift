//
//  AddToDoItemViewController.swift
//  Todo
//

import UIKit

class AddTodoItemViewController: UIViewController {

    var todoItem: TodoItem = TodoItem(itemName: "", id: "")
    
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (self.textField.text!.characters.count > 0) {
            self.todoItem = TodoItem(itemName: self.textField.text!, id: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
