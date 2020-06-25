//
//  ViewController.swift
//  todo_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-23.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
//
//    var taskTitle: String?
//    var days: Int32?
//    var date: Date?

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var noOfDays: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    
    
    var tasks = [Tasks]()
    
    var selectedNote: Tasks? {
            didSet{
                // write code later
                editMode = true
            }
        }
       
        var editMode: Bool = false
        
    // delegate for noteTable VC
        var delegate: TasksTableViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addDatePicker()
    }

    func addDatePicker(){
           
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        dateTxtField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(TaskViewController.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.medium

        dateFormatter.timeStyle = DateFormatter.Style.short

        dateTxtField.text = dateFormatter.string(from: sender.date)

    }
    
    @IBAction func addTask(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Are you sure you want to add the task?", message: "", preferredStyle: .alert)
               let addAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                   let taskVar = self.tasks.map {$0.title}

                guard !taskVar.contains(self.taskName.text) else {
                       return self.showAlert()
                   }
                
                self.taskName.text = self.selectedNote?.title
//                self.noOfDays.text = self.selectedNote?.days
                self.dateTxtField.text = self.selectedNote?.date

//                   self.updateTask(with: taskName.text!, description: noOfDays.text!, date: self.dateTxtField.text)
               }
               
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                     // change the font color of cancel
                cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
                     
               alert.addAction(addAction)
               alert.addAction(cancelAction)
               
              
                present(alert, animated: true, completion: nil)
          }
          
          func showAlert() {
               let alert = UIAlertController(title: "Alert", message: "Task already exists", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               okAction.setValue(UIColor.red, forKey: "titleTextColor")
               alert.addAction(okAction)
               present(alert, animated: true, completion: nil)
           }
        
        override func viewWillDisappear(_ animated: Bool) {
            if editMode{
                delegate!.deleteNote(task: selectedNote!)
            }
            delegate?.updateNote(with: taskName.text!, days: Int(noOfDays.text!)!, date: dateTxtField.text!)
        }
    
    
}

