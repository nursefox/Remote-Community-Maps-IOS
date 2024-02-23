//
//  SheetHouseDetailsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 21/2/2024.
//

import SwiftUI

struct SheetHouseDetailsView: View {
    
    @Bindable var lotInfo: LotInformation
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
                    
                    //                    HStack {
                    //                        Text ("Latitude:")
                    //                        Spacer()
                    //                        Text (String(format: "%.4f", activeLotInfoSelected?.latitude ?? 00)).foregroundColor(.blue).bold()
                    //                    }
                    //
                    //                    HStack {
                    //                        Text ("Longitude:")
                    //                        Spacer()
                    //                        Text (String(format: "%.4f", activeLotInfoSelected?.longitude ?? 00)).foregroundColor(.blue).bold()
                    //                    }
                    
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
            }
        }
        .sheet(isPresented: $isLotInfoEditView) {
            NavigationStack {
                LotInformationEditView (lotInfo: lotInfo, lotName: $lotInfo.name )
            }
            .presentationDetents([.height(450)])
            .presentationCornerRadius(12)
            .presentationDragIndicator(.hidden)
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
    NavigationStack {
        SingleItemPreview<LotInformation> { lotInfo in // set the type
            SheetHouseDetailsView(lotInfo: lotInfo)
        }
        .modelContainer(DataController.previewContainer)
        .environmentObject(LocationDataManager.preview)
    }
}
