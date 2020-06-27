//
//  ViewController.swift
//  todo_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-23.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
//    var taskTitle: String?
//    var days: Int32?
//    var date: Date?

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var noOfDays: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var taskDescription: UITextField!
    let datePickerView:UIDatePicker = UIDatePicker()
    
    
//    var tasks = [Tasks]()
    
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
        noOfDays.isEnabled = false
    }

    func addDatePicker(){
           
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        dateTxtField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(TaskViewController.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.medium

        dateFormatter.timeStyle = DateFormatter.Style.short

        dateTxtField.text = dateFormatter.string(from: sender.date)
        
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let assignedDate = calendar.startOfDay(for: sender.date)
        
        let components = calendar.dateComponents([.day], from: currentDate, to: assignedDate)
        
        noOfDays.text = String(components.day!)

    }
    
    @IBAction func addTask(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Are you sure you want to add the task?", message: "", preferredStyle: .alert)
               let addAction = UIAlertAction(title: "Yes", style: .default) { (action) in
           
               
                self.delegate?.updateNote(with: self.taskName.text!, days: Int(self.noOfDays.text!)!, date: self.datePickerView.date, description: self.taskDescription.text!)
                
                self.taskName.text = ""
                self.noOfDays.text = ""
                self.dateTxtField.text = ""
                self.taskDescription.text = ""
                
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "") as! TasksTableViewController
            
            self.navigationController?.popViewController(animated: true)
        
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
    
    
}

