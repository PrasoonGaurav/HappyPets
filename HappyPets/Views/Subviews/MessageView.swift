//
//  MessageView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 05/02/21.
//

import SwiftUI

struct MessageView: View {
    
    @State var comment: CommentModel
    
    var body: some View {
        HStack{
            //ProfileImage
            Image("dog1")
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
    }
}

struct MessageView_Previews: PreviewProvider {
    
    static var comment = CommentModel(commentId: "",userID: "",userName: "Dazzy", content: "Whataa a doggy!!", dateCreated: Date())
    
    static var previews: some View {
        MessageView(comment: comment)
            .previewLayout(.sizeThatFits)
    }
}
