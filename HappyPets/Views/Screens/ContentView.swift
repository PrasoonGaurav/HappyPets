//
//  ContentView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 04/02/21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage(CurrentUserDefault.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefault.displayName) var currentUserDisplayName: String?
    
    var body: some View {

        TabView{

            NavigationView{
                FeedView(posts: PostArrayObject(), title: "Feed")
            }
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Feed")
                }
            
            NavigationView{
                BrowseView()
            }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Browse")
                }
            UploadView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Upload")
                }
            
            ZStack{
                
                if let userID = currentUserID, let displayName = currentUserDisplayName {
                    NavigationView{
                        ProfileView(profileDisplayName: displayName, profileUserId: userID, isMyProfile: true, posts: PostArrayObject(userID: userID))
                    }
                }
                else{
                    SignUpView()
                }
                
            }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }.accentColor(colorScheme == .light ? Color.MyTheme.purpleColor: Color.MyTheme.yellowColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}

