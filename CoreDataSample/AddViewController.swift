//
//  AddViewController.swift
//  CoreDataSample
//
//  Created by 藤井陽介 on 2019/03/22.
//  Copyright © 2019 touyou. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!

    var todo: Todo?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if let todo = todo {
            titleTextField.text = todo.title
            contentTextView.text = todo.content
        }
    }

    @IBAction func tapSaveButton(_ sender: Any) {

        let alertController = UIAlertController(title: "Add Todo", message: "Save todo ?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in

            guard let self = self else { return }

            let dataManager = DataManager.shared
            if self.todo != nil {

                self.todo?.title = self.titleTextField.text
                self.todo?.content = self.contentTextView.text
            } else {

                let todo: Todo = dataManager.create()
                todo.title = self.titleTextField.text
                todo.content = self.contentTextView.text
                todo.date = Date()
            }
            dataManager.saveContext()
            self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
