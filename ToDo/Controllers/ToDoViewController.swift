//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Macbook on 12/17/21.
//

import UIKit

class ToDoViewController: UITableViewController {
    var items = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigation()
        
        let item1 = ToDoListItem()
        item1.text = "Hello"; item1.isDone = true
        items.append(item1)
        
        let item2 = ToDoListItem()
        item2.text = "World"
        items.append(item2)
        
        let item3 = ToDoListItem()
        item3.text = "Clean room"
        items.append(item3)
        
        let item4 = ToDoListItem()
        item4.text = "Walk the dog"; item4.isDone = true
        items.append(item4)
        
        let item5 = ToDoListItem()
        item5.text = "Cook"; item5.isDone = true
        items.append(item5)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    func setUpNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addToTableView))
    }
    
    @objc func addToTableView() {
//        let addToDoVC = AddTaskViewController()
        let addTaskViewController = storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        
        
        navigationController?.pushViewController(addTaskViewController, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = items[indexPath.row].text
        cell.accessoryType = items[indexPath.row].isDone ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            items[indexPath.row].isDone.toggle()
            if items[indexPath.row].isDone {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Swipe-to-Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}
