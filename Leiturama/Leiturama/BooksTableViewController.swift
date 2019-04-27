//
//  BooksTableViewController.swift
//  Leiturama
//
//  Created by Danillo Oliveira on 27/04/19.
//  Copyright © 2019 Arthur Santos. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController {
    var books: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        books = ["Biblia Sagrada", "O impostor que vive em mim"]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)
        cell.textLabel?.text = books[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        print(books[indexPath.row])
    }

}
