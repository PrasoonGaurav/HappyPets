//
//  ProfileView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 15/03/21.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var profileDisplayName : String
    var profileUserId: String
    var isMyProfile: Bool
    var posts = PostArrayObject()
    @State var showSettings: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            ProfileHeaderView(profileDisplayName: $profileDisplayName)
            Divider()
            ImageGridView(posts: posts)
        })
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    showSettings.toggle()
                                }, label: {
                                    Image(systemName: "line.horizontal.3")
                                })
                                .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                                .opacity(isMyProfile ? 1.0 : 0.0)
        )
        .sheet(isPresented: $showSettings, content: {
            SettingsView()
                .preferredColorScheme(colorScheme)
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView{
            ProfileView(profileDisplayName: "Joe", profileUserId: "", isMyProfile: true)
                .preferredColorScheme(.light)

        }
    }
}
