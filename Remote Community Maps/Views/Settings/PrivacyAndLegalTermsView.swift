//
//  PrivacyAndLegalTermsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 27/2/2024.
//

import SwiftUI

struct PrivacyAndLegalTermsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Privacy & Legal Terms")
        }.toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
        }
        .accentColor(.black)
        .toolbarBackground(.white, for: .navigationBar) //<- Set background
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Privacy & Legal Terms")
        .navigationBarBackButtonHidden()
        
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button { dismiss() } label: { Image(systemName: "xmark").fontWeight(.bold) }
    }
}

#Preview {
    PrivacyAndLegalTermsView()
}
