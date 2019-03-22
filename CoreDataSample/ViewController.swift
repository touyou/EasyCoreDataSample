//
//  ViewController.swift
//  CoreDataSample
//
//  Created by 藤井陽介 on 2019/03/22.
//  Copyright © 2019 touyou. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {

            tableView.register(UINib(nibName: String(describing: TodoTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TodoTableViewCell.self))
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }

    lazy var fetchedResultsController: NSFetchedResultsController<Todo> = {

        let _controller: NSFetchedResultsController<Todo> = dataController.getFetchedResultController(with: ["date"])
        _controller.delegate = self
        return _controller
    }()

    let dataController = DataController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        do {

            try fetchedResultsController.performFetch()
        } catch {

            print(error)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toAdd" {
            let viewController = segue.destination as! AddViewController
            viewController.todo = sender as? Todo
        }
    }

    @IBAction func tapAddButton(_ sender: Any) {
        performSegue(withIdentifier: "toAdd", sender: nil)
    }
}


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {

        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }

        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: TodoTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TodoTableViewCell.self), for: indexPath) as! TodoTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }

    func configureCell(_ cell: TodoTableViewCell, at indexPath: IndexPath) {

        let todo = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = todo.title
        cell.contentLabel.text = todo.content
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        cell.dateLabel.text = formatter.string(from: todo.date ?? Date())
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let todo = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "toAdd", sender: todo)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath,
                let cell = tableView.cellForRow(at: indexPath) as? TodoTableViewCell {
                configureCell(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath,
                let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        tableView.endUpdates()
    }
}
