//
//  ArticlesViewModel.swift
//  Jet2TravelAssignment
//
//  Created by Anand Yadav on 09/06/20.
//  Copyright © 2020 Anand Yadav. All rights reserved.
//

import UIKit

protocol ArticlesViewModelEvents: class {
    func fetchData(param:[String:Any]?, completion: @escaping (ArticlesData?, Error?) -> Void)
}

class ArticlesViewModel: ArticlesViewModelEvents {
    
    var delegate : ArticlesViewModelEvents?
    var articles: ArticlesData?
    
    init(articles: ArticlesData? = nil) {
        self.articles = articles
    }
    
    init(delegate: ArticlesViewModelEvents) {
        self.delegate = delegate
    }
    
    func fetchData(param:[String:Any]?, completion: @escaping (ArticlesData?, Error?) -> Void) {
        ServiceManager.getArticles(param: param, success: { (response) in
            
            if let articles = try? ArticlesData.decode(from: (response?.data)!) {
                self.articles = articles
                completion(self.articles, nil)
            } else {
                completion(nil, HTTPError.invalidData)
            }
        }) { (error) in
            completion(nil, error)
        }
    }
    
}

