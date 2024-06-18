//
//  ViewController.swift
//  Tasks
//
//  Created by Will Childress on 2/26/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set("0", forKey: "count")
            //if first line is false there are initial defaults IE zero tasks
            
        }
        
        
        //Get all current saved tasks
        updateTasks()
    }
    
    func updateTasks() {
        
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        for x in 0..<count {
            
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String {
                tasks.append(task)
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    @IBAction func didTapAdd() { //creates Tap functionality
        
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)  //shows another ViewController to create an entry
        
    }
}
    
    
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //allows taps on a cell
        tableView.deselectRow(at: indexPath, animated: true)  //enables diselection
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! TaskViewController
        vc.title = "New Task"
        vc.task = tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)  //shows another ViewController to create an entry
    }
}
    
extension ViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tasks.count  //number of rows returning number of tasks in array}
            
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //returns cell for given row
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = tasks[indexPath.row]
            
            return cell //dequeues cell and returns it
        }
    }
    
