//
//  FolderTableViewController.swift
//  todo_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-23.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class CategoryTableViewController: UITableViewController {
    
    var category = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var archieved = [Category]()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
         loadFolder()
//        archiveCategory()
        pushNotifications()
       
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func loadFolder() {
    let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
           category = try context.fetch(request)
        } catch  {
            print("Error Loading Folders: \(error.localizedDescription)")
        }
    }

    func savefolders()  {
        do {
            try context.save()
            self.tableView.reloadData()
        } catch  {
            print("Error Saving Folders: \(error.localizedDescription)")
        }
    }

    // MARK: - Table view data source
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = category[indexPath.row].name
//            cell.textLabel?.textColor = .lightGray
//            cell.detailTextLabel?.textColor = .lightGray
            cell.detailTextLabel?.text = "\(category[indexPath.row].tasks?.count ?? 0)"
            cell.imageView?.image = UIImage(systemName: "folder")

            return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    func pushNotifications() {
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            NotificationCenter.default.addObserver(self, selector: #selector(self.notifications), name: UIApplication.willResignActiveNotification, object: nil)
        } else if let error = error {
            print(error.localizedDescription)
            }
        }
    }
            @objc func notifications() {
                
                var tasks = [Tasks]()
                let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
                
                do {
                    tasks = try context.fetch(request)
                } catch  {
                    print("Error loading tasks: \(error.localizedDescription)")
                }
                
                let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .short
                
                for task in tasks{
                   
                    let calendar = Calendar.current
                    let date1 = calendar.startOfDay(for: Date())
                    let date2 = calendar.startOfDay(for: task.date!)
                    let components = calendar.dateComponents([.day], from: date1, to: date2)

                    if components.day! == 1 {

                        let content = UNMutableNotificationContent()
                        content.title = "Task due: \(task.title ?? "No title")"
                        content.sound = .default
                        content.body = "Due Date: \(task.date ?? Date())"

    //                    let targetDate = Date().addingTimeInterval(10)
                        var dateComponents = DateComponents()
                        dateComponents.hour = calendar.component(.hour, from: task.date!)
                        dateComponents.minute = calendar.component(.minute, from: task.date!)

                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //              let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                            if error != nil {
                                print("Error while generating notification: \(error?.localizedDescription)")
                            }
                        })
                    }
                }
            
    }
           

    
    
//    func archiveCategory() {
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            archieved = try context.fetch(request)
//        } catch {
//            print("Error while loading categories: \(error.localizedDescription)")
//        }
//
//        let archivedName = self.archieved.map{$0.name}
//            guard !archivedName.contains("Archive") else {
//                    return
//                }
//        let newCategory = Category(context: self.context)
//
//            newCategory.name = "Archive"
//            self.archieved.append(newCategory)
//            self.savefolders()
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       if let indexPath = tableView.indexPathForSelectedRow{
                   let destination = segue.destination as! TasksTableViewController

                   destination.selectedFolder = category[indexPath.row]
               }
    }
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Folder", message: "", preferredStyle: UIAlertController.Style.alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let folderNames = self.category.map{$0.name}
            guard !folderNames.contains(textField.text) else {
                return self.showAlert()
            }
            let newFolder = Category(context: self.context)
            
            newFolder.name = textField.text
            self.category.append(newFolder)
            self.savefolders()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // change the font color of cancel
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Category Name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert() {
          let alert = UIAlertController(title: "Alert", message: "Folder Name Already Exist", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          okAction.setValue(UIColor.orange, forKey: "titleTextColor")
          alert.addAction(okAction)
          present(alert, animated: true, completion: nil)
      }

}
