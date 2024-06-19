//
//  RemoteCommunityCloudView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 17/1/2024.
//

import SwiftUI

struct CloudRemoteCommunityDetailView: View {
    
    @EnvironmentObject private var dataStore: CloudDataStoreRemoteCommunity
    
    @State private var remoteCommunity: SODA.Item<CloudModelRemoteCommunity>
    @State private var isEditing: Bool
    
    init(remoteCommunity: SODA.Item<CloudModelRemoteCommunity>?) {
        self.remoteCommunity = remoteCommunity ?? SODA.Item(id: "", etag: "", lastModified: "", created: "", value: CloudModelRemoteCommunity())
        
        // Entering Edit mode if it's a new remote communuity
        isEditing = remoteCommunity == nil
    }
    
    var body: some View {
        Form {
            nameRow()
            traditionalNameRow()
            stateRow()
            latitudeRow()
            longitudeRow()
            
            
            Section {
                Button() {
                    Task.init { remoteCommunity.value = await dataStore.refresh(remoteCommunity: remoteCommunity) }
                } label: {
                    Label("Refresh", systemImage: "arrow.up.arrow.down")
                }
                .disabled(dataStore.isLoading || isEditing)
            }
        }
        .navigationTitle("Community Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        Task.init {
                            
                            // Create a single CloudLotInformation object
                            
                            var lotInfo = CloudLotInformation()
                            lotInfo.name = "278"
                            lotInfo.details = "Clinic"
                            lotInfo.latitude = 55
                            lotInfo.longitude = 200
                            lotInfo.colourDescriptor = "Blue"
                            
                            //remoteCommunity.value.lotData.append(lotInfo)
                            
                            // Ltyentye Apurte
                            var lotInfo2 = CloudLotInformation()
                            lotInfo2.name = "125"
                            lotInfo2.details = "Police Station"
                            lotInfo2.latitude = 134.3703423
                            lotInfo2.longitude = -24.1294314
                            lotInfo2.colourDescriptor = "White"
                            
                            //remoteCommunity.value.lotData.append(lotInfo2)
                            
                            remoteCommunity = await dataStore.addOrUpdate(remoteCommunity: remoteCommunity)
                            isEditing = false
                        }
                    } else {
                        isEditing = true
                    }
                }.disabled(dataStore.isLoading)
            }
        }
    }
    
    private func nameRow() -> some View {
        HStack {
            Text("Community Name").font(Font.body.bold())
            Spacer()
            if isEditing {
                TextField("name", text: $remoteCommunity.value.name)
                    .multilineTextAlignment(.trailing)
            } else {
                Text("\(remoteCommunity.value.name)")
            }
        }
    }
    
    //    private func traditionalNameRow() -> some View {
    //        HStack {
    //            Text("Name").font(Font.body.bold())
    //            Spacer()
    //            if isEditing {
    //                TextField("Traditional Name", text: $remoteCommunity.value.traditionalName)
    //                    .multilineTextAlignment(.trailing)
    //            } else {
    //                Text("\(remoteCommunity.value.traditionalName)")
    //            }
    //        }
    //    }
    
    
    
    private func traditionalNameRow() -> some View {
        HStack {
            Text("Traditional Name").font(Font.body.bold())
            Spacer()
            if isEditing {
                TextField("Traditional Name", text: Binding(
                    get: { String(remoteCommunity.value.traditionalName ?? "") },
                    set: { remoteCommunity.value.traditionalName = $0 == "" ? nil : $0 })
                )
                .multilineTextAlignment(.trailing)
            } else {
                Text(" \(remoteCommunity.value.traditionalName ?? "")")
            }
        }
    }
    
    private func stateRow() -> some View {
        HStack {
            Text("State").font(Font.body.bold())
            Spacer()
            if isEditing {
                TextField("State", text: $remoteCommunity.value.state)
                    .multilineTextAlignment(.trailing)
            } else {
                Text("\(remoteCommunity.value.state)")
            }
        }
    }
    
    private func latitudeRow() -> some View {
        HStack {
            Text("Latitude").font(Font.body.bold())
            Spacer()
            if isEditing {
                TextField("Latitude", text: Binding(
                    get: { String(remoteCommunity.value.latitude) },
                    set: { remoteCommunity.value.latitude = Double($0) ?? 0 })
                )
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
            } else {
                Text("\(remoteCommunity.value.latitude)")
            }
        }
    }
    
    private func longitudeRow() -> some View {
        HStack {
            Text("Longitude").font(Font.body.bold())
            Spacer()
            if isEditing {
                TextField("item count", text: Binding(
                    get: { String(remoteCommunity.value.longitude) },
                    set: { remoteCommunity.value.longitude = Double($0) ?? 0 })
                )
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
            } else {
                Text("\(remoteCommunity.value.longitude)")
                
            }
        }
    }
    
    //    var name: String = ""
    //    var traditionalName: String?
    //    var state: String = ""
    //    var latitude: Double = 0.00
    //    var longitude: Double = 0.00
    //    var latitudinalMeters: Double = 0.00
    //    var longitudinalMeters: Double = 0.00
    //    var mapDataFileName: String = ""
    //    var imageFileName: String = ""
    //    var published: Bool = false
    //
    
    
}


#Preview {
    NavigationView {
        CloudRemoteCommunityDetailView(remoteCommunity:
                SODA.Item(
                    id: "0D856B76EC144C23AF116CD8DDE4B0BF",
                    etag: "711CBA3C074C421F99DA102F7C6EE74A",
                    lastModified: "2020-08-26T13:13:14.419586000Z",
                    created: "2020-08-26T09:20:27.891977000Z",
                    value: CloudModelRemoteCommunity(name: "Santa Teresa",
                                                     traditionalName: "Ltyentye Apurte",
                                                     state: "Northern Territory",
                                                     latitude: -24.13163822827027,
                                                     longitude: 134.37364305192244,
                                                     latitudinalMeters: 1000,
                                                     longitudinalMeters: 1000,
                                                     mapDataFileName: "Lot Data - Santa Teresa - NT.geojson",
                                                     imageFileName: "Profile Photo - Santa Teresa - NT",
                                                     published: true)
                    //lotData: [CloudLotInformation(name:"Santa Teresa", details: "Clinic", latitude: 200, longitude: -30 )])
                )
        )
    }
    .environment(\.editMode, Binding.constant(.active))
    .environmentObject(CloudDataStoreRemoteCommunity())
    
}
