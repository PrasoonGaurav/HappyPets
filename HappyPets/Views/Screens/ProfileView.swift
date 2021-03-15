//
//  ProfileView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 15/03/21.
//

import SwiftUI

struct ProfileView: View {
    
    @State var profileDisplayName : String
    var profileUserId: String
    var isMyProfile: Bool
    
    var posts = PostArrayObject()
    
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
                                    
                                }, label: {
                                    Image(systemName: "line.horizontal.3")
                                })
                                .accentColor(Color.MyTheme.purpleColor)
                                .opacity(isMyProfile ? 1.0 : 0.0)
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView{
            ProfileView(profileDisplayName: "Joe", profileUserId: "", isMyProfile: true)
        }
    }
}
