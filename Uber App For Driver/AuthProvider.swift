//
//  AuthProvider.swift
//  Uber App For Driver
//
//  Created by Emmanuel Erilibe on 1/26/17.
//  Copyright © 2017 Emmanuel Erilibe. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode {    
    static let INVALID_EMAIL = "🤥Invalid Email Address! Please provide a real Email Address"
    static let WRONG_PASSWORD = "😡Wrong password! please enter the correct password"
    static let PROBLEM_CONNECTING = "🤔Problem connecting to database! Please try again later"
    static let USER_NOT_FOUND = "😳User not found, please register"
    static let EMAIL_ALREADY_IN_USE = "😣Email already in use, Please use another email"
    static let WEAK_PASSWORD = "😡Password should be atleast 6 characters long"
}

class AuthProvider {
    
    private static let _instance = AuthProvider()
    
    static var Instance: AuthProvider {
        return _instance
    }
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            } else {
                loginHandler?(nil)
            }
        })
    } //login func
    
    func signUp(withEmail: String, password: String, loginHandler: LoginHandler?) {
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            } else {
                if user?.uid != nil {
                    //Store the user to the database
                    DBProvider.Instance.saveUser(withID: user!.uid, email: withEmail, password: password)
                    //login the user
                    
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)
                }
            }
        })
    } //SignUp finc
    
    func logOut() -> Bool {
        
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                return false
            }
        }
        return true
    } // log out function
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        
        if let errCode = FIRAuthErrorCode(rawValue: err.code) {
            
            switch errCode {
                
            case .errorCodeWrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
                
            case .errorCodeInvalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
                
            case .errorCodeUserNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
                
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
                
            case .errorCodeWeakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                break
            }
        }
    }
} // class
