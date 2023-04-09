//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Mikhail Egorov on 29.03.2023.
//

import UIKit
import CoreData

protocol TaskViewControllerDelegate {
    func reloadData()
}

class TaskListViewController: UITableViewController {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // access to AppDelegate where has persistentContainer
    private let cellID = "task" // id Cell in tableview
    private var taskList: [Task] = [] // array for task
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
    }

    private func setupNavigationBar() {
        title = "Task List" // property title exists because we are inherited from the  UINavigationController in AppDelegate
        navigationController?.navigationBar.prefersLargeTitles = true // set large title
        
        // class UINavigationBarAppearance responsible for design NavigationBar
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        //add button
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self, // implementation in the class itself
            action: #selector(addNewTask)
        )
        //set color button
        navigationController?.navigationBar.tintColor = .white
        // set configuration to navigationController for standart and scroll condition
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @objc private func addNewTask() {
        let taskVC = TaskViewController()
        // initialize the property
        taskVC.delegate = self
        present(taskVC, animated: true)
    }
    
    private func fetchData() {
        // create request to database with indicate dataType
        let fetchRequest = Task.fetchRequest()
        
        //extracting data from database based on request
        do {
            taskList = try context.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        // set display data in cell:
        let task = taskList[indexPath.row] // current task
        var content = cell.defaultContentConfiguration() // create content for cell
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - TaskViewControllerDelegate
extension TaskListViewController: TaskViewControllerDelegate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
    }
}
