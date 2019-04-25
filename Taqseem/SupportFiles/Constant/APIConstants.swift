//
//  APIConstants.swift
//  CarWash
//
//  Created by Mohammad Farhan on 22/12/1710/11/17.
//  Copyright © 2017 CarWash. All rights reserved.
//

import Foundation

open class APIConstants {
   static let SERVER_URL = "http://172.107.175.8/api/"
      static let Base_Image_URL = "http://172.107.175.8/taqsema/public/"
//   static let SERVER_URL = "http://192.168.1.111:8080/cartime-1.1/cartime/api/"
    
//socketURL
    static let socketURL = "http://172.107.175.8:5000"
    //chat API
    static let SendMessage = SERVER_URL + "send-message"
    static let SendGroupMessage = SERVER_URL + "send-group-message"
    static let GetUserMessage = SERVER_URL + "get-user-message"
    static let GetGroupMessage = SERVER_URL + "get-group-message"
    static let GetMsgHistory = SERVER_URL + "get-chat-history"
    
    static let Login = SERVER_URL + "login"
    static let logout = SERVER_URL + "logout"
    static let Register = SERVER_URL + "register"
    static let ResentCode = SERVER_URL + "resend-code"
    static let SendCode = SERVER_URL + "send-code"
    static let ResetPassword = SERVER_URL + "reset-password"
    static let facebookregister = SERVER_URL + "facebook-register"
    static let facebookLogin = SERVER_URL + "facebook-login"
    static let AddMember = SERVER_URL + "add-team_member"
    static let GetMember = SERVER_URL + "get-member"
    static let DeleteMember = SERVER_URL + "delete-team_member"
    static let GetPlayer = SERVER_URL + "players"
    static let PlayersMatch = SERVER_URL + "players-match"
    static let Filter = SERVER_URL + "filter"
    static let NearMe = SERVER_URL + "near-me"
    static let AddMatch = SERVER_URL + "add-match"
    static let MyMatchs = SERVER_URL + "my-matches"
    static let Favorits = SERVER_URL + "favorite"
    static let AddToFav = SERVER_URL + "add-favorite"
    
    // Next Match
    static let NextMatch = SERVER_URL + "next-match"
    static let GetPlayerBefor = SERVER_URL + "team-match"
    //owner
    static let GetGround = SERVER_URL + "owner/ground"
    static let Owner = SERVER_URL + "owner/"
    static let GetRequest = SERVER_URL + "owner/get-requests"
    static let ChangeStatus = SERVER_URL + "owner/change-status"
   
     static let GetCity = SERVER_URL + "country"
    static let GetArea = SERVER_URL + "city"
    
    
    
    
}
