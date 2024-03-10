//
//  AuthenticationView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 22/2/2024.
//

import SwiftUI

struct OldAuthenticationView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    AuthenticationView()
                    //SignInMethodView(showSignInView: $showSignInView)
                    //SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text ("Sign In With Email")
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    NavigationStack {
        OldAuthenticationView(showSignInView: .constant(false))
    }
}
