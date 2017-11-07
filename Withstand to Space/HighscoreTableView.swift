//
//  HighscoreTableView.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 26.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

/*
import SpriteKit
import UIKit

class HighscoreTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var items: [String] = ["Player1", "Player2", "Player3"]
    
//    override init(frame: CGRect, style: UITableViewStyle) {
//        super.init(frame: frame, style: style)
//        self.delegate = self
//        self.dataSource = self
//    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Table view data source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return userDictionary.count
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        //cell.backgroundColor = UIColor.blue
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
}
*/
