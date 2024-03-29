//
//  UserProfileView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 25/2/2024.
//

import SwiftUI

struct UserProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    
    @State private var suburb = ""
    @State private var state = ""
    @State private var postCode = ""
    @State private var country = ""

    @State private var jobTitle = ""
    
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
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
        }
        .accentColor(.black)
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
