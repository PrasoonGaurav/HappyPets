//
//  PostArrayObject.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 05/02/21.
//

import Foundation

class PostArrayObject : ObservableObject{
    
    @Published var dataArray = [PostModel]()
    
    init() {
        
        print("FETCH FROM DATABASE HERE")
        
        let post1 = PostModel(postID: "", userId: "", userName: "Tommy", captions: "This is Tommy's caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post2 = PostModel(postID: "", userId: "", userName: "Shyamu", captions: nil , dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post3 = PostModel(postID: "", userId: "", userName: "Dazzy", captions: "This is a vry larrrrgggeeee caption !!!!", dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post4 = PostModel(postID: "", userId: "", userName: "Siro", captions: nil, dateCreated: Date(), likeCount: 0, likedByUser: false)
        
        self.dataArray.append(post1)
        self.dataArray.append(post2)
        self.dataArray.append(post3)
        self.dataArray.append(post4)
    }
    
    ///Used for single post selection
    init(post: PostModel) {
        self.dataArray.append(post)
    }
    
    ///Used for getting posts for user profile
    init(userID: String) {
         print("Get post for userID \(userID)")
        DataService.instance.downloadPostForUser(userID: userID) { (returnedPosts) in
            let sortedPost = returnedPosts.sorted { (post1, post2) -> Bool in
                return post1.dateCreated > post2.dateCreated
            }
            self.dataArray.append(contentsOf: sortedPost)
        }
        
    }
    
}
