//
//  CommunityDetailView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 24/12/2023.
//

import SwiftUI

struct LotInformationDetailView: View {
    
    @Environment(\.modelContext) var modelContex
    @Bindable var lotInfo: LotInformation
    
    @State private var lotId = ""
    @State private var lotDesription = ""
    @State private var lotColour = ""
    
    var body: some View {
            VStack (alignment: .center ) {
                Form {
                    List {
                        HStack {
                            
                            //LabeledContent("Lot ID", value: lotInfo.lotName).foregroundColor(.teal).bold()
                            
                            Text ("Lot ID:")
                            Spacer()
                            Text (lotInfo.name).foregroundColor(.teal).bold()
                        }
                        
                        HStack {
                            Text ("Lot Description:")
                            Spacer()
                            Text (lotInfo.details).foregroundColor(.purple).bold()
                        }
                        
                        HStack {
                            Text ("Lot Colour:")
                            Spacer()
                            Text (lotInfo.colourDescriptor ?? "").foregroundColor(.blue).bold()
                        }
                        
                        HStack {
                            Text ("Lot Latitude:")
                            Spacer()
                            Text (String(format: "%.4f", lotInfo.latitude)).foregroundColor(.blue).bold()
                        }
                        
                        HStack {
                            Text ("Lot Longitude:")
                            Spacer()
                            Text (String(format: "%.4f", lotInfo.longitude)).foregroundColor(.blue).bold()
                        }
                        
                        HStack (alignment: .top) {
                            Spacer()
                            Button("Edit Location of POI", action: editPOILocation)
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.roundedRectangle)
                                .tint(.blue)
                                .controlSize(.small)
                            Spacer()
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
    }
    
    func editPOILocation () {
        
    }
}

#Preview {
    NavigationStack {
        SingleItemPreview<LotInformation> { lotInfo in // set the type
            LotInformationDetailView(lotInfo: lotInfo)
        }
        .modelContainer(DataController.previewContainer)
        .environmentObject(LocationDataManager.preview)
    }
}
