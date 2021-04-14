//
//  CommentsView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 05/02/21.
//

import SwiftUI

struct CommentsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var submissionText:String = ""
    @State var commentArray = [CommentModel]()
    @State var profileImage:UIImage = UIImage(named: "logo.loading")!
    @AppStorage(CurrentUserDefault.userID) var currentUserId : String?
    @AppStorage(CurrentUserDefault.displayName) var currentUserDisplayName : String?
    var post : PostModel
    
    var body: some View {
        
        VStack{
            //Message Scroll View
            ScrollView{
                LazyVStack{
                    ForEach(commentArray, id: \.self) { comment in
                        MessageView(comment: comment)
                    }
                }
            }
            
            //Bottom HStack
            HStack{
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                TextField("Comment here...", text: $submissionText)
                
                Button(action: {
                    if textIsAppropriate(){
                        addComment()
                    }
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                        .font(.title2)
                })
            }
            .padding(.all, 6)
        }
        .padding(.all,10)
        .navigationBarTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear(perform: {
            getComments()
            getProfilePicture()
        })
    }
    
    //Functions
    
    func getProfilePicture(){
        guard let userID = currentUserId else {
            print("Error geting userID for downloading comments")
            return
        }
        
        ImageManager.instance.downloadProfileImage(userID: userID) { (returnedProfileImage) in
            if let image = returnedProfileImage {
                self.profileImage = image
            }
        }
    }
    
    func getComments() {
        print("Get comments from Database")
        guard self.commentArray.isEmpty else{
            return
        }
        
        if let caption = post.captions, caption.count > 1{
            let captionComment = CommentModel(commentId: "", userID: post.userId, userName: post.userName, content: caption, dateCreated: post.dateCreated)
            self.commentArray.append(captionComment)
        }
        
        DataService.instance.downloadComments(postID: post.postID) { (returnedComments) in
            self.commentArray.append(contentsOf: returnedComments)
        }
    }
    
    func textIsAppropriate() -> Bool {
        // For example:-
        // Check if the text has curses
        // Check if the text is long enough
        // Check if the text is blank
        // Check if the text has inappropraite things
        
        //Checkingfor bad words
        let badWordsArray = ["Fuck", "Ass"]
        let words = submissionText.components(separatedBy: " ")
        for word in words{
            if badWordsArray.contains(word){
                return false
            }
        }
        
        //Checking for minimum character count
        if submissionText.count < 3{
            return false
        }
        return true
    }
    
    func addComment(){
        
        guard let displayName = currentUserDisplayName, let userID = currentUserId else{
            return
        }
        
        DataService.instance.uploadComment(postID: post.postID, content: submissionText , displayName: displayName, userID: userID) { (success, returnedCommentID) in
            if success, let commentId = returnedCommentID{
                let newComment = CommentModel(commentId: commentId, userID: userID, userName: displayName, content: submissionText, dateCreated: Date())
                self.commentArray.append(newComment)
                self.submissionText = ""
                //Dismiss the keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    
    static let post = PostModel(postID: "asdf", userId: "asdf", userName: "asdf", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        NavigationView{
            CommentsView(post: post)
        }
        .preferredColorScheme(.dark)
    }
}
