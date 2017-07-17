//
//  ViewController.swift
//  Desafio-iOS
//
//  Created by Leonardo Gouveia on 13/04/17.
//  Copyright © 2017 Leonardo Gouveia. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import MBProgressHUD


class ReposViewController: UITableViewController {
    
    var searchURL = "https://api.github.com/search/repositories?q=language:Java&sort=stars&page=1"
    var userURL = "https://api.github.com/users/"
    var loadingNotifications: MBProgressHUD?
    var indexOfPageToRequest = 1
    var numberOfRows = 0
    var numberOfRowsInPage = 30
    var repos = [Repository]()
    var loadedPages = 0
    
    private let indicatorFooter = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorFooter.frame.size.height = 100
        indicatorFooter.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicatorFooter.startAnimating()
        
        getData()
    }
    
    
    func getData(){
        self.loadingNotifications = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.loadingNotifications?.mode = MBProgressHUDMode.indeterminate
        self.loadingNotifications?.label.text = "Carregando"
        self.loadingNotifications?.show(animated: true)
        
        self.loadedPages += 1
        
        Repository.downloadRepositories(page: self.loadedPages) { repos in
            self.repos += repos
            self.loadingNotifications?.hide(animated: true)
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let mainImageView = cell?.viewWithTag(2) as! UIImageView
        let mainLabel = cell?.viewWithTag(1) as! UILabel
        let descriptionLabel = cell?.viewWithTag(3) as! UILabel
        let userNameLabel = cell?.viewWithTag(4) as! UILabel
        let forkCountLabel = cell?.viewWithTag(5) as! UILabel
        let starCountLabel = cell?.viewWithTag(6) as! UILabel
        let userRealNameLabel = cell?.viewWithTag(7) as! UILabel
        
        let forkImage = cell?.viewWithTag(10) as! UIImageView
        let starImage = cell?.viewWithTag(11) as! UIImageView
        
        forkImage.setFAIconWithName(icon: .FACodeFork,textColor: #colorLiteral(red: 0.8256844878, green: 0.5479464531, blue: 0.06172423065, alpha: 1), backgroundColor: .clear)
        starImage.setFAIconWithName(icon: .FAStar, textColor: #colorLiteral(red: 0.8256844878, green: 0.5479464531, blue: 0.06172423065, alpha: 1), backgroundColor: .clear)

        mainImageView.layer.cornerRadius = mainImageView.frame.size.width / 2
        
        let repo = self.repos[indexPath.row]
                
        mainImageView.image = repo.userAvatar
        mainLabel.text = repo.name
        descriptionLabel.text = repo.description
        userNameLabel.text = repo.userLoginName
        userRealNameLabel.text = repo.userRealName
        forkCountLabel.text = String(repo.quantityOfForks)
        starCountLabel.text = String(repo.quantityOfStargazers)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == repos.count {
            tableView.tableFooterView = indicatorFooter
            self.getData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! PullsViewController
        let repo = self.repos[indexPath!]
        vc.repo = repo
    }
    
    
    

}

