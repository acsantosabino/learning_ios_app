//
//  BookRegisterViewController.swift
//  Leiturama
//
//  Created by Arthur Santos on 27/04/19.
//  Copyright © 2019 Arthur Santos. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage

class BookRegisterViewController: UIViewController {

    @IBOutlet weak var vrBookCover: UIImageView!
    @IBOutlet weak var vrTitulo: UITextField!
    @IBOutlet weak var vrAutores: UITextField!
    @IBOutlet weak var vrEditora: UITextField!
    @IBOutlet weak var vrCategorias: UITextField!
    @IBOutlet weak var vrPublicacaoData: UITextField!
    @IBOutlet weak var vrNumPaginas: UITextField!
    @IBOutlet weak var vrSinopse: UITextView!
    
    var book: Book!
    
    var context:NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func parseJSON() {
        self.book = Book(context: context)
        Alamofire.request("https://www.googleapis.com/books/v1/volumes?q=9788580631036+isbn").responseJSON{
            response in
            
            if let json = response.result.value as? [String:Any]
            {
                if let items = json["items"] as? [[String:Any]],
                    let volumeInfo = items[0]["volumeInfo"] as? [String:Any] {
                    print(volumeInfo)
                    if let isbnArray = volumeInfo["industryIdentifiers"] as? [[String:Any]],
                    let isbn = isbnArray[0]["identifier"] as? String {
                        self.book.isbn = isbn
                    }
                    if let titulo = volumeInfo["title"] as? String {
                        self.vrTitulo.text = titulo
                        if let subtitulo = volumeInfo["subtitle"] as? String {
                            self.vrTitulo.text = "\(titulo): \(subtitulo)"
                        }
                    }
                    if let autores = volumeInfo["authors"] as? [String] {
                        var aux: String = ""
                        for autor in autores {
                            aux += "\(autor), "
                        }
                        self.vrAutores.text = String(aux.dropLast(2))
                    }
                    if let editora = volumeInfo["publisher"] as? String {
                        self.vrEditora.text = editora
                    }
                    if let publicacaoData = volumeInfo["publishedDate"] as? String {
                        self.vrPublicacaoData.text = publicacaoData
                    }
                    if let sinopse = volumeInfo["description"] as? String {
                        self.vrSinopse.text = sinopse
                    }
                    if let numPaginas = volumeInfo["pageCount"] as? Int {
                        self.vrNumPaginas.text = String(numPaginas)
                    }
                    if let categorias = volumeInfo["categories"] as? [String] {
                        var aux1: String = ""
                        for categoria in categorias {
                            aux1 += "\(categoria), "
                        }
                        self.vrCategorias.text = String(aux1.dropLast(2))
                    }
                    if let imageLinks = volumeInfo["imageLinks"] as? [String:Any],
                        let cover = imageLinks["thumbnail"] as? String {
                        Alamofire.request(cover).responseImage { response in
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                self.vrBookCover.image = image
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    func fillView(){
        print(self.book)
        
        if let cover = self.book.cover as? UIImage{
            vrBookCover.image = cover
        }
        if self.book.title != nil{
            vrTitulo.text = self.book.title
        }
        if self.book.author != nil{
            vrAutores.text = self.book.author
        }
        if self.book.publishedDate != nil{
            vrEditora.text = self.book.publisher
        }
        if self.book.categories != nil{
            vrCategorias.text = self.book.categories
        }
        if self.book.publishedDate != nil{
            vrPublicacaoData.text = self.book.publishedDate
        }
        //        if self.book.pageCount != nil{
        //            vrNumPaginas.text = String(self.book.pageCount)
        //        }
        if self.book.sinopse != nil{
            vrSinopse.text = self.book.sinopse
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Parse Json")
        parseJSON()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func addBook(_ sender: Any) {
        self.book = Book(context:context)
        
        //PREENCHE OS DADOS DO MODELO
        book.cover = vrBookCover.image
        book.title = vrTitulo.text
        book.author = vrAutores.text
        book.publisher = vrEditora.text
        book.categories = vrCategorias.text
        book.publishedDate = vrPublicacaoData.text
        book.pageCount = NSString(string: vrNumPaginas.text!).intValue
        book.sinopse = vrSinopse.text
        
        do{
            try context.save()
        }
        catch{}
        
        self.dismiss(animated: true, completion: nil)
    }


}
