//
//  UserProfileView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 25/2/2024.
//

import SwiftUI

struct UserProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
