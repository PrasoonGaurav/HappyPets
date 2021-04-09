//
//  HappyPetsApp.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 04/02/21.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct HappyPetsApp: App {
    
    init() {
        FirebaseApp.configure()
        
        //For Google Sign In
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance().handle(url) //For Google Sign In
                })
        }
    }
}
