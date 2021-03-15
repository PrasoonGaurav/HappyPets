//
//  PostView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 04/02/21.
//

import SwiftUI

struct PostView: View {
    
    @State var post:PostModel
    var showHeaderAndFooter : Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            
            //MARK:- HEADER
            if showHeaderAndFooter{
                HStack {
                    
                    NavigationLink(
                        destination: ProfileView(profileDisplayName: post.userName, profileUserId: post.userId, isMyProfile: false),
                        label: {
                            //User Profile image
                            Image("dog1")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30, alignment: .center)
                                .cornerRadius(15)
                            
                            //UserName
                            Text(post.userName)
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        })
                    
                    Spacer()
                    
                    //Side three dots button
                    Image(systemName: "ellipsis")
                        .font(.headline)
                }
                .padding(.all, 6)
            }
            

            //MARK:- IMAGE
            Image("dog1")
                .resizable()
                .scaledToFit()
            
            //MARK:- FOOTER
            if showHeaderAndFooter{
                
                HStack(alignment: .center, spacing: 20, content: {
                    //like,comment, share
                    Image(systemName: "heart")
                        .font(.title3)
                    
                    //NavigationLink to comentsView when tapped on comment icon
                    NavigationLink(
                        destination: CommentsView(),
                        label: {
                            Image(systemName: "bubble.middle.bottom")
                                .font(.title3)
                                .foregroundColor(.primary)
                        })
                    
                    
                    Image(systemName: "paperplane")
                        .font(.title3)
                    
                    Spacer()
                })
                .padding(.all, 6)
                
                //caption
                if let caption = post.captions{
                    HStack {
                        Text(caption)
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.all, 6)
                }
            }

        })
    }
}

struct PostView_Previews: PreviewProvider {
    
    static var post:PostModel = PostModel( postID: "", userId: "", userName: "Prasoon Gaurav", captions: "Test Caption 1", date: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true)
            .previewLayout(.sizeThatFits)
    }
}
