
//
//  MapTestView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 10/3/2024.
//

import MapKit
import SwiftUI

struct MapTestView: View {
    
    @State private var presentSearchTextField = true
    @State private var showSearch: Bool = true
    @State private var lotIdBeingSearched = ""
    @State private var presentBottomSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                //            HStack (alignment: .top ) {
                //                Form {
                //                    TextField ("Search", text: $lotIdBeingSearched)
                //                }
                //                .frame(height: 100)
                //            }
                
                
                ZStack (alignment: .topTrailing) {
                    Map {}
                }
                
                HStack {
                    Button("House Details") {
                        print("Button tapped!")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(.teal)
                    .controlSize(.small)
                    
                    
                    Button("Navigate") {
                        print("Button tapped!")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(.blue)
                    .controlSize(.small)
                }
                .padding(.bottom, 10)
            }
            .searchable( text: $lotIdBeingSearched, isPresented: $presentSearchTextField ).autocorrectionDisabled().keyboardType(.asciiCapable)
            .navigationTitle("Search For Location")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: lotIdBeingSearched) {
                searchForLot()
                presentSearchTextField = false
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .sheet (isPresented: $presentBottomSheet, onDismiss: {presentSearchTextField = true}) {
                Text ("Hello")
                    .presentationDetents([.height(475)])
                    .presentationCornerRadius(12)
            }
        }
    }
    
    func searchForLot () {
        print("Search Field changed to \($lotIdBeingSearched.wrappedValue)")
        presentBottomSheet = true
    }
}

#Preview {
    MapTestView()
}
