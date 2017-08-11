//
//  RepositoryViewController.swift
//  Desafio-iOS
//
//  Created by Leonardo Gouveia on 14/04/17.
//  Copyright © 2017 Leonardo Gouveia. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class PullsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    typealias DownloadCompleted = () -> ()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backButton: UIBarButtonItem?
    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var teste: UIView!
    
    var loadingNotifications: MBProgressHUD!
    var repo: Repository!
    var urlRepository = "https://api.github.com/repos/"
    var pulls = [Pull]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.setViewData()
        
        urlRepository += "\(repo.userLoginName)/\(repo.name)/pulls"

        self.getData(url: self.urlRepository) {
            self.tableView.reloadData()
            self.loadingNotifications?.hide(animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pulls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let bodyLabel = cell.viewWithTag(2) as! UILabel
        let prUserLabel = cell.viewWithTag(3) as! UILabel
        let prUserImage = cell.viewWithTag(10) as! UIImageView
        
        
        prUserImage.layer.cornerRadius = prUserImage.frame.size.width / 2
        
        let pull = self.pulls[indexPath.row]

        titleLabel.text = pull.title
        bodyLabel.text = pull.body
        prUserLabel.text = pull.name
        
        prUserImage.image = pull.image
        
        
        print("Nome: \(pull.name)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicado")
        let url = URL(string: pulls[indexPath.row].htmlURL)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let indexPath = self.tb.indexPathForSelectedRow?.row
//        let vc = segue.destination as! WebViewController
//        let pull = self.pulls[indexPath!]
//        vc.gitURL = pull.htmlURL
//    }
    
    func getData(url: String, completed: @escaping DownloadCompleted){
        print("url: \(url)")
        
        Alamofire.request(url).responseJSON { response in
            let result = response.result
            
            if let array = result.value as? Array<AnyObject> {
                self.pulls = Pull.getPulls(pullArray: array)
            }
            completed()
        }
        
    }
    
    func setViewData() {
        self.repoImage.image = self.repo.userAvatar
        self.repoNameLabel.text = self.repo.name
        self.startLoading()
    }
    
    func startLoading() {
        loadingNotifications = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotifications?.mode = MBProgressHUDMode.indeterminate
        loadingNotifications?.label.text = "Carregando"
    }

}

