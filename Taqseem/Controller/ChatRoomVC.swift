//
//  ChatRoomVC.swift
//  Taqseem
//
//  Created by apple on 2/24/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

    import UIKit
    import SwiftyJSON
    class ChatRoomVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
        var http = HttpHelper()
        var GroupID = ""
        var CurrentPlayer : User!
        var comefromFilter = true
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var messageTextField: UITextField!
        @IBOutlet weak var tblTobConstrain: NSLayoutConstraint!
        @IBOutlet weak var HeaderView: UIView!
        @IBOutlet weak var inputContainerBottomContraint: NSLayoutConstraint!
        
        var activeUserLabel: UILabel!
        var GroupMessages = [GroupMessageModelClass]()
        //var user: User!
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return GroupMessages.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell: MessageTableViewCell
            if (GroupMessages[indexPath.row]._userId == CurrentPlayer.user_id) {
                cell = tableView.dequeueReusableCell(withIdentifier: "outgoingCell") as! MessageTableViewCell
                // cell.usernameLabel.text = CurrentPlayer.from
                GroupMessages[indexPath.row]._from = CurrentPlayer.from
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "incomingCell") as! MessageTableViewCell
                //cell.usernameLabel.text = SelectedPlayer.from
                //GroupMessages[indexPath.row]._from = SelectedPlayer.from
            }
            print(GroupMessages[indexPath.row]._from)
            cell.configureCell(message: GroupMessages[indexPath.row])
            return cell
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //SocketManger.shared.
            SocketManger.shared.connect()
            if comefromFilter == true {
                GroupID = Gitem._group_id
                HeaderView.isHidden = true
            tableView.topAnchor.constraint(equalTo: HeaderView.topAnchor, constant: 0).isActive = true
            }
            GIsAtChatRoom = true
            tableView.delegate = self
            tableView.dataSource = self
            http.delegate = self
            registerUser()
            messageTextField.delegate = self
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardOpen), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardOpen), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            let tapGuesterHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            let tapGuesterShowKeyboard = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
            tableView.addGestureRecognizer(tapGuesterHideKeyboard)
            messageTextField.superview?.addGestureRecognizer(tapGuesterShowKeyboard)
            
            
            // Custom active user label
            activeUserLabel = UILabel()
            activeUserLabel.textColor = UIColor(red: 24/255, green: 186/255, blue: 0/255, alpha: 1.0)
            activeUserLabel.text = "0 user"
            activeUserLabel.sizeToFit()
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: activeUserLabel)]
            navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Re-login", style: .plain, target: self, action: #selector(reLogin))]
            
            SocketManger.shared.onConnect {
                self.registerUser()
            }
            
            
            SocketManger.shared.handleNewGroupMessage { (message) in
                print(message)
                print(message._userId)
                if self.comefromFilter == true {
                    if message._userId == Gitem._group_id{
                if self.CurrentPlayer.user_id != message._userId {
                    self.GroupMessages.append(message)
                    self.tableView.reloadData()
                    self.scrollToBottomOfChat()
                        }}
                    
                }else{
                    if self.CurrentPlayer.user_id != message._userId {
                        self.GroupMessages.append(message)
                        self.tableView.reloadData()
                        self.scrollToBottomOfChat()
                    }
                }
            }
            
            
            
            SocketManger.shared.handleActiveUserChanged { (count) in
                self.activeUserLabel.text = "\(count) user\(count > 1 ? "s" : "")"
                self.activeUserLabel.sizeToFit()
            }
            
            SocketManger.shared.handleUserTyping {
                self.title = "Typing..."
            }
            
            SocketManger.shared.handleUserStopTyping {
                self.title = "Socket Chat"
            }
        }
        
        
        @objc func reLogin() {
            //UserDefaults.standard.removeObject(forKey: "username")
            // SocketManger.shared.disconnect()
            //  SocketManger.shared.connect()
            self.dismiss(animated: false, completion: nil)
        }
        
        func scrollToBottomOfChat(){
            if GroupMessages.count == 0 {
                let indexPath = IndexPath(row: GroupMessages.count - 1, section: 0)
                // tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }else{
                let indexPath = IndexPath(row: GroupMessages.count - 1, section: 0)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
        
        @IBAction func DismissView(_ sender: Any) {
            if GIsNotification == true {
                GIsNotification = false
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let storyboard = UIStoryboard.init(name: "Player", bundle: nil);
                delegate.window?.rootViewController =
                    storyboard.instantiateInitialViewController()
            }else{
                GIsAtChatRoom = false
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
        func loadChatHistory() {
        //http://172.107.175.8/api/get-group-message?group_id=74
            let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
            let token_type = UserDefaults.standard.string(forKey: "token_type")!
            print("\(token_type) \(AccessToken)")
            let headers = [
                
                "Authorization" : "\(token_type) \(AccessToken)",   "lang":SharedData.SharedInstans.getLanguage() 
            ]
            print(GroupID)
            http.Get(url: "\(APIConstants.GetGroupMessage)?group_id=\(GroupID)", parameters:[:], Tag: 1, headers: headers)
            
        }
        
        func registerUser() {
            let userId = AppCommon.sharedInstance.getJSON("Profiledata")["id"].stringValue
            if let username = AppCommon.sharedInstance.getJSON("Profiledata")["name"].string {
                if self.CurrentPlayer == nil {
                    self.CurrentPlayer = User(
                        user_id: userId,
                        from: username
                    )
                    //   SocketManger.shared.userJoinOnConnect(user: user)
                    self.loadChatHistory()
                }
            } else {
                
                if let text = AppCommon.sharedInstance.getJSON("Profiledata")["name"].string  {
                    if text != "" {
                        self.CurrentPlayer = User(
                            user_id: userId,
                            from: text
                        )
                        UserDefaults.standard.set(text, forKey: "username")
                        // SocketManger.shared.userJoinOnConnect(user: self.user)
                        self.loadChatHistory()
                    }
                }
            }
            print("ddd")
        }
        
        
        // Send Message
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            sendMessage()
            return true
        }
        
        @IBAction func sendButtonDidTap(_ sender: UIButton) {
            sendMessage()
        }
        
        func sendMessage() {
            if let message = messageTextField.text {
                if message.trimmingCharacters(in: .whitespaces) != "" {
                    let msg = GroupMessageModelClass(
                        id: "",
                        userId: CurrentPlayer.user_id,
                        from: CurrentPlayer.from,
                        message: message.trimmingCharacters(in: .whitespaces),
                        created_at: ""
                    )
                    SocketManger.shared.sendMessage(message: msg , GroupID: GroupID )
                    messageTextField.text = ""
                    print(msg)
                    GroupMessages.append(msg)
                    tableView.reloadData()
                    scrollToBottomOfChat()
                }
            }
        }
        // End Send Message
        
        
        // Keyboard handler
        @objc func hideKeyboard() {
            messageTextField.resignFirstResponder()
        }
        
        @objc func showKeyboard() {
            messageTextField.becomeFirstResponder()
        }
        
        @objc func handleKeyboardOpen(notification: Notification) {
            if let userInfo = notification.userInfo {
                if messageTextField.isEditing {
                    let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    if notification.name == UIResponder.keyboardWillShowNotification {
                        inputContainerBottomContraint.constant = -keyboardFrame.height
                    } else {
                        inputContainerBottomContraint.constant = 0
                    }
                    
                    UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            messageTextField.resignFirstResponder()
        }
        // End Keyboard handler
        
    }
    extension ChatRoomVC: HttpHelperDelegate {
        func receivedResponse(dictResponse: Any, Tag: Int) {
            print(dictResponse)
            AppCommon.sharedInstance.dismissLoader(self.view)
            let json = JSON(dictResponse)
            print(json)
            if Tag == 1 {
                
                let status =  json["status"]
                 let data = json["data"]
                print(data)
                if status.stringValue == "1" {
                    let result =  data.arrayValue
                    
                    //    DispatchQueue.main.async {
                    
                    self.GroupMessages.removeAll()
                    self.tableView.reloadData()
                    //  }
                    
                    for json in result {
                        print(json)
                        let message = GroupMessageModelClass(
                            id: json["id"].stringValue,
                            userId: json["user_id"].stringValue,
                            from: json["from"].stringValue,
                            message: json["message"].stringValue,
                            created_at: json["created_at"].stringValue
                            
                        )
                        print(message)
                        
    
                    self.GroupMessages.append(message)
//                        }
                        
                    }
                    
                    
                    
//                    var reversedMessage = [MessageModelClass]()
//
//                    for arrayIndex in stride(from: messages.count - 1, through: 0, by: -1) {
//                        reversedMessage.append(messages[arrayIndex])
//                    }
//
//                    messages = reversedMessage
                    
                    // DispatchQueue.main.async {
                    
                    self.tableView.reloadData();                                                     self.scrollToBottomOfChat()
                    // }
                    
                    
                }
            }
        }
        
        func receivedErrorWithStatusCode(statusCode: Int) {
            print(statusCode)
            AppCommon.sharedInstance.alert(title: "Error", message: "\(statusCode)", controller: self, actionTitle: AppCommon.sharedInstance.localization("ok"), actionStyle: .default)
            
            AppCommon.sharedInstance.dismissLoader(self.view)
        }
        func retryResponse(numberOfrequest: Int) {
            
        }
}


