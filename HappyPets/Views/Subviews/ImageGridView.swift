//
//  ImageGridView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 06/02/21.
//

import SwiftUI

struct ImageGridView: View {
    
    @ObservedObject var posts : PostArrayObject
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ],
        alignment: .center,
        spacing: nil,
        pinnedViews: [],
        content: {
            ForEach(posts.dataArray, id: \.self) { post in
                //Navigation to feed view for the detail of that particular post
                NavigationLink(
                    destination: FeedView(posts: PostArrayObject(post: post), title: "Post"),
                    label: {
                        PostView(post: post, showHeaderAndFooter: false, addHeartAnimationToView: false)
                    })
            }
        })
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(posts: PostArrayObject())
            .previewLayout(.sizeThatFits)
    }
}
