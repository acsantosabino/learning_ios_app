//
//  BooksTableViewController.swift
//  Leiturama
//
//  Created by Danillo Oliveira on 27/04/19.
//  Copyright © 2019 Arthur Santos. All rights reserved.
//

import UIKit
import CoreData

class BooksTableViewController: UITableViewController {
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tapRecognizer, placed in viewDidLoad
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    func loadData(){
        //books = ["Biblia Sagrada", "O impostor que vive em mim"]
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        //978-0553103540
        do{
            let result = try managedContext.fetch(fetchRequest)
            print(result.count)
            if(result.count>0){
                books = result as! [Book]
            }
        }catch{
            print("Failed")
        }
    }
    
    func removeIntem(index: Int){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let itemToDelete = books[index] as NSManagedObject
        
        managedContext.delete(itemToDelete)
        do{
            try managedContext.save()
            
        } catch{
            print("Failed")
        }
        
    }
    func refresh(){
        loadData()
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        let book = books[indexPath.row]
        let cover = book.cover as! UIImage
        cell.setBookInfo(image: cover, titulo: book.title!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        print(books[indexPath.row])
        performSegue(withIdentifier: "segueBookEdition", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.destination is BookEditionViewController
        {
            let vc = segue.destination as? BookEditionViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc?.index = indexPath.row
            }
        }
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let book = books[indexPath.row]
                // create the alert
                let alert = UIAlertController(title: "Delete", message: "O livro \(book.title!.uppercased()) sera removido", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.removeIntem(index: indexPath.row)
                    self.refresh()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)                // your code here, get the row for the indexPath or do whatever you want
            }
        }
    }
    
}
