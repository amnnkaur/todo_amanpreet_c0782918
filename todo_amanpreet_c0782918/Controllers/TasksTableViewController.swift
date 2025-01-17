//
//  TasksTableViewController.swift
//  todo_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-23.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, UISearchResultsUpdating{
    
    
    @IBOutlet weak var trashBtn: UIBarButtonItem!
    @IBOutlet weak var moveToBtn: UIBarButtonItem!
    
    var resultSearchController = UISearchController()
    var filteredTableData = [String]()
    
    var archivedCategory = [Category]()
    var daysnumber = "0"
    
    
    let pickADate = UIDatePicker()
    var dateField = UITextField()
    
    var taskValue: String?
    var tasks = [Tasks]()
    var selectedFolder: Category? {
        //observer for checking filled or not
        didSet {
            loadNotes()
        }
    }
   
   
    
    var editMode: Bool = false
    
    // create context
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        
        loadArchive()
        
    
    
       
//        datePickerView.addTarget(self, action: #selector(TasksTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)

        
       
    }
    
   func generatePicker(){
            
          pickADate.datePickerMode = UIDatePicker.Mode.dateAndTime

            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            //bar button
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
            toolbar.setItems([doneBtn], animated: true)
            
            dateField.inputAccessoryView = toolbar
            dateField.inputView = pickADate
        }
        
        @objc func donePressed() {
           
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            dateField.text = formatter.string(from: pickADate.date)
    //        self.datePicker.endEditing(true)

            self.dateField.endEditing(true)
        }
    
    override func viewWillAppear(_ animated: Bool) {
           
           tableView.reloadData()
           
       }
    
    func loadArchive() {
          
                 let request: NSFetchRequest<Category> = Category.fetchRequest()
                               
                 // predicate if you want
                 let categoryPredicate = NSPredicate(format: "name MATCHES %@", "Archive")
                     request.predicate = categoryPredicate
                               
                 do {
                             archivedCategory = try context.fetch(request)
                     //            print(folders.count)
                 } catch  {
                         print("Error fetching data of categories: \(error.localizedDescription)")
                     }
                    
      }

    
     func loadNotes(with predicate: NSPredicate? = nil) {
               let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
                       let categoryPredicate = NSPredicate(format: "parentCategory.name=%@", selectedFolder!.name!)
                       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                       
                       if let newPredicate = predicate{
                           request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, newPredicate])
                       } else {
                           request.predicate = categoryPredicate
                       }
                       
                       do {
                           tasks = try context.fetch(request)
                       } catch  {
                           print("Error loading tasks: \(error.localizedDescription)")
                       }
                   
                       tableView.reloadData()
           }
    
    //MARK: delete note
       func deleteNote(task: Tasks) {
           context.delete(task)
       }
       
       //MARK: saveNote
       func saveNote() {
           do {
               try context.save()
           } catch  {
               print("Error saving the context: \(error.localizedDescription)")
           }
       }
    
    func loadArchiveCategory() {
           
                  let request: NSFetchRequest<Category> = Category.fetchRequest()
                                
                  // predicate if you want
                  let categoryPredicate = NSPredicate(format: "name MATCHES %@", "Archive")
                      request.predicate = categoryPredicate
                                
                  do {
                              archivedCategory = try context.fetch(request)
                      //            print(folders.count)
                  } catch  {
                          print("Error fetching data of categories: \(error.localizedDescription)")
                      }
                     
       }

    //MARK: update note
    func updateNote(with title: String, days: Int, date: Date, description: String) {
        
        let formatter = DateFormatter()
                            formatter.dateStyle = .medium
                            formatter.timeStyle = .short
            tasks = []
            let newNote = Tasks(context: context)
            newNote.title = title
            newNote.days = Int32(days)
            newNote.date = date
            newNote.taskDesc = description
            newNote.parentCategory = selectedFolder
    //        notes.append(newNote)
            saveNote()
            loadNotes()
        }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
            return tasks.count
        
    }

    override func tableView(_ tableView: UITableView,
      contextMenuConfigurationForRowAt indexPath: IndexPath,
      point: CGPoint) -> UIContextMenuConfiguration? {

//        let favorite = UIAction(title: "Favorite") { _ in print("fav") }
//        let share = UIAction(title: "Move To") { _ in print("share")}
//
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"),
        attributes: .destructive) { _ in
            
        
           
            self.deleteNote(task: self.tasks[indexPath.row])
            self.saveNote()
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
           
                      }

      return UIContextMenuConfiguration(identifier: nil,
        previewProvider: nil) { _ in
        UIMenu(title: "Actions", children: [ delete])
      }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
          let task = tasks[indexPath.row]
        
        let formatter = DateFormatter()
                     formatter.dateStyle = .medium
                     formatter.timeStyle = .short
        formatter.dateFormat = "MMM d, h:mm a"
       
        cell.textLabel?.text = (task.title)
        if task.days >= 0 {
             cell.detailTextLabel?.text = "Days: \(task.days)                             Due Date: \(formatter.string(from: task.date!))"
        }
        else {
            cell.detailTextLabel?.text = "Your task is overdue by Due date"
        }

            let backgroundView = UIView()
            backgroundView.backgroundColor = .lightGray
            cell.selectedBackgroundView = backgroundView
        
        if task.date! >= Date(){
            cell.backgroundColor = .green
        }else{
            cell.backgroundColor = .red
        }
      

            return cell
        
        
        
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

         let days = UITableViewRowAction(style: .normal, title: "Add Days") { (rowaction, indexPath) in
                       
          let alertcontroller = UIAlertController(title: "Enter new Date", message: "", preferredStyle: .alert)
                                         
            alertcontroller.addTextField { (textField ) in
           
                self.dateField = textField
                self.generatePicker()
                self.saveNote()
                self.loadNotes()
                                        }
            
            
                let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            CancelAction.setValue(UIColor.black, forKey: "titleTextColor")
                                         let AddAction = UIAlertAction(title: "Add", style: .default){
                                             (action) in
                                          let count = alertcontroller.textFields?.first?.text
                                            
                                            let oldDate = self.tasks[indexPath.row].date
                                            let newDate = self.pickADate.date
                                            let todayDate = Date()
                                            
                                            let calendar = Calendar.current
                                                  let currentDate = calendar.startOfDay(for: todayDate)
                                                  let assignedDate = calendar.startOfDay(for: newDate)
                                                  
                                                  let components = calendar.dateComponents([.day], from: currentDate, to: assignedDate)
                                            
                                            self.tasks[indexPath.row].days = Int32(components.day!)
                                            self.tasks[indexPath.row].date = self.pickADate.date
                                            
                                            self.saveNote()
                                            self.loadNotes()
                                          
                                              self.tableView.reloadData()
                                      }
                                  AddAction.setValue(UIColor.black, forKey: "titleTextColor")
                                                       alertcontroller.addAction(CancelAction)
                                                       alertcontroller.addAction(AddAction)
                                                       self.present(alertcontroller, animated: true, completion: nil)}
        days.backgroundColor = .systemIndigo

         let deletetask = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in

          let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let ManagedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskArray")
             do{
                 let data = try ManagedContext.fetch(fetchRequest)
                 let taskitem = data[indexPath.row] as? NSManagedObject
                self.tasks.remove(at: indexPath.row)
              ManagedContext.delete(taskitem!)
                 tableView.reloadData()
                 do{
                             try ManagedContext.save()
                     }
             catch{
                  print(error)
              }
             }
             catch{
                 print(error)
             }
                    }
                deletetask.backgroundColor = UIColor.red
                return [deletetask,days]
      }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                deleteNote(task: tasks[indexPath.row])
                saveNote()
                tasks.remove(at: indexPath.row)
                       
                       // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//        return nil
//    }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        

               if let destination = segue.destination as? TaskViewController{
                   destination.delegate = self

                   if let cell =  sender as? UITableViewCell{
                       if let index = tableView.indexPath(for: cell)?.row{
                        destination.selectedNote = tasks[index]
                       }
                   }
               }
               
               if let destination = segue.destination as? MoveToViewController{
                   if let indexPaths = tableView.indexPathsForSelectedRows{
                       let rows = indexPaths.map {$0.row}
                       destination.selectedNotes = rows.map {tasks[$0]}
                                }
               }
    }
    @IBAction func deleteBtn(_ sender: UIBarButtonItem) {
        if let indexPaths = tableView.indexPathsForSelectedRows{
                   let rows = (indexPaths.map {$0.row}).sorted(by: >)
                   let _  = rows.map{deleteNote(task: tasks[$0])}
                   let _ = rows.map {tasks.remove(at: $0)}
                   
                   tableView.reloadData()
                   
                   saveNote()
               }
    }
    
    @IBAction func editTask(_ sender: UIBarButtonItem) {
              editMode = !editMode
               tableView.setEditing(editMode ? true: false, animated: true)
               trashBtn.isEnabled = !trashBtn.isEnabled
               moveToBtn.isEnabled = !moveToBtn.isEnabled
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // if editemode is true should make it true
        
        guard identifier != "movePerformSegue" else {
            return true
        }
        
        return editMode ? false : true
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
        let text = searchController.searchBar.text
        var titlePredicate: NSPredicate = NSPredicate()
        titlePredicate = NSPredicate(format: "title CONTAINS[cd] '\(text ?? "")'")
        loadNotes(with: titlePredicate)
    }
    
    @IBAction func sortBtn(_ sender: UIBarButtonItem) {
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
           let categoryPredicate = NSPredicate(format: "parentCategory.name=%@", selectedFolder!.name!)
           request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
           request.predicate = categoryPredicate
           
           do {
               tasks = try context.fetch(request)
           } catch  {
               print("Error loading tasks: \(error.localizedDescription)")
           }
       
           tableView.reloadData()
        
    }
    

    @IBAction func unwindToTasksTableVC(_ unwindSegue: UIStoryboardSegue) {
    //        let sourceViewController = unwindSegue.source
            // Use data from the view controller which initiated the unwind segue
           
            saveNote()
            loadNotes()
            
            self.tableView.reloadData()
            
            tableView.setEditing(false, animated: false)
        }

}

