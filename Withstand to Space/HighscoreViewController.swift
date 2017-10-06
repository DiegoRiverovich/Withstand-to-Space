//
//  HighscoreViewController.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 26.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import Firebase

var userId = ""

class HighscoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var highScoreTableView: UITableView!
    
    //var userDictionary: [ String : Int ] = [:]
    
    var nicknameArray: [String] = []
    var highscoreArray: [Int] = []
    
    var dictArray: [Dictionary<String, Any>] = []
    var reloadTable = false
    
    var meInHighScore: [Int] = []
    
    var ref: DatabaseReference?
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBAction func dissmissVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("user")
        auth()
        
        fetchData()
        
        setupActivityIndicator()
        
        //var reloadRowTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(HighscoreViewController.reloadRowInTable), userInfo: nil, repeats: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    // Auth
    func auth() {
        Auth.auth().signIn(withEmail: "withstandtospace@test.com", password: "123ASDasd") { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                //self.ref?.child("Score").child(self.userName).setValue(self.highScoreNumber)
                let defaults = UserDefaults()
                let defaultsIsExist = self.isKeyPresentInUserDefaults(key: "userId")
                if !defaultsIsExist {
                    // Set user id
                    let childRef = self.ref?.childByAutoId()
                    
                    // read user id
                    let userKey = childRef?.key
                    
                    if userKey != nil {
                        userId = userKey!
                    }
                    
                    // set user id and high score to defautls
                    defaults.set(userKey, forKey: "userId")
                    defaults.set(highScoreNumber, forKey: "highScoreSaved")
                    
                    // set user id and high score to FIREBASE
                    childRef?.child("highscore").setValue(highScoreNumber)
                    childRef?.child("nickname").setValue(nickName)
                    //self.ref?.child("nickname").setValue(nickName)
                }
            }
            
            self.observeUsers()
            
        }
    }
    
    
    func observeUsers() {
        let userRef = Database.database().reference().child("user")      //.queryOrdered(byChild: "highscore")
        var index = 0
        userRef.observe(.childAdded , with: { (snapshot) in

                if let dictionary = snapshot.value as? [String : Any] {
                    
                    if let _ = dictionary["highscore"] as? Int, let _ = dictionary["nickname"] as? String {

                        self.dictArray.append(dictionary)

                        self.activityIndicator.stopAnimating()
                        index += 1

                    }
                }
            
        })
        
        reloadTableViewFunc(userRef: userRef)

    }
    
    // MARK: WERRY IMPORTANT "observeSingleEvent" FIRES AFTER "observe(.childAdded" ended. We can reload data in table
    func reloadTableViewFunc(userRef: DatabaseReference) {
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.dictArray.sort {
                item1, item2 in
                let data1 = item1["highscore"] as! Int
                let data2 = item2["highscore"] as! Int
                return data1 > data2
            }
            //print(self.dictArray)
            
            for dict in self.dictArray  {
                self.nicknameArray.append(dict["nickname"] as! String)
                self.highscoreArray.append(dict["highscore"] as! Int)
            }
            
            self.highScoreTableView.reloadData()
        })
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    //var items: [String] = ["Player1", "Player2", "Player3"]
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return 1
        } else {
            return nicknameArray.count
        }
    }
    
    var nickScoreForColor = ""
    var scoreScoreForColor = ""
    var myPlaceScoreForColor = "" {
        didSet {
            _ = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(HighscoreViewController.reloadRowInTable), userInfo: nil, repeats: false)
        }
    }
    var myIndexPath = IndexPath()
    var countPlace = 1
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "HighscoreCell", for: indexPath) as? HighscoreTableViewCell
        
        //var mainCell = UITableViewCell()

        
        let cell = dequeued
        if indexPath.section == 0 {
            
            let defaults = UserDefaults()
            let highscore = defaults.integer(forKey: "highScoreSaved")
            
            //cell.textLabel?.text = String(highscore)
            //cell.detailTextLabel?.text = nickName
            
            cell?.nicknameLabel?.text = nickName
            cell?.scoreLabel?.text = String(highscore)
            cell?.placeLabel?.text = myPlaceScoreForColor
            
            nickScoreForColor = nickName
            scoreScoreForColor = String(highscore)
            
            myIndexPath = indexPath
            
            
            
        } else {
            
            //print(nicknameArray)
            
            //cell?.textLabel?.text = nicknameArray[indexPath.row] //key //String(describing: array) //self.items[indexPath.row]
            //cell?.detailTextLabel?.text = String(highscoreArray[indexPath.row])
            
            if nicknameArray[indexPath.row] == nickScoreForColor && String(highscoreArray[indexPath.row]) == scoreScoreForColor {
                
                cell?.nicknameLabel?.text = nicknameArray[indexPath.row]
                cell?.scoreLabel?.text = String(highscoreArray[indexPath.row])
                cell?.placeLabel?.text = "\(indexPath.row + 1)"
                
                if countPlace != 0 {
                    cell?.backgroundColor = UIColor.red
                    myPlaceScoreForColor = "\(indexPath.row + 1)"
                    //print(myPlaceScoreForColor)
                    //highScoreTableView.moveRow(at: indexPath, to: myIndexPath)
                    countPlace -= 1
                }
            } else {
                cell?.nicknameLabel?.text = nicknameArray[indexPath.row]
                cell?.scoreLabel?.text = String(highscoreArray[indexPath.row])
                cell?.placeLabel?.text = "\(indexPath.row + 1)"
            }
            //highScoreTableView.reloadSections([0], with: .none)
            highScoreTableView.reloadRows(at: [myIndexPath], with: .none)
            
        }
        
        
        
        return cell!
    }
    
    @objc func reloadRowInTable() {
        highScoreTableView.reloadRows(at: [myIndexPath], with: .none)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Your score"
        } else {
            return "Highscore"
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        let selectedIndexPath = self.highScoreTableView.indexPathForSelectedRow
        
        //If the selected row is not in the first section the method returns without doing anything.
        guard selectedIndexPath?.section == 0 else {
            return
        }
        
        if selectedIndexPath?.row == 0 {
            //The first row is selected and here the user can change the string in an alert sheet.
            let firstRowEditAction = UIAlertController(title: "Edit Title", message: "Please edit the title", preferredStyle: .alert)
            firstRowEditAction.addTextField(configurationHandler: { (newTitle) -> Void in
                
                newTitle.text = nickName //theOldTitle //Here you put the old string in the alert text field
            })
            
            //The cancel action will do nothing.
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            
            //The Okay action will change the title that is typed in.
            let okayAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                
                nickName/*yourObject.thatNeedsTheNewString*/ = (firstRowEditAction.textFields?.first?.text)!
                //Do some other stuff that you want to do
                
                let defaults = UserDefaults()
                //let userId = defaults.string(forKey: "userId")
                //self.ref?.child("user").child(userId!).child("highscore"/*self.userName*/).setValue(highScoreNumber)
                defaults.set(nickName, forKey: "nickname")
                self.ref?.child(userId).child("nickname"/*self.userName*/).setValue(nickName)
                
                self.highScoreTableView.reloadData() //Don’t forget to reload the table view to update the table content
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            
            firstRowEditAction.addAction(okayAction)
            firstRowEditAction.addAction(cancelAction)
            self.present(firstRowEditAction, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return true
            }
        }
        return false
    }
    
    //var userDictionaryCopy = Array(userDictionary.keys)
    
    
    func fetchData() {
        //userDictionaryCopy = userDictionaryCopy.sorted(by: {$0 < $1})
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
