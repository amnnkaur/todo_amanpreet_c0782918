//
//  MoveToViewController.swift
//  todo_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-23.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit
import CoreData

class MoveToViewController: UIViewController {
    
    
       var category = [Category]()
       ///computed property
       var selectedNotes: [Tasks]? {
           didSet{
               loadFolders()
           }
       }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadFolders() {
            
        let request: NSFetchRequest<Category> = Category.fetchRequest()
              
    // predicate if you want
              /*
               write your code here
               */
              
            do {
                category = try context.fetch(request)
    //            print(folders.count)
            } catch  {
                print("Error fetching data of folders: \(error.localizedDescription)")
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
