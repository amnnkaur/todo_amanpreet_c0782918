//
//  TasksTableViewController.swift
//  todo_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-23.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    
    @IBOutlet weak var trashBtn: UIBarButtonItem!
    @IBOutlet weak var moveToBtn: UIBarButtonItem!
    
  var resultSearchController = UISearchController()
    var filteredTableData = [String]()
    
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
        
        }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
           
           tableView.reloadData()
           
       }

    
     func loadNotes() {
               let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
               let folderPredicate = NSPredicate(format: "parentCategory.name=%@", selectedFolder!.name!)
               request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
               request.predicate = folderPredicate
               
               do {
                   tasks = try context.fetch(request)
               } catch {
                   print("Error loading notes: \(error.localizedDescription)")
               }
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

    //MARK: update note
    func updateNote(with title: String, days: Int, date: String) {
            tasks = []
            let newNote = Tasks(context: context)
            newNote.title = title
            newNote.days = Int32(days)
            newNote.date = date
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
          let task = tasks[indexPath.row]
       
            cell.textLabel?.text = task.title
            cell.detailTextLabel?.text = task.date
            let backgroundView = UIView()
            backgroundView.backgroundColor = .lightGray
            cell.selectedBackgroundView = backgroundView

            return cell
        
        
        
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    @IBAction func sortBtn(_ sender: UIBarButtonItem) {
        
        
        
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
