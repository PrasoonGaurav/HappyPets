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
    @State var animatelike: Bool = false
    @State var addHeartAnimationToView: Bool
    @State var showActionSheet: Bool = false
    @State var actionSheetType: PostActionSheetOption = .general
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var postImage:UIImage = UIImage(named: "logo.loading")!
    
    @AppStorage(CurrentUserDefault.userID) var currentUserID: String?
    
    //ALERTS
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    enum PostActionSheetOption{
        case general
        case reporting
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            
            //MARK:- HEADER
            if showHeaderAndFooter{
                HStack {
                    
                    NavigationLink(
                        destination:LazyView(content: {
                            ProfileView(profileDisplayName: post.userName, profileUserId: post.userId, isMyProfile: false, posts: PostArrayObject(userID: post.userId))
                        }),
                        label: {
                            //User Profile image
                            Image(uiImage: profileImage)
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
                    Button(action: {
                        showActionSheet.toggle()
                    }, label: {
                        Image(systemName: "ellipsis")
                            .font(.headline)
                    })
                    .accentColor(.primary)
                    .actionSheet(isPresented: $showActionSheet, content: {
                        getActionSheet()
                    })
                }
                .padding(.all, 6)
            }
            

            //MARK:- IMAGE
            ZStack{
                Image(uiImage: postImage)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture(count: 2) {
                        if !post.likedByUser {
                            likePost()
                        }
                    }
                
                if addHeartAnimationToView{
                    LikeAnimationVIew(animate: $animatelike)
                }

            }
            
            //MARK:- FOOTER
            if showHeaderAndFooter{
                
                HStack(alignment: .center, spacing: 20, content: {
                    //like,comment, share
                    
                    Button(action: {
                        if post.likedByUser{
                            //unlike
                            unlikePost()
                        }
                        else{
                            //like
                            likePost()
                        }
                    }, label: {
                        Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                    })
                    .accentColor(post.likedByUser ? .red : .primary)
                    
                    //NavigationLink to comentsView when tapped on comment icon
                    NavigationLink(
                        destination: CommentsView(post: post),
                        label: {
                            Image(systemName: "bubble.middle.bottom")
                                .font(.title3)
                                .foregroundColor(.primary)
                        })
                    
                    Button(action: {
                        sharePost()
                    }, label: {
                        Image(systemName: "paperplane")
                            .font(.title3)
                    })
                    .accentColor(.primary)
                    
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
        .onAppear(){
            getImages()
        }
        .alert(isPresented: $showAlert) { () -> Alert in
            return Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    //MARK:- FUNCTIONS
    func likePost(){
        
        guard  let userID = currentUserID else {
            print("Cannot find user id while liking the post")
            return
        }
        
        //Update the local data
        let updatedPost = PostModel(postID: post.postID, userId: post.userId, userName: post.userName, captions: post.captions, dateCreated: post.dateCreated, likeCount: post.likeCount + 1, likedByUser: true)
        
        self.post = updatedPost
        
        //Animate UI
        animatelike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animatelike = false
        }
        
        //Update the Database
        DataService.instance.likePost(postID: post.postID, currentUserID: userID)
    }
    
    func unlikePost(){
        guard  let userID = currentUserID else {
            print("Cannot find user id while unsliking the post")
            return
        }
        
        let updatedPost = PostModel(postID: post.postID, userId: post.userId, userName: post.userName, captions: post.captions, dateCreated: post.dateCreated, likeCount: post.likeCount - 1, likedByUser: false)
        
        self.post = updatedPost
        
        //Update the Database
        DataService.instance.unlikePost(postID: post.postID, currentUserID: userID)
    }
    
    func getImages(){
        //Get Profile Image
        ImageManager.instance.downloadProfileImage(userID: post.userId) { (returnedProfileImage) in
            if let image = returnedProfileImage{
                self.profileImage = image
            }
        }
        
        //Get Profile Image
        ImageManager.instance.downloadPostImage(postID: post.postID) { (returnedPostImage) in
            if let image = returnedPostImage{
                self.postImage = image
            }
        }
    }
    
    func getActionSheet() -> ActionSheet{
        switch self.actionSheetType {
        case .general:
            return ActionSheet(title: Text("What would you like to do?"), message: nil, buttons: [
                .destructive(Text("Report"), action: {
                    self.actionSheetType = .reporting
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                        self.showActionSheet.toggle()
                    }
                }),
                
                .default(Text("Learn more..."), action: {
                    print("Learn More pressed")
                }),
                
                .cancel()
            ])
            
        case .reporting:
            return ActionSheet(title: Text("Why do you want to report?"), message: nil, buttons: [
                .destructive(Text("This is inappropriate"), action: {
                    reportPost(reason: "This is inappropriate")
                }),
                
                .destructive(Text("This is spam"), action: {
                    reportPost(reason: "This is spam")
                }),
                
                .destructive(Text("It made me uncomfortable"), action: {
                    reportPost(reason: "It made me uncomfortable")
                }),
                
                .cancel({
                    self.actionSheetType = .general
                })
            ])
        }
    }
    
    func reportPost(reason: String){
        print("Report post now")
        DataService.instance.uploadReport(reason: reason, postID: post.postID) { (success) in
            if success{
                self.alertTitle = "Reported!"
                self.alertMessage = "Thanks for reporting. We will review it shortly and take appropriate action!"
                self.showAlert.toggle()
            }
            else{
                self.alertTitle = "Error"
                self.alertMessage = "There was error uploading the report. Please restart the app and try again."
                self.showAlert.toggle()
            }
        }
    }
    
    func sharePost(){
        let message = "Check out this post from HappyPets!"
        let image = postImage
        let link = URL(string: "https://www.google.com")!
        
        let activityViewController = UIActivityViewController(activityItems: [message,image,link], applicationActivities: nil)
        
        let viewController = UIApplication.shared.windows.first?.rootViewController
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}




struct PostView_Previews: PreviewProvider {
    
    static var post:PostModel = PostModel( postID: "", userId: "", userName: "Prasoon Gaurav", captions: "Test Caption 1", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true, addHeartAnimationToView: true)
            .previewLayout(.sizeThatFits)
    }
}
