//
//  ViewController.swift
//  Desafio-iOS
//
//  Created by Leonardo Gouveia on 13/04/17.
//  Copyright © 2017 Leonardo Gouveia. All rights reserved.
//

import UIKit
import Alamofire
import Font_Awesome_Swift
import MBProgressHUD


class TableViewController: UITableViewController {
    
    var searchURL = "https://api.github.com/search/repositories?q=language:Java&sort=stars&page="
    var userURL = "https://api.github.com/users/"
    var loadingNotifications: MBProgressHUD?
    var indexOfPageToRequest = 1
    var numberOfRows = 0
    var numberOfRowsInPage = 30
    var javaRepos = JavaRepositories()
    
    typealias JSONStandard = [String: AnyObject]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(url: searchURL + String(indexOfPageToRequest))
    }
    
    
    func getData(url: String){
        DispatchQueue.main.async(execute: {
            self.loadingNotifications = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.loadingNotifications?.mode = MBProgressHUDMode.indeterminate
            self.loadingNotifications?.label.text = "Loading"
            self.loadingNotifications?.show(animated: true)
        
            Alamofire.request(url).responseJSON(completionHandler: {
                response in
                print("Inserting repos")
                self.javaRepos.insertRepos(response.data!)
                self.tableView.reloadData()
                self.loadingNotifications?.hide(animated: true)
            })

        })
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numberOfRows = javaRepos.repositories.count
        return self.numberOfRows
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
        let repo = javaRepos.repositories[indexPath.row]
        
        mainImageView.image = repo.userAvatar
        mainLabel.text = repo.name
        descriptionLabel.text = repo.description
        userNameLabel.text = repo.userLoginName
        userRealNameLabel.text = repo.userRealName
        forkCountLabel.text = String(repo.quantityOfForks)
        starCountLabel.text = String(repo.quantityOfStargazers)
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! PullsViewController
        let repo = self.javaRepos.repositories[indexPath!]
        
        vc.title = repo.name
        vc.repositoryName = repo.name
        vc.repositoryOwner = repo.userLoginName
        vc.repositoryImage = repo.userAvatar
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

 
        if offsetY > contentHeight - scrollView.frame.size.height && self.numberOfRows >= numberOfRowsInPage {
            numberOfRowsInPage += 30
            indexOfPageToRequest += 1
            
            
            print("puxando novos items")
            
            self.getData(url: self.searchURL + String(self.indexOfPageToRequest))
        
            
        }
        
    }

}

