//
//  UserProfileView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 25/2/2024.
//

import SwiftUI

struct UserProfileView: View {
    
    @StateObject private var viewModel = UserProfileViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    
    @State private var suburb = ""
    @State private var state = ""
    @State private var postCode = ""
    @State private var country = ""
    
    @State private var jobTitle = ""
    
    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]
    
    private func preferenceIsSelected(text: String) -> Bool {
        viewModel.user?.preferences?.contains(text) == true
    }
    
    //@State private var user: AuthDataResultModel? = nil
    
    var body: some View {
        VStack {
            Form {
                Section ("Contact Details") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
                
                Section ("Location") {
                    TextField("Suburb/City", text: $lastName)
                    TextField("State", text: $state)
                    TextField("Post Code", text: $postCode)
                    TextField("Country", text: $country)
                }
                Section ("Other") {
                    TextField("Job Title", text: $jobTitle)
                }                
            }
            
            List {
                if let user = viewModel.user {
                    Text ("UserID: \(user.userId)")
                    
                    if let isAnonymous = user.isAnonymous {
                        Text ("Is Anonymous: \(isAnonymous.description.capitalized)")
                    }
                    
                    Button {
                        viewModel.togglePremiumStatus()
                    } label: {
                        Text ("User is premium: \((user.isPremium ?? false).description.capitalized)")
                    }
                    //.buttonStyle(.borderedProminent)
                    
                    VStack {
                        HStack {
                            ForEach (preferenceOptions, id: \.self) { string in
                                Button (string) {
                                    
                                    if preferenceIsSelected(text: string) {
                                        viewModel.removeUserPreferences(text: string)
                                    } else {
                                        viewModel.addUserPreferences(text: string)
                                    }
                                    
                                    viewModel.addUserPreferences(text: string)
                                }
                                .font (.headline)
                                .buttonStyle(.borderedProminent)
                                .tint(preferenceIsSelected(text: string) ? .green : .red)
                            }
                        }
                        
                        Text ("User Preferences: \((user.preferences ?? []).joined(separator: ", "))")
                            .frame (maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        
                        
                        Button {
                            if user.favouriteMovie == nil {
                                viewModel.addFavouriteMovie()
                            } else {
                                viewModel.removeFavouriteMovie()
                            }
                        } label: {
                            Text ("Favourite Movie: \((user.favouriteMovie?.title ?? "").description.capitalized)")
                        }

                    }
                } else {
                    Text ("User Not Found")
                }
            }
        }
        .task {
            //try? loadCurrentUser()
            try? await viewModel.loadCurrentUser()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
            ToolbarItem(placement: .topBarTrailing) {
                Image (systemName: "gear")
                    .font(.headline
                    )
                
            }
        }
        //.accentColor(.black)
        .toolbarBackground(.white, for: .navigationBar) //<- Set background
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("User Profile")
        .navigationBarBackButtonHidden()
        
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button { dismiss() } label: { Image(systemName: "xmark").fontWeight(.bold) }
    }
    
    
}

#Preview {
    NavigationStack {
        UserProfileView()
    }
}
