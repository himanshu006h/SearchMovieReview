//
//  AsyncImageView.swift
//  SearchMovieReview
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

typealias ImageCompletionHandler = (_ imageData: Data) -> Void

import Foundation
import UIKit

class AsyncImageView: UIImageView {
    public var imageCache = NSCache<NSString , UIImage>()
    var imageUrlString : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
    }
    
    func reset() {
        self.image = nil
    }
    
    func removeImageFromCache(key: String) {
        imageCache.removeObject(forKey: key as NSString)
    }
    
    // function to asynchronously load images inside the imageview
    // if the image is present inside the local cache then no need to fetch from the internet
    // if the call could not be completed then insert a default image for broken link
    // If the app extends in functionality, this method can be moved to a separate extension to make it accessible through out the app
    func loadImage(urlString: String, completion: @escaping ImageCompletionHandler){
        
        imageUrlString = urlString
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                self.image = imageFromCache
                self.clipsToBounds = true
            }
            
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    // if the request could not load then show a broken url image
                    self.image = UIImage.init(named: "placeHolder")
                }
                return
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                DispatchQueue.main.async {
                    if let imageToBeStoredInCache = UIImage(data: data) {
                        if self.imageUrlString == urlString {
                            self.image = imageToBeStoredInCache
                            self.clipsToBounds = true
                        }
                        self.imageCache.setObject(imageToBeStoredInCache, forKey: urlString as NSString)
                        if self.imageUrlString == urlString {
                            completion(data)
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.image = #imageLiteral(resourceName: "placeholder")
                    self.clipsToBounds = true
                }
            }
        }).resume()
    }
}



