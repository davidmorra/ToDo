//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Macbook on 12/17/21.
//

import UIKit

class ToDoViewController: UITableViewController, AddTaskViewControllerDelegate {
    
    var items = [ToDoListItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = ToDoListItem()
        item1.text = "Hello"; item1.isDone = true
        items.append(item1)
        
        let item2 = ToDoListItem()
        item2.text = "Hello"; item2.isDone = false

        items.append(item2)
        
        setUpNavigation()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    //MARK: - Setup work
    func setUpNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        let addTaskViewController = storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        addTaskViewController.delegate = self
        addTaskViewController.title = "Add a task"
        
        navigationController?.pushViewController(addTaskViewController, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        
        // cell text
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = items[indexPath.row].text

        // checkmark image
        let chekImage = items[indexPath.row].isDone ? "checkmark.circle.fill" : "circle"
        let checkmarkImage = cell.viewWithTag(1001) as! UIImageView
        checkmarkImage.image = UIImage(systemName: chekImage)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        item.isDone.toggle()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let addTaskViewController = storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        addTaskViewController.title = "Edit Item"
        addTaskViewController.delegate = self
        addTaskViewController.textFieldOutlet?.text = "\(items[indexPath.row].text)"
        
        print(items[indexPath.row].text)
        
        navigationController?.pushViewController(addTaskViewController, animated: true)
    }
    
    
    //MARK: - Swipe-to-Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    //MARK: - Protocol methods
    func addTaskViewControllerDidCancel(_ controller: AddTaskViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addTaskViewController(_ controller: AddTaskViewController, didFinishAdding item: ToDoListItem) {
        let index = items.count
        let indexPath = IndexPath(row: index, section: 0)
        
        items.append(item)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
}
