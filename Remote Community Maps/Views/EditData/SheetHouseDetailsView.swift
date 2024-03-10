//
//  SheetHouseDetailsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 21/2/2024.
//

import SwiftUI

struct SheetHouseDetailsView: View {
    
    @Bindable var lotInfo: LotInformation
    @State var searchableFieldDisabled: Bool
    @State private var isLotInfoEditView = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .center ) {
                Form {
                    List {
                        HStack {
                            Text ("ID:")
                            Spacer()
                            Text (lotInfo.name).foregroundColor(.teal).bold()
                        }
                        //.presentationDetents([.medium, .large])
                        .presentationDetents([.height(275)])
                        .presentationCornerRadius(12)
                        .presentationDragIndicator(.hidden)
                        
                        HStack {
                            Text ("Description:")
                            Spacer()
                            Text (lotInfo.details).foregroundColor(.purple).bold()
                        }
                        
                        HStack {
                            Text ("Colour:")
                            Spacer()
                            Text (lotInfo.colourDescriptor ?? "").foregroundColor(.blue).bold()
                        }
                    }
                    
                    HStack (alignment: .top) {
                        Spacer()
                        Button("Suggest An Edit", action: activateEditLotInformation)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.roundedRectangle)
                            .tint(.blue)
                            .controlSize(.small)
                        Spacer()
                    }
                }
                .listStyle(PlainListStyle())
                .toolbar {
                    ToolbarItem(placement: .cancellationAction, content: cancelButton)
                }
                .accentColor(.black)
                .toolbarBackground(.white, for: .navigationBar) //<- Set background
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("House Details")
                .onAppear() {
                    print ("SheetHouseDetailsView () : onAppear()")
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
//                        print ("Hiding Keyboard")
//                        hideKeyboard()
//                    }
                }
            }
        }
        .sheet(isPresented: $isLotInfoEditView) {
            NavigationStack {
                LotInformationEditView (lotInfo: lotInfo, lotName: $lotInfo.name )
            }
            .presentationDetents([.height(450)])
            .presentationCornerRadius(12)
            .presentationDragIndicator(.hidden)
         // .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button { dismiss() } label: { Image(systemName: "xmark").fontWeight(.bold) }
    }
    
    func activateEditLotInformation() {
        isLotInfoEditView = true
    }
    
}


#Preview {
    //NavigationStack {
        SingleItemPreview<LotInformation> { lotInfo in // set the type
            SheetHouseDetailsView(lotInfo: lotInfo, searchableFieldDisabled: false)
        }
        .modelContainer(DataController.previewContainer)
        .environmentObject(LocationDataManager.preview)
   // }
}
