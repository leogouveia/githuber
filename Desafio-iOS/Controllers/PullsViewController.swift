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

class PullsViewController: UIViewController, UITableViewDataSource {
    typealias JSONStandard = [String: AnyObject]
    
    @IBOutlet var tb: UITableView?
    @IBOutlet var backButton: UIBarButtonItem?
    @IBOutlet weak var repoImage2: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    
    var repositoryName: String!
    var repositoryOwner: String!
    var repositoryImage: UIImage!
    
    var urlRepository = "https://api.github.com/repos/"
    var loadingNotifications: MBProgressHUD!
    var repository: RepositoryPulls?
    
    @IBOutlet var repositoryNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingNotifications = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotifications?.mode = MBProgressHUDMode.indeterminate
        loadingNotifications?.label.text = "Loading"
        
        urlRepository += "\(repositoryOwner!)/\(repositoryName!)/pulls"
        print(urlRepository)
        getData(url: urlRepository)
        repository = RepositoryPulls.init(name: repositoryName, autorName: repositoryOwner, autorImage: repositoryImage)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository!.pulls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let titleLabel = cell?.viewWithTag(1) as! UILabel
        let bodyLabel = cell?.viewWithTag(2) as! UILabel
        let prUserLabel = cell?.viewWithTag(3) as! UILabel
        
        let prUserImage = cell?.viewWithTag(10) as! UIImageView
        
        
        prUserImage.layer.cornerRadius = prUserImage.frame.size.width / 2
        
        let pull = repository!.pulls[indexPath.row]
        print("criando celulas com titulo: \(pull.title)")

        titleLabel.text = pull.title
        bodyLabel.text = pull.body
        prUserLabel.text = pull.name
        
        prUserImage.image = pull.image
        
        return cell!
    }
    
    func getData(url: String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.repository!.insertPulls(response.data!)
            self.repoName.text = self.repository!.name
            self.repoImage2.image = self.repository!.image
            self.repoImage2.layer.cornerRadius = self.repoImage2.frame.size.width / 2
            self.tb?.reloadData()
            self.loadingNotifications?.hide(animated: true)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! WebViewController
        
        let row = tb?.indexPathForSelectedRow?.row
        
        let pull = repository?.pulls[row!]
        
        dest.gitURL = pull!.htmlURL
        
    
        
    }
    
    

}

