//
//  ChatpageVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 4/7/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

    import UIKit
    import SwiftyJSON
    var GCurrentPlayer : User!
    class ChatpageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
        var SelectedPlayer : User!
        var CurrentPlayer : User!
        var http = HttpHelper()
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var messageTextField: UITextField!
        
        @IBOutlet weak var inputContainerBottomContraint: NSLayoutConstraint!
        
        var activeUserLabel: UILabel!
        var messages = [MessageModelClass]()
        //var user: User!
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messages.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell: MessageTableViewCell
            if (messages[indexPath.row]._to != CurrentPlayer.user_id) || (messages[indexPath.row]._from == CurrentPlayer.user_id) {
                cell = tableView.dequeueReusableCell(withIdentifier: "outgoingCell") as! MessageTableViewCell
               // cell.usernameLabel.text = CurrentPlayer.from
                messages[indexPath.row]._username = CurrentPlayer.from
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "incomingCell") as! MessageTableViewCell
                //cell.usernameLabel.text = SelectedPlayer.from
                messages[indexPath.row]._username = SelectedPlayer.from
            }
            print(messages[indexPath.row]._from)
            cell.configureCell(message: messages[indexPath.row])
            return cell
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //SocketManger.shared.
            SocketManger.shared.connect()
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
            

            SocketManger.shared.handleNewMessage { (message) in
               print(message)
                if self.SelectedPlayer.user_id == message._from {
                    
                self.messages.append(message)
                self.tableView.reloadData()
                self.scrollToBottomOfChat()
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
            print(messages.count)
            if messages.count == 0 {
                let indexPath = IndexPath(row: messages.count - 1, section: 0)
               // tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }else{
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
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
            print("http://172.107.175.8/api/get-user-message?user_id=\(SelectedPlayer.user_id)")
            
            let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
            let token_type = UserDefaults.standard.string(forKey: "token_type")!
            print("\(token_type) \(AccessToken)")
            let headers = [
                
                "Authorization" : "\(token_type) \(AccessToken)",   "lang":SharedData.SharedInstans.getLanguage() 
            ]
            
            http.Get(url: "\(APIConstants.GetUserMessage)?user_id=\(SelectedPlayer.user_id)", parameters:[:], Tag: 1, headers: headers)
            
                }
        
        func registerUser() {
            let userId = AppCommon.sharedInstance.getJSON("Profiledata")["id"].stringValue
            if let username = AppCommon.sharedInstance.getJSON("Profiledata")["name"].string {
                if CurrentPlayer == nil {
                    CurrentPlayer = User(
                        user_id: userId,
                        from: username
                    )
                 //   SocketManger.shared.userJoinOnConnect(user: user)
                    self.loadChatHistory()
                }
            } else {
             //   let alert = UIAlertController(title: "What is your name?", message: nil, preferredStyle: .alert)
             //   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    if let text = AppCommon.sharedInstance.getJSON("Profiledata")["name"].string  {
                        if text != "" {
                            CurrentPlayer = User(
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
                    let msg = MessageModelClass(
                        username : CurrentPlayer.from ,
                        id: CurrentPlayer.user_id,
                        message: message.trimmingCharacters(in: .whitespaces),
                        from: CurrentPlayer.user_id,
                        to: SelectedPlayer.user_id,
                        seen: "",
                        created_at: "",
                        updated_at: ""
                        )
                    SocketManger.shared.sendMessage(message: msg)
                    messageTextField.text = ""
                    print(msg)
                    messages.append(msg)
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
extension ChatpageVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        print(json)
        if Tag == 1 {
            
            let status =  json["status"]
            let Jdata = json["data"]
            let data = Jdata["data"]
            print(data)
            if status.stringValue == "1" {
                let result =  data.arrayValue
                
            //    DispatchQueue.main.async {
                    
                    self.messages.removeAll()
                    self.tableView.reloadData()
              //  }
                    
                    for json in result {
                        print(json)
                    let message = MessageModelClass(
                        username : "Constant" ,
                    id: json["id"].stringValue,
                    message: json["message"].stringValue,
                    from: json["from"].stringValue,
                    to: json["to"].stringValue,
                    seen: json["seen"].stringValue,
                    created_at: json["created_at"].stringValue,
                    updated_at: json["updated_at"].stringValue
                        )
                //print(message)
                        print(SelectedPlayer.user_id)
                        print(json["from"].stringValue)
                        if (SelectedPlayer.user_id == json["from"].stringValue) || (SelectedPlayer.user_id == json["to"].stringValue){
                self.messages.append(message)
                        }
                        
                }
                
                
                
                var reversedMessage = [MessageModelClass]()
                
                for arrayIndex in stride(from: messages.count - 1, through: 0, by: -1) {
                    reversedMessage.append(messages[arrayIndex])
                }
                
                messages = reversedMessage
                
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


