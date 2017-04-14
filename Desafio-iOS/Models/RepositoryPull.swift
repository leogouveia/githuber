//
//  RepositoryPull.swift
//  Desafio-iOS
//
//  Created by Leonardo Gouveia on 14/04/17.
//  Copyright © 2017 Leonardo Gouveia. All rights reserved.
//

import UIKit

class RepositoryPulls {
    var name: String
    var image: UIImage
    var autorName: String
    var pulls = [Pull]()
    
    typealias JSONStandard = [String: Any]
    
    init(name: String, autorName: String, autorImage: UIImage) {
        self.name = name
        self.autorName = autorName
        self.image = autorImage
        self.pulls = [Pull]()
    }
    
    func insertPulls(_ jsonData: Data) {
        do {
            var items = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [Any]
            for i in 0..<items.count {
                    
                if let item = items[i] as? JSONStandard {
                   
                    if let user = item["user"] as? JSONStandard {
                        let userImageURL = URL(string: user["avatar_url"] as! String)
                        let userImageData = try Data(contentsOf: userImageURL!)
                        
                        let pull = Pull(
                            name: user["login"] as! String,
                            image: UIImage(data: userImageData)!,
                            title: item["title"] as! String,
                            date: Date(),
                            body: item["body"] as! String,
                            URL: item["url"] as! String,
                            id: String(item["id"] as! Int),
                            htmlURL: item["html_url"] as! String
                        )
                        self.pulls.append(pull)
                    }
                }
            }
        } catch {
            print(error)
        }

    }
}
