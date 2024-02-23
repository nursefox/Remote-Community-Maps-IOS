//
//  LotInformationEditView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 24/12/2023.
//

import SwiftUI

struct LotInformationEditView: View {
    
    @Environment(\.modelContext) var modelContex
    @Environment(\.dismiss) var dismiss
    
    @Bindable var lotInfo: LotInformation
    @Binding var lotName: String
    
    @State private var tempLotName = ""
    @State private var lotDescription = ""
    @State private var lotColour = ""
    
    @State private var isEditPOILocationSheetActive = false
    
    //  @State private var path = NavigationPath()
    
    @State private var isPresenting = false
    
    var body: some View {
        
        VStack (alignment: .center ) {
            Form {
                Section(header: Text("House ID:")) {
                    HStack (alignment: .top ) {
                        TextField ("", text: $tempLotName)
                     //   .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("House Description:")) {
                    HStack (alignment: .top) {
                        TextField ("", text: $lotDescription)
                    //    .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("House Colour:")) {
                    HStack {
                        TextField ("", text: $lotColour)
                      //  .foregroundColor(.blue)
                    }
                }
                
//                HStack {
//                    Text ("Lot Latitude:")
//                    Spacer()
//                    Text (String(format: "%.4f", lotInfo.latitude)).foregroundColor(.blue).bold()
//                }
//                
//                HStack {
//                    Text ("Lot Colour:")
//                    Spacer()
//                    Text (String(format: "%.4f", lotInfo.longitude)).foregroundColor(.blue).bold()
//                }
                
                Section(header: Text("House Location:")) {
                    HStack (alignment: .top) {
                        Spacer()
                        Button("Update House Location Via Map") { isPresenting = true }
                        Spacer()
                    }

                    .navigationTitle("Edit House Details")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.white, for: .navigationBar) //<- Set background
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
                    
                    
                    .fullScreenCover(isPresented: $isPresenting) {
                        EditPointOfInterestLocationView(remoteCommunity: lotInfo.remoteCommunity!, lotInfo: lotInfo)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(.blue)
                    .controlSize(.small)
                    
                }
                
            }
        }
        .onAppear() {
            tempLotName = lotInfo.name
            lotDescription = lotInfo.details
            lotColour = lotInfo.colourDescriptor ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
            ToolbarItem(placement: .confirmationAction) { saveLotInformation().disabled(!canBeSaved) }
        }
        .accentColor(.black)
        //            .sheet(isPresented: $isEditPOILocationSheetActive, content: {
        //                EditPointOfInterestLocationView(remoteCommunity: lotInfo.remoteCommunity!, lotInfo: lotInfo)
        //                    .presentationDetents([.height(250)])
        //                    .presentationCornerRadius(12)
        //                    .presentationDragIndicator(.visible)
        //                    //.environmentObject(modelContext)
        //            })
    }
    
    // The save button is disabled until the user has entered at least one character
    var canBeSaved: Bool { lotName.count > 0 }
    
    func saveLotInformation () -> some View {
        Button {
            print ("Updating Lot Information")
            
            lotInfo.name = tempLotName
            lotInfo.details = lotDescription
            lotInfo.colourDescriptor = lotColour
            lotInfo.updatedByUser = true
            
            try? modelContex.save()
            
            lotName = tempLotName
            
            dismiss()
        } label: { Image(systemName: "checkmark").fontWeight(.bold) }
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button { dismiss() } label: { Image (systemName: "chevron.left").fontWeight(.medium) }
    }
    
    func editPOILocation () {
        
        //isEditPOILocationSheetActive = true
    }
}

#Preview {
    NavigationStack {
        SingleItemPreview<LotInformation> { lotInfo in // set the type
            LotInformationEditView(lotInfo: lotInfo, lotName: .constant(lotInfo.name))
        }
        .modelContainer(DataController.previewContainer)
        .environmentObject(LocationDataManager.preview)
    }
}
