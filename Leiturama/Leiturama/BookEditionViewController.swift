//
//  BookEditionViewController.swift
//  Leiturama
//
//  Created by Danillo Oliveira on 29/04/19.
//  Copyright © 2019 Arthur Santos. All rights reserved.
//

import UIKit
import CoreData

class BookEditionViewController: UIViewController {
    var book: Book?
  
    @IBOutlet weak var vrBookCover: UIImageView!
    @IBOutlet weak var vrISBN: UITextField!
    @IBOutlet weak var vrTitulo: UITextField!
    @IBOutlet weak var vrAutores: UITextField!
    @IBOutlet weak var vrEditora: UITextField!
    @IBOutlet weak var vrCategorias: UITextField!
    @IBOutlet weak var vrPublicacaoData: UITextField!
    @IBOutlet weak var vrNumPaginas: UITextField!
    @IBOutlet weak var vrSinopse: UITextView!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true        
        // Do any additional setup after loading the view.
        setBook()
        vrISBN.text = book?.isbn
        vrBookCover.image = book?.cover as! UIImage
        vrTitulo.text = book?.title
        vrAutores.text = book?.author
        vrEditora.text = book?.publisher
        vrCategorias.text = book?.categories
        vrPublicacaoData.text = book?.publishedDate
        vrNumPaginas.text = book?.pageCount.description
        vrSinopse.text = book?.sinopse
    }
    
    
    func setBook(){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        //978-0553103540
        do{
            let result = try managedContext.fetch(fetchRequest)
            self.book = result[index] as! Book
        } catch{
            print("erro")
        }
    }
    
    func updateBook(){
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
            let book = result[index] as! Book
            book.isbn = vrISBN.text
            book.cover = vrBookCover.image
            book.title = vrTitulo.text
            book.author = vrAutores.text
            book.publisher = vrEditora.text
            book.categories = vrCategorias.text
            book.publishedDate = vrPublicacaoData.text
            book.pageCount = NSString(string: vrNumPaginas.text!).intValue
            book.sinopse = vrSinopse.text
            do{
                try managedContext.save()
                var nvc: UINavigationController =
                    self.parent as! UINavigationController
                nvc.popToRootViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
            } catch {
                print(error)
            }
            
        }catch{
            print("Failed")
        }
        
    }
    @IBAction func editBook(_ sender: Any) {
        updateBook()
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

