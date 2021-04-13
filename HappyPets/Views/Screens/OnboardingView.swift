//
//  OnboardingView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 23/03/21.
//

import SwiftUI
import FirebaseAuth

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showOnboardingPart2: Bool = false
    @State var showError:Bool = false
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var providerID: String = ""
    @State var provider: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 12)
            
            Text("Welcome to HappyPets!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.purpleColor)
            
            Text("HappyPets is the #1 app for posting pictures of your pets and sharing them across the world. We are a pets-loving community and we're happy to have you!")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.purpleColor)
                .padding()
            
            //MARK:- SignIn With Apple
            Button(action: {
                SignInWithApple.instance.startSignInWithAppleFlow(view: self)
            }, label: {
                SignInWithAppleButtonCustom()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
            })
            
            //MARK:- SignIn With Google
            Button(action: {
                SignInWithGoogle.instance.startSignInwithGoolgeFlow(view: self)
            }, label: {
                HStack {
                    
                    Image(systemName: "globe")
                    
                    Text("Sign in with Google")
                    
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(.sRGB, red: 222/255, green: 82/255, blue: 70/255, opacity: 1.0))
                .cornerRadius(6)
                .font(.system(size: 23, weight: .medium, design: .default))
                
            })
            .accentColor(Color.white)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Continue as guest".uppercased())
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
                
            })
            .accentColor(.black)
        }
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.beigeColor)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnboardingPart2,onDismiss: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {
            OnboardingViewPart2(displayName: $displayName, email: $email, providerID: $providerID, provider: $provider)
        })
        .alert(isPresented: $showError, content: {
            return Alert(title: Text("Error signing in!"))
        }) 
    }
    
    //    MARK:- FUNCTIONS
    
    func connectToFirebase(name:String, email:String, provider:String, credential: AuthCredential){
        
        AuthService.instance.logInUserToFirebase(credential: credential) { (returnedProviderId, isError, isNewUser, returnedUserID) in
            
            if let newUser = isNewUser{
                if newUser {
                    //New User
                    if let providerID = returnedProviderId, !isError{
                        //SUCCESS
                        //New User, Continue to Onboarding part 2
                        self.displayName = name
                        self.email = email
                        self.providerID = providerID
                        self.provider = provider
                        
                        self.showOnboardingPart2.toggle()
                        
                    }
                    else{
                        //ERROR
                        print("Error getting providerID from log in user to Firebase")
                        self.showError.toggle()
                    }
                }
                else{
                    //Existing User
                    if let userID = returnedUserID{
                        //SUCCESS, LOG INTO APP
                        AuthService.instance.logInUserToApp(userID: userID) { (sucess) in
                            if sucess{
                                print("Successful log in existing user")
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            else{
                                print("Error logging existing user to our app")
                                self.showError.toggle()
                            }
                        }
                    }
                    else{
                        //ERROR
                        //ERROR
                        print("Error getting USER ID from existing user in Firebase")
                        self.showError.toggle()
                    }
                }
            }
            else{
                //ERROR
                print("Error getting info from log in user to Firebase")
                self.showError.toggle()
            }
        }
    }
}



struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
