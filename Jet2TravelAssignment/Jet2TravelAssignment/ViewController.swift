//
//  ViewController.swift
//  Jet2TravelAssignment
//
//  Created by Anand Yadav on 09/06/20.
//  Copyright © 2020 Anand Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel: ArticlesViewModel?
    @IBOutlet weak var tableView: UITableView!
    
    // required when called from storyboard
    required init?(coder aDecoder: NSCoder) {
        viewModel = ArticlesViewModel()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel?.fetchData(param: ["page":"1", "limit":"10"], completion: { (articles, error) in
            if articles != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ArticleCell
        cell.avatarImageView.downloadImageFrom(link: (viewModel?.articles?[indexPath.row].user?.first?.avatar!)!, contentMode: .scaleAspectFit)
        cell.lblUserName.text = viewModel?.articles?[indexPath.row].user?.first?.name
        cell.lblDesignation.text = viewModel?.articles?[indexPath.row].user?.first?.designation
        if let imageUrlString = (self.viewModel?.articles?[indexPath.row].media?.first?.image) {
           cell.articleImage.loadImageWithString(imageUrlString)
        }
        cell.lblArticleContent.text = viewModel?.articles?[indexPath.row].content
        cell.articleTitle.text = viewModel?.articles?[indexPath.row].media?.first?.title
        cell.articleURL.text = viewModel?.articles?[indexPath.row].media?.first?.url
        cell.lblLikes.text = "\(Double((viewModel?.articles?[indexPath.row].likes)!)/1000.00)" + "K Likes"
        cell.lblComments.text = "\(Double((viewModel?.articles?[indexPath.row].comments)!)/1000.00)" + "K Comments"
        return cell
    }


}

