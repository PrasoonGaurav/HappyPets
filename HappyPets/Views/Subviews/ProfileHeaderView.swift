//
//  ProfileHeaderView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 15/03/21.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @Binding var profileDisplayName: String
    @Binding var profileImage:UIImage
    @Binding var profileBio:String
    @ObservedObject var postArray:PostArrayObject
    
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            //MARK:- Profile Picture
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(60)
            //MARK:- User Name
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            //MARK:- Bio
            if profileBio != ""{
                Text(profileBio)
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
            
            HStack(alignment: .center, spacing: 20, content: {
                //MARK:- Posts
                VStack(alignment: .center, spacing: 5
                       , content: {
                        Text(postArray.postCountString)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(Color.gray)
                            .frame(width: 20, height: 2, alignment: .center)
                        
                        Text("Posts")
                            .font(.callout)
                            .fontWeight(.medium)
                       })
                //MARK:- Likes
                VStack(alignment: .center, spacing: 5
                       , content: {
                        Text(postArray.likeCountString)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(Color.gray)
                            .frame(width: 20, height: 2, alignment: .center)
                        
                        Text("Likes")
                            .font(.callout)
                            .fontWeight(.medium)
                       })
            })
        })
        .frame(maxWidth:.infinity)
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    
    @State static var name: String = "Joe"
    @State static var image:UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileImage: $image, profileBio: $name, postArray: PostArrayObject(shuffled: false))
            .previewLayout(.sizeThatFits)
    }
}
