//
//  BookRegisterViewController.swift
//  Leiturama
//
//  Created by Arthur Santos on 27/04/19.
//  Copyright © 2019 Arthur Santos. All rights reserved.
//

import UIKit
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
    @IBOutlet weak var vrSinopse: UITextField!
    
    var book: Book!
    
    func parseJSON() {
        Alamofire.request("https://www.googleapis.com/books/v1/volumes?q=9788578274085+isbn").responseJSON{
            response in
            
            if let json = response.result.value as? [String:Any]
            {
                if let volumeInfo = json["items"]["volumeInfo"] as? [String:Any] {
                    if let isbn = volumeInfo["identifier"] as String {
                        book.isbn = isbn
                    }
                    if let titulo = volumeInfo["title"] as String {
                        book.title = titulo
                    }
                    if let autores = volumeInfo["authors"] as [String] {
                        book.author = ""
                        for autor in autores {
                            book.author += "\(autores), "
                        }
                        book.author = book.author?.dropLast(2)
                    }
                    if let editora = volumeInfo["publisher"] as String {
                        book.publisher = editora
                    }
                    if let publicacaoData = volumeInfo["publishedDate"] as String {
                        book.publishedDate = publicacaoData
                    }
                    if let sinopse = volumeInfo["description"] as String {
                        book.description = sinopse
                    }
                    if let numPaginas = volumeInfo["pageCount"] as NSString {
                        book.pageCount = numPaginas.intValue
                    }
                    if let categorias = volumeInfo["categories"] as [String] {
                        book.categories = ""
                        for categoria in categorias {
                            book.categories += "\(categoria), "
                        }
                        book.categories = book.categories?.dropLast(2)
                    }
 
                }
            }
        }
    }
    
    view
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        parseJSON()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        vrBookCover.image = UIImage(book.cover)
        vrTitulo.text = book.title
        vrAutores.text = book.author
        vrEditora.text = book.publisher
        vrCategorias.text = book.categories
        vrPublicacaoData.text = book.publishedDate
        vrNumPaginas.text = String(book.pageCount)
        vrSinopse.text = book.description
        super.viewWillAppear(animated)
    }

}
