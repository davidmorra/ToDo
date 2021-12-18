//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Macbook on 12/17/21.
//

import UIKit

protocol AddTaskViewControllerDelegate: AnyObject {
    func addTaskViewControllerDidCancel(_ controller: AddTaskViewController)
    func addTaskViewController(_ controller: AddTaskViewController, didFinishAdding item: ToDoListItem)
}

class AddTaskViewController: UITableViewController, UITextFieldDelegate {

    weak var delegate: AddTaskViewControllerDelegate?
    
    // MARK: - View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldOutlet.delegate = self
        
        setUpNavigation()
        
        textFieldOutlet.addTarget(self, action: #selector(doneButtonTapped), for: .editingDidEndOnExit)
        textFieldOutlet.enablesReturnKeyAutomatically = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.addTaskViewControllerDidCancel(self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        textFieldOutlet.becomeFirstResponder()
    }

    
    
    // MARK: - Outlets
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    
    // MARK: - Setup work
    func setUpNavigation() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
    }
    
    
    @objc func doneButtonTapped() {
        let item = ToDoListItem()
        item.text = textFieldOutlet.text!
        
        delegate?.addTaskViewController(self, didFinishAdding: item)
        
//        navigationController?.popViewController(animated: true)
    }
}
