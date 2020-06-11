//
//  Constant.swift
//  BYF
//
//  Created by jay on 02/06/2019.
//  Copyright © 2019 Kinitous. All rights reserved.
//

import Foundation



internal struct QueryManager {
    
   
    static let userActivityLogs = "SELECT intRowID, strUserID, strShipID,strAction, strdata ,createdDate,strdeptName,straliasName  from \(DataBase.TableName.expenseDetails)"
}


internal struct UserDefaultKeys {
    static let tableCreated = "tableCreated"
    static let username = "username"
   
}


internal struct UserMessage {
    static let registerationSuccess = "Registration Successful"
    static let emptyuserName = "please enter your username"
    static let emptyPassword = "please enter your password"
     static let loginSuccess = "Login Successfull!!!"
    static let invalidUName = "Username invalid"
       static let invalidPassword = "Password invalid"
       static let invalidUNamePassword = "Username or password seems to be invalid"
}

internal struct MindFulnessMessage {
    static let helloMsg = "Hello!"
    

}
internal struct APIConstants {
    static let success = "success"
    static let data = "data"
    static let authKey = "Authorization"
}

internal struct ExpenseDetailsKeys {
    static let sno = "sno"
    static let title = "title"
    static let amount = "amount"
    static let category = "category"
    static let username = "username"
    static let notes = "notes"
    static let dateCreated = "dateCreated"

}

internal struct DataBase {
    static let dbName = "Byf.sqlite"
    
    struct TableName {
        static let expenseDetails = "tExpenses"
    }
}


struct DateFormatString {
    static let createdDateFormat = "yyyy-MM-dd HH:mm:ss"
    static let dateOnlyFormat = "yyyy-MM-dd"
}


