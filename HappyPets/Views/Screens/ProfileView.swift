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
    @State var profileBio : String = ""
    var profileUserId: String
    var isMyProfile: Bool
    var posts : PostArrayObject
    @State var showSettings: Bool = false
    
    @State var profileImage:UIImage = UIImage(named: "logo.loading")!
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage, profileBio: $profileBio, postArray: posts)
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
        .onAppear(perform: {
            getProfileImage()
            getAdditionalProfileInfo()
        })
        .sheet(isPresented: $showSettings, content: {
            SettingsView(userDisplayName: $profileDisplayName, userBio: $profileBio, userProfilePicture: $profileImage)
                .preferredColorScheme(colorScheme)
        })
    }
    
    //MARK:- FUNCTIONS
    func getProfileImage(){
        ImageManager.instance.downloadProfileImage(userID: profileUserId) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
    
    func getAdditionalProfileInfo(){
        AuthService.instance.getUserInfo(forUserID: profileUserId) { (returnedDisplayName, returnedBio) in
            if let displayName = returnedDisplayName {
                self.profileDisplayName = displayName
            }
            if let bio = returnedBio{
                self.profileBio = bio
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView{
            ProfileView(profileDisplayName: "Joe", profileBio: "", profileUserId: "", isMyProfile: true, posts: PostArrayObject(userID: ""))
                .preferredColorScheme(.light)
        }
    }
}
