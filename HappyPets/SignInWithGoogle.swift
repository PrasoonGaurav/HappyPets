//
//  SignInWithGoogle.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 07/04/21.
//

import Foundation
import SwiftUI
import GoogleSignIn
import FirebaseAuth

class SignInWithGoogle: NSObject, GIDSignInDelegate {
    
    static let instance =  SignInWithGoogle()
    var onBoardingView : OnboardingView!
    
    func startSignInwithGoolgeFlow(view: OnboardingView){
        self.onBoardingView = view
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance()?.presentingViewController.modalPresentationStyle = .fullScreen
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print("Error sigining in to Google")
            self.onBoardingView.showError.toggle()
            return
        }
        
        let fullName: String = user.profile.name
        let email: String = user.profile.email
        
        let idToken:String = user.authentication.idToken
        let accessToken:String = user.authentication.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        self.onBoardingView.connectToFirebase(name: fullName, email: email, provider: "google", credential: credential)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        
        print("User disconnected from Google")
        self.onBoardingView.showError.toggle()
    }
}
