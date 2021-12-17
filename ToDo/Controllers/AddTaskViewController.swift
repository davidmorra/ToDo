//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Macbook on 12/17/21.
//

import UIKit

class AddTaskViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpNavigation()
        
        textFieldOutlet.addTarget(self, action: #selector(doneButtonTapped), for: .editingDidEndOnExit)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        textFieldOutlet.becomeFirstResponder()
    }
    
    func setUpNavigation() {
        title = "Add a task"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
    }
    
    @objc func doneButtonTapped() {
        print("text field: \(textFieldOutlet.text!)")
        navigationController?.popViewController(animated: true)
    }
    
}
