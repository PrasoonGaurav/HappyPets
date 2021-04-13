//
//  PostArrayObject.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 05/02/21.
//

import Foundation

class PostArrayObject : ObservableObject{
    
    @Published var dataArray = [PostModel]()
    
    ///Used for single post selection
    init(post: PostModel) {
        self.dataArray.append(post)
    }
    
    ///Used for getting posts for user profile
    init(userID: String) {
        print("Get posts for userID \(userID)")
        DataService.instance.downloadPostForUser(userID: userID) { (returnedPosts) in
            let sortedPost = returnedPosts.sorted { (post1, post2) -> Bool in
                return post1.dateCreated > post2.dateCreated
            }
            self.dataArray.append(contentsOf: sortedPost)
        }
    }
    
    ///Used for Feed
    init(shuffled:Bool) {
        print("Get posts for Feed. Shuffled: \(shuffled)")
        DataService.instance.downloadPostforFeed { (returnedPost) in
            if shuffled {
                let shuffledPost = returnedPost.shuffled()
                self.dataArray.append(contentsOf: shuffledPost)
            }else{
                self.dataArray.append(contentsOf: returnedPost)
            }
        }
    }
}
