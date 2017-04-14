//
//  JavaRepositories.swift
//  Desafio-iOS
//
//  Created by Leonardo Gouveia on 14/04/17.
//  Copyright © 2017 Leonardo Gouveia. All rights reserved.
//

import UIKit

class JavaRepositories {
    var repositories: [Repository]
    typealias JSONStandard = [String: AnyObject]
    
    init() {
        self.repositories = [Repository]()
    }
    
    func insertRepos(_ jsonData: Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! JSONStandard
            if let items = readableJSON["items"] as? [JSONStandard] {
                for i in 0..<items.count {
                    let item = items[i]
                    print("repo no \(i)")
                    
                    if let owner = item["owner"] as? JSONStandard {
                        
                        let avatarUrl = URL(string: owner["avatar_url"] as! String)
                        let avatarImageData = try Data(contentsOf: avatarUrl!)
                        let avatarImage = UIImage(data: avatarImageData)

                        
                        let repository = Repository.init(
                            name: item["name"] as! String,
                            userAvatar: avatarImage!,
                            userLoginName: owner["login"] as! String,
                            userRealName: "",
                            description: item["description"] as? String ?? "",
                            quantityOfForks: item["forks"] as! Int,
                            quantityOfStargazers: item["stargazers_count"] as! Int,
                            htmlUrl: item["html_url"] as! String
                        )
                        self.repositories.append(repository)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
