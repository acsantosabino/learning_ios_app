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
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        let book = books[indexPath.row]
        cell.setBookInfo(image: #imageLiteral(resourceName: "cruz"), titulo: book.title!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        print(books[indexPath.row])
    }

}
