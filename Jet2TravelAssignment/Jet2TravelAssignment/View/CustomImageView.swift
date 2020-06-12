//
//  CustomImageView.swift
//  Jet2TravelAssignment
//
//  Created by Anand Yadav on 10/06/20.
//  Copyright © 2020 Anand Yadav. All rights reserved.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {

   var imageUrlString :String?

    func loadImageWithString(_ urlString:String){

        imageUrlString = urlString

        let request = URLRequest(url: URL(string:urlString)!)

        self.image = nil

        //imageCache exist,and use it directly
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {

            self.image = imageFromCache
        }

        //imageCache doesn't exist,then download the image and save it
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in

            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                return
            }

            DispatchQueue.main.async() {

                let imageToCache = UIImage(data: data)

                imageCache.setObject(imageToCache!, forKey: urlString as String as AnyObject )

                if self.imageUrlString == urlString{

                    self.image = imageToCache
                }
            }

        }).resume()

    }

}
