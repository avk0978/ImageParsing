//
//  ViewController.swift
//  WebsiteParser
//
//  Created by Andrey Kolpakov on 10.08.2018.
//  Copyright © 2018 Andrey Kolpakov. All rights reserved.
//

import UIKit
import SwiftSoup


class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func insagramButton(_ sender: UIButton) {
        let post = InstagramManager.share
        if  post.postImageToInstagramWithCaption(imageInstagram: image!, view: self.view) == false {
            present(post.errorMessageAC("Установите приложение Instagram на ваше устройство"), animated: true)
        }
    }
    
    
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
        
        parser(http: "http://snotes.kv.in.ua")
        
    }
    
    func parser(http: String) {
        
        guard let url = URL(string: http) else { return }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
                let html = String(data: data!, encoding: String.Encoding.utf8)
                do {
                    let doc: Document = try SwiftSoup.parse(html!)
                    let png: Element = try doc.select("img[src$=.png]").first()!
                    let imageLink = try png.attr("src")
                    
                    self.downloadImage(imageLink: imageLink)
                    
                } catch Exception.Error(let type, let message) {
                    print("error: \(message), type: \(type)")
                } catch {
                    print("error")
                }
            
            
        }.resume()
    }
    
    func downloadImage(imageLink: String)  {
        let strURL = "http://snotes.kv.in.ua/" + imageLink
        let imageURL = URL(string: strURL)
       
        guard let url = imageURL, let imageData = try? Data(contentsOf: url) else { return }
        DispatchQueue.main.async {
            self.image = UIImage(data: imageData)
        }

    }



}

