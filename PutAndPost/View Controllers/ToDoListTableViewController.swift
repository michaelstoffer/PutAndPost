//
//  ToDoListTableViewController.swift
//  PutAndPost
//
//  Created by Michael Stoffer on 5/25/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    // MARK: - @IbOutlets and Variables
    @IBOutlet weak var textField: UITextField!
    
    private let todoController = TodoController()
    let pushMethod: PushMethod = .put

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchTodos()
    }
    
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoController.todos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let todo = self.todoController.todos[indexPath.row]
        cell.textLabel?.text = todo.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = self.todoController.todos[indexPath.row]
        
        let title: String
        switch pushMethod {
            case .put:
                title = "PUT Again"
            default:
                title = "POST Again"
        }
        
        let againAction = UIContextualAction(style: .normal, title: title) { (action, view, handler) in
            self.todoController.push(todo: todo, using: self.pushMethod, completion: { (error) in
                if let error = error {
                    NSLog("Error pushing todo to server again: \(error)")
                    return
                }
                
                self.fetchTodos()
                handler(true)
            })
        }
        
        againAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [againAction])
    }
    
    // MARK: - @IBActions and Methods
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = self.textField.text else { return }
        
        let todo = self.todoController.createTodo(with: title)
        self.textField.text = nil
        self.todoController.push(todo: todo, using: self.pushMethod) { (error) in
            if let error = error {
                NSLog("Error pushing Todo to server: \(error)")
                return
            }
            
            self.fetchTodos()
        }
    }
    
    func fetchTodos() {
        self.todoController.fetchTodos { (error) in
            if let error = error {
                NSLog("Error fetching our Todos: \(error)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
