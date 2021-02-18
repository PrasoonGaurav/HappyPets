//
//  CommentsView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 05/02/21.
//

import SwiftUI

struct CommentsView: View {
    
    @State var submissionText:String = ""
    @State var commentArray = [CommentModel]()
    
    var body: some View {
        
        VStack{
            ScrollView{
                LazyVStack{
                    ForEach(commentArray, id: \.self) { comment in
                        MessageView(comment: comment)
                    }
                }
            }
            
            HStack{
                Image("dog1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                TextField("Comment here...", text: $submissionText)
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .accentColor(Color.MyTheme.purpleColor)
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
        })
        
    }
    
    //Functions
    func getComments() {
        
        print("Get comments from Database")
        
        let comment1 = CommentModel(commentId: "", userID: "", userName: "Dazzy", content: "This is the first comment", dateCreated: Date())
        
        let comment2 = CommentModel(commentId: "", userID: "", userName: "Danniel", content: "This is the second comment", dateCreated: Date())
        
        let comment3 = CommentModel(commentId: "", userID: "", userName: "Tommy", content: "This is the third comment", dateCreated: Date())
        
        let comment4 = CommentModel(commentId: "", userID: "", userName: "Shyamu", content: "This is the fourth comment", dateCreated: Date())
        
        commentArray.append(comment1)
        commentArray.append(comment2)
        commentArray.append(comment3)
        commentArray.append(comment4)
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CommentsView()
        }
    }
}
