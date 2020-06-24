//
//  TasksTableViewController.swift
//  todo_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-23.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    
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
        func updateNote(with title: String) {
            tasks = []
            let newNote = Tasks(context: context)
            newNote.title = title
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
//
//               if let destination = segue.destination as? TaskViewController{
//                   destination.delegate = self
//
//                   if let cell =  sender as? UITableViewCell{
//                       if let index = tableView.indexPath(for: cell)?.row{
//                           destination.selectedNote = Tasks[index]
//                       }
//                   }
//               }
               
//               if let destination = segue.destination as? MoveToViewController{
//                   if let indexPaths = tableView.indexPathsForSelectedRows{
//                       let rows = indexPaths.map {$0.row}
//                       destination.selectedNotes = rows.map {notes[$0]}
//                                }
//               }
    }
    @IBAction func deleteBtn(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func moveToBtn(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func editTask(_ sender: UIBarButtonItem) {
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // if editemode is true should make it true
        
        guard identifier != "movePerformSegue" else {
            return true
        }
        
        return editMode ? false : true
    }


}
