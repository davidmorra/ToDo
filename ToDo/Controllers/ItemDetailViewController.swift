//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Macbook on 12/17/21.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
    func ItemDetailViewController(_ controller: ItemDetailViewController)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ToDoListItem)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ToDoListItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ToDoListItem?
    
    // MARK: - View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigation()
        
        setUpTextField()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.ItemDetailViewController(self)
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
    
    func setUpTextField() {
        textFieldOutlet.delegate = self

        textFieldOutlet.addTarget(self, action: #selector(doneButtonTapped), for: .editingDidEndOnExit)
        textFieldOutlet.enablesReturnKeyAutomatically = true
        
        textFieldOutlet.text = itemToEdit?.text ?? ""
        

    }
    
    
    @objc func doneButtonTapped() {
        
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textFieldOutlet.text!
            delegate?.ItemDetailViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = ToDoListItem()
            item.text = textFieldOutlet.text!
            delegate?.ItemDetailViewController(self, didFinishAdding: item)
        }
    }
}
