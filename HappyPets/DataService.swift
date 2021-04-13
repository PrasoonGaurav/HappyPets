//
//  DataService.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 13/04/21.
//

//Used to handle upload and download data (other than User) from our database.
import Foundation
import SwiftUI
import FirebaseFirestore

class DataService{
    
    //MARK:- Properties
    static let instance = DataService()
    private var REF_POSTS = DB_BASE.collection("posts")
    @AppStorage(CurrentUserDefault.userID) var currentUserId:String?
    
    //MARK:- Create Functions
    
    func uploadPost(image: UIImage, caption:String?, displayName: String, userID: String, handler: @escaping (_ success: Bool) -> ()){
        
        //Create new Post document
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        //Upload image to storage
        ImageManager.instance.uploadPostImage(postID: postID, image: image) { (success) in
            if success{
                //Succesfully uploaded image data to storage
                //Now upload post data to database
                
                let postData : [String: Any] = [
                    DatabasePostField.postID: postID,
                    DatabasePostField.userID: userID,
                    DatabasePostField.displayName: displayName,
                    DatabasePostField.caption: caption,
                    DatabasePostField.dateCreated: FieldValue.serverTimestamp()
                ]
                
                document.setData(postData) { (error) in
                    if let error = error {
                        print("Error uploading data to document \(error)")
                        handler(false)
                        return
                    }
                    else{
                        //Return back to the app
                        handler(true)
                        return
                    }
                }
                
            }
            else{
                print("Error uploading post image to firebase")
                handler(false)
                return
            }
        }
        
    }
    
    //MARK:- GET FUNCTIONS
    func downloadPostForUser(userID: String, handler:@escaping (_ posts: [PostModel]) -> ()){
        
        REF_POSTS.whereField(DatabasePostField.userID, isEqualTo: userID).getDocuments { (querrySnapshot, error) in
            handler(self.getPostsfromSnapshot(querrySnapshot: querrySnapshot))
        }
    }
    
    func downloadPostforFeed(handler:@escaping (_ post:[PostModel]) -> ()){
        REF_POSTS.order(by: DatabasePostField.dateCreated, descending: true).limit(to: 50).getDocuments {(querrySnapshot, error) in
            handler(self.getPostsfromSnapshot(querrySnapshot: querrySnapshot))
        }
    }
    
    private func getPostsfromSnapshot(querrySnapshot: QuerySnapshot?) -> [PostModel]{
        var postArray = [PostModel]()
        
        if let snapShot = querrySnapshot, snapShot.documents.count > 0{
            for document in snapShot.documents{
                
                if let userID = document.get(DatabasePostField.userID) as? String,
                   let displayName = document.get(DatabasePostField.displayName) as? String,
                   let timeStamp = document.get(DatabasePostField.dateCreated) as? Timestamp{
                    
                    let caption = document.get(DatabasePostField.caption) as? String
                    let date = timeStamp.dateValue()
                    let postID = document.documentID
                    let likeCount = document.get(DatabasePostField.likesCount) as? Int ?? 0
                    
                    var likedByUser: Bool = false
                    if let userIDArray = document.get(DatabasePostField.likedBy) as? [String], let userId = currentUserId {
                        likedByUser = userID.contains(userID)
                    }
                    
                    let newPost = PostModel(postID: postID, userId: userID, userName:displayName , captions: caption, dateCreated: date, likeCount: likeCount, likedByUser: likedByUser)
                    
                    postArray.append(newPost)
                }
            }
            return postArray
        }
        else{
            print("No documents in snapshot found for this user")
            return postArray
        }
    }
    
    //MARK:- Update Functions
    func likePost(postID:String, currentUserID: String) {
        //Update the post count
        //Update the array of users who liked the post
        
        let increment: Int64 = 1
        let data:[String:Any] = [
            DatabasePostField.likesCount : FieldValue.increment(increment),
            DatabasePostField.likedBy : FieldValue.arrayUnion([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func unlikePost(postID:String, currentUserID: String) {
        //Update the post count
        //Update the array of users who liked the post
        
        let increment: Int64 = -1
        let data:[String:Any] = [
            DatabasePostField.likesCount : FieldValue.increment(increment),
            DatabasePostField.likedBy : FieldValue.arrayRemove([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    
    
}

