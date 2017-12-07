//
//  HighscoreViewController.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 26.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import Firebase
import SpriteKit

var userId = ""

class HighscoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var highScoreTableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    //var userDictionary: [ String : Int ] = [:]
    
    var placeTimer: Timer?
    var myPlaceCell: HighscoreTableViewCell?
    var mainPlaceCell: HighscoreTableViewCell?
    
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
        
        //fetchData()
        
        setupActivityIndicator()
        
        //var reloadRowTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(HighscoreViewController.reloadRowInTable), userInfo: nil, repeats: false)
        
        // SetUp cell font
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundStars02" /*"menuBackground2"*/)!)
        highScoreTableView.backgroundColor = UIColor.clear
        //highScoreTableView.alwaysBounceVertical = false
        
        // SetUp BackButton Font
        
        backButton.titleLabel?.font = UIFont(name: SomeNames.fontNameVenusrising, size: 20)
        backButton.titleLabel?.textColor = UIColor.white
        if preferredLanguage == .ru {
            backButton.setTitle("на3ад", for: .normal)   //.titleLabel?.text = "В МЕНЮ"
        } else if preferredLanguage == .ch {
            backButton.setTitle("后退", for: .normal)
        } else if preferredLanguage == .es {
            backButton.setTitle("Atrás", for: .normal)
        } else {
            backButton.setTitle("back", for: .normal)
        }
        
        
        highScoreTableView.estimatedRowHeight = 50
        //highScoreTableView.rowHeight = UITableViewAutomaticDimension
        
        placeTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(HighscoreViewController.setPlace), userInfo: nil, repeats: false)
    }
    
    @objc func setPlace() {
        //if let myplace = place {
        var index = 0
        //nicknameArray.removeAll()
        if !nicknameArray.isEmpty {
            for i in 1...nicknameArray.count {
                if nicknameArray[i-1] == nickName && highscoreArray[i-1] == highScoreNumber {
                    if index == 0 {
                        mainPlaceCell?.placeLabel.text = "\(i)" //String(describing: myplace)
                        //print("sdfasdfasdfsfasdfsdfas")
                        index += 1
                    }
                }
            }
        } else if nicknameArray.isEmpty {
            let alertView = UIAlertController(title: "Error.", message: "Try later.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok.", style: .default, handler: { (alert) in
                
            })
            alertView.addAction(action)
            //self.presentedViewController(alert, animated: true, completion: nil)
            self.present(alertView, animated: true, completion: nil)
            //exit(0)
        }
        //myPlaceCell?.placeLabel.text = nicknameArray[myplace] //String(describing: myplace)
        //}
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
        Auth.auth().signIn(withEmail: "withstandtospace@test.com", password: "123ASDasd") { [weak self] (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                //self.ref?.child("Score").child(self.userName).setValue(self.highScoreNumber)
                let defaults = UserDefaults()
                let defaultsIsExist = self?.isKeyPresentInUserDefaults(key: "userId")
                if !defaultsIsExist! {
                    // Set user id
                    let childRef = self?.ref?.childByAutoId()
                    
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
            
            self?.observeUsers()
            
        }
    }
    
    
    func observeUsers() {
        let userRef = Database.database().reference().child("user")      //.queryOrdered(byChild: "highscore")
        var index = 0
        userRef.observe(.childAdded , with: { [weak self] (snapshot) in

                if let dictionary = snapshot.value as? [String : Any] {
                    
                    if let _ = dictionary["highscore"] as? Int, let _ = dictionary["nickname"] as? String {

                        self?.dictArray.append(dictionary)

                        self?.activityIndicator.stopAnimating()
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
            
            //self.countPlaceFunc()
        })
    }
    
    /*
    func countPlaceFunc() {
        
        for i in 1...nicknameArray.count {
            if nicknameArray[i-1] == nickName && String(highscoreArray[i-1]) == scoreScoreForColor {
                cell?.placeLabel.text = "\(nicknameArray[i].count )"
            }
        }
        
    }
    */
    
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    
    var nickScoreForColor = ""
    var scoreScoreForColor = ""
    var myPlaceScoreForColor = "" {
        didSet {
            _ = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(HighscoreViewController.reloadRowInTable), userInfo: nil, repeats: false)
        }
    }
    var myIndexPath = IndexPath()
    var countPlace = 1
    var oneIndexPath: IndexPath?
    var place: Int?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "HighscoreCell", for: indexPath) as? HighscoreTableViewCell
        
        //var mainCell = UITableViewCell()
        
        
//        if (tableView.indexPathsForVisibleRows!.contains(myIndexPath)) {
//            countPlace = 1
//        }
        

        
        let cell = dequeued
        if indexPath.section == 0 {
            
            let defaults = UserDefaults()
            let highscore = defaults.integer(forKey: "highScoreSaved")
            
            //cell.textLabel?.text = String(highscore)
            //cell.detailTextLabel?.text = nickName
            
            cell?.nicknameLabel?.text = "\(nickName) ✏️"
            cell?.scoreLabel?.text = String(highscore)
            cell?.placeLabel?.text = myPlaceScoreForColor
            cell?.nicknameLabel.textColor = UIColor.white
            
            nickScoreForColor = nickName
            scoreScoreForColor = String(highscore)
            
            myIndexPath = indexPath
            
            mainPlaceCell = cell
           
            
        } else {
            
            //print(nicknameArray)
            
            //cell?.textLabel?.text = nicknameArray[indexPath.row] //key //String(describing: array) //self.items[indexPath.row]
            //cell?.detailTextLabel?.text = String(highscoreArray[indexPath.row])
            //print("\(nickScoreForColor)")
            //print("\(scoreScoreForColor)")
            if nicknameArray[indexPath.row] == nickScoreForColor && String(highscoreArray[indexPath.row]) == scoreScoreForColor {
                
                cell?.nicknameLabel?.text = nicknameArray[indexPath.row]
                cell?.scoreLabel?.text = String(highscoreArray[indexPath.row])
                cell?.placeLabel?.text = "\(indexPath.row + 1)"
                cell?.nicknameLabel.textColor = UIColor.white
                //print("yo1")
                //countPlace = 1
                if countPlace != 0 {
                    if oneIndexPath == nil {
                    //cell?.backgroundColor = UIColor.red
                    cell?.nicknameLabel.textColor = UIColor.red
                    myPlaceScoreForColor = "\(indexPath.row + 1)"
                    //print(myPlaceScoreForColor)
                    //highScoreTableView.moveRow(at: indexPath, to: myIndexPath)
                    countPlace -= 1
                    //print("yo2")
                    if oneIndexPath == nil {
                        oneIndexPath = indexPath
                        place = indexPath.row + 1
                        myPlaceCell = cell
                    }
                    
                    //highScoreTableView.reloadRows(at: [myIndexPath], with: .none)
                    //highScoreTableView.reloadSections([0], with: .none)
                    }
                }
            } else {
                cell?.nicknameLabel?.text = nicknameArray[indexPath.row]
                cell?.scoreLabel?.text = String(highscoreArray[indexPath.row])
                cell?.placeLabel?.text = "\(indexPath.row + 1)"
                cell?.nicknameLabel.textColor = UIColor.white
                //print("yo3")
            }
            //highScoreTableView.reloadSections([0], with: .none)
            //highScoreTableView.reloadRows(at: [myIndexPath], with: .none)
            
        }
        
        if let indices = tableView.indexPathsForVisibleRows {
            var exist: Bool = false
            for index in indices {
                if index == oneIndexPath {
                    //countPlace = 0
                    exist = true
                }
            }
            
            if !exist {
                countPlace = 1
                oneIndexPath = nil
                
            }
        }
        
        //cell?.layer.backgroundColor = UIColor.clear.cgColor
        //cell!.backgroundColor = UIColor(white: 1, alpha: 0)
        return cell!
    }
    
    @objc func reloadRowInTable() {
        highScoreTableView.reloadRows(at: [myIndexPath], with: .none)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            if preferredLanguage == .ru {
                return "Мои очки"
            } else if preferredLanguage == .ch {
                return "你的积分 / 得分"
            } else if preferredLanguage == .es {
                return "Tu puntuación"
            } else {
                return "Your score"
            }
            
        } else {
            if preferredLanguage == .ru {
                return "Лучший счет"
            } else if preferredLanguage == .ch {
                return "开始"
            } else if preferredLanguage == .es {
                return "Puntuación máxima"
            } else {
                return "Highscore"
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected cell #\(indexPath.row)!")
        
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: SomeNames.fontNameVenusrising, size: 20)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row) == (tableView.numberOfRows(inSection: 1) - 1) {
            countPlace = 1
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        <#code#>
    }
     */
 
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//    }
    
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
    
    deinit {
        print("high score scene deinit")
    }

}
