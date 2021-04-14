//
//  MessageView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 05/02/21.
//

import SwiftUI

struct MessageView: View {
    
    @State var comment: CommentModel
    @State var profilePicture:UIImage = UIImage(named: "logo.loading")!
    var body: some View {
        HStack{
            //ProfileImage
            Image(uiImage: profilePicture)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 4, content: {
                
                //Username
                Text(comment.userName)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                //Comment
                Text(comment.content)
                    .padding(.all, 10)
                    .foregroundColor(.primary)
                    .background(Color.gray)
                    .cornerRadius(10)
            })
            Spacer(minLength: 0)
        }
        .onAppear {
            getProfileImage()
        }
    }
    
    //MARK:- FUNCTIONS
    func getProfileImage(){
        ImageManager.instance.downloadProfileImage(userID: comment.userID) { (returnedImage) in
            if let image = returnedImage {
                self.profilePicture = image
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    
    static var comment = CommentModel(commentId: "",userID: "",userName: "Dazzy", content: "Whataa a doggy!!", dateCreated: Date())
    
    static var previews: some View {
        MessageView(comment: comment)
            .previewLayout(.sizeThatFits)
    }
}
