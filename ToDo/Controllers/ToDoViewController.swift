//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Macbook on 12/17/21.
//

import UIKit

class ToDoViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigation()
        
        loadToDoListItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    //MARK: - File Path
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Todo.plist")
    }
    
    //MARK: Saving data to a File
    func saveToDoListItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: .atomic)
            
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    //MARK: Load the data
    func loadToDoListItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                items = try decoder.decode([ToDoListItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Setup work
    func setUpNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        let ItemDetailViewController = storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! ItemDetailViewController
        ItemDetailViewController.delegate = self
        ItemDetailViewController.title = "Add a task"
        
        navigationController?.pushViewController(ItemDetailViewController, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        cell.accessoryType = .detailDisclosureButton
        
        // cell text
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = items[indexPath.row].text

        // checkmark image
        let chekImage = items[indexPath.row].isDone ? "checkmark.circle.fill" : "circle"
        let checkmarkImage = cell.viewWithTag(1001) as! UIImageView
        checkmarkImage.image = UIImage(systemName: chekImage)
        
        return cell
    }
    
    
    // Tap on cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isDone.toggle()
        
        saveToDoListItems()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let addTaskViewController = storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! ItemDetailViewController
        addTaskViewController.title = "Edit Item"
        addTaskViewController.delegate = self
        addTaskViewController.textFieldOutlet?.text = "\(items[indexPath.row].text)"
        addTaskViewController.itemToEdit = items[indexPath.row]
        
        navigationController?.pushViewController(addTaskViewController, animated: true)
    }
    
    
    //MARK: - Swipe-to-Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        saveToDoListItems()
    }

    //MARK: - Protocol methods
    func ItemDetailViewController(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ToDoListItem) {
        let index = items.count
        let indexPath = IndexPath(row: index, section: 0)
        
        items.append(item)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        saveToDoListItems()
        
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ToDoListItem) {
        
        if let index = items.firstIndex(where: { $0.text == item.text }) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        saveToDoListItems()
        
        navigationController?.popViewController(animated: true)
    }
    
}
