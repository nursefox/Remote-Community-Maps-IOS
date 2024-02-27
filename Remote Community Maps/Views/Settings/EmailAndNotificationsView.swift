//
//  EmailAndNotificationsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 27/2/2024.
//

import SwiftUI

struct EmailAndNotificationsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Email and Notifications")
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
        }
        .accentColor(.black)
        .toolbarBackground(.white, for: .navigationBar) //<- Set background
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Email & Notifications")
        .navigationBarBackButtonHidden()
        
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button { dismiss() } label: { Image(systemName: "xmark").fontWeight(.bold) }
    }
}

#Preview {
    EmailAndNotificationsView()
}
