//
//  ViewController.swift
//  WebsiteParser
//
//  Created by Andrey Kolpakov on 10.08.2018.
//  Copyright © 2018 Andrey Kolpakov. All rights reserved.
//

import UIKit
import SwiftSoup


class ViewController: UIViewController, ErrorMessage {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func insagramButton(_ sender: UIButton) {
        let instagramApp = InstagramManager.share
        if  instagramApp.postImageToInstagramWithCaption(imageInstagram: image!, view: self.view) == false {
            present(instagramApp.errorMessageAC("Установите приложение Instagram на ваше устройство"), animated: true)
        }
    }
    
    //fileprivate var siteURL = "https://pikabu.ru/"
         fileprivate var siteURL = "https://pikabu.ru/tag/%D0%BC%D0%B5%D0%BC%D1%8B/hot"
    //    fileprivate var siteURL = "http://snotes.kv.in.ua/"
//    fileprivate var siteURL = "https://vz.ru/"
    
    fileprivate var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parser(http: siteURL)
        
    }
    
    func parser(http: String) {
        
        guard let url = URL(string: http) else {
            print("Ошибка адреcа http")
            return
        }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .utility).async {
            do {
                let html = try String(contentsOf: url, encoding: .ascii)
                self.downloadImageByHTML(link: html)
            } catch let error {
                print("Error: \(error)")
            }

        }

    }
    
    func downloadImageByHTML(link: String) {
        DispatchQueue.global(qos: .utility).async {
            do {
                let doc: Document = try SwiftSoup.parse(link)
                guard let element: Element = try doc.select("img[src$=.jpg]").first() else {
                    self.present(self.errorMessageAC("Ошибка парсинга данных. Возможно надо поменять расширение файла"), animated: true)
                    return
                }
                
                self.fetchImage(imageLink: try element.attr("src"))
                
            } catch Exception.Error(let type, let message) {
                print("error: \(message), type: \(type)")
            } catch {
                print("error")
            }
        }
    }
    
    func fetchImage(imageLink: String) {
        let imageURL = URL(string: imageLink)
        
        guard let url = imageURL else {
            present(errorMessageAC("Битая ссылка"), animated: true)
            return
        }
        DispatchQueue.global(qos: .utility).async {
            guard let imageData = try? Data(contentsOf: url) else {
                self.present(self.errorMessageAC("Ошибка данных"), animated: true)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }

        }
    }
    
    
    
}

