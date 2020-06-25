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
           let categoryPredicate = NSPredicate(format: "NOT name MATCHES %@", selectedNotes?[0].parentCategory?.name ?? "")
              request.predicate = categoryPredicate
              
            do {
                category = try context.fetch(request)
    //            print(folders.count)
            } catch  {
                print("Error fetching data of categories: \(error.localizedDescription)")
            }
        }
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

extension MoveToViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "moveToCell")
        
        cell.textLabel?.text = category[indexPath.row].name
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .red
        cell.tintColor = .lightText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Move to \(category[indexPath.row].name!)", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Move", style: .default) { (action) in
            for note in self.selectedNotes! {
                note.parentCategory = self.category[indexPath.row]
            }
            self.performSegue(withIdentifier: "dismissMoveView", sender: self)
            self.dismiss(animated: true, completion: nil)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
        
    }
    

    
}
