//
//  Remote_Community_MapsApp.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 23/2/2024.
//


//import SwiftfulFirebaseAuth
import Firebase
import FirebaseCore
import GoogleSignIn
import SwiftData
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
//    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
//      return true
//    }
      
    let providerFactory = AppCheckDebugProviderFactory()
    AppCheck.setAppCheckProviderFactory(providerFactory)
      
    FirebaseApp.configure()
  
    return true
  }
    
    func application(_ app: UIApplication,
                 open url: URL,
                 options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct Remote_Community_MapsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @ObservedObject var router = Router()
    @StateObject var authService = AuthenticationManager()
    @StateObject var firestoreManager = FirestoreManager()
    //@StateObject var locationDataManager: LocationDataManager
    
    @StateObject var locationManager: LocationManager
    
    let container: ModelContainer

    
    var body: some Scene {
        WindowGroup {
            //ViewCoordinatorView()
            //CommunityMapsHomeScreenView()
            ContentView()
            //MapTestView()
            // SearchableTestView()
        }
        .environmentObject(authService)
        .environmentObject(firestoreManager)
        .environmentObject(router)
        .environmentObject(locationManager)
        .modelContainer(container)
    }
    
    init() {
        
        // Set up Location Manager
        Swift.print ("Remote Community Maps : init ()")
        print (URL.applicationSupportDirectory.path(percentEncoded: false))
        

        let locationManager = LocationManager()
        _locationManager = StateObject(wrappedValue: locationManager)
        
        
//        let locationDataManager = LocationDataManager()
//        _locationDataManager = StateObject(wrappedValue: locationDataManager)
        
        // Setup SwiftData
        let schema = Schema([RemoteCommunity.self])
        let config = ModelConfiguration("MyRemoteCommunities", schema: schema)
        
        do {
            container = try ModelContainer (for: schema, configurations: config)
            
            // Check to see if we're already loaded
            let descriptor = FetchDescriptor<RemoteCommunity>()

            let existingRemoteCommunities = try container.mainContext.fetchCount(descriptor)
            guard existingRemoteCommunities == 0 else {
                print ("Database already pre-seeded : Records Found = " + String(existingRemoteCommunities))
                return
            }
            
//            // Load and decode the JSON.
//            guard let url = Bundle.main.url(forResource: "Remote-Community-Map-Data", withExtension: "json") else {
//                fatalError("Failed to find Remote-Community-Map-Data.json")
//            }

            // let data = try Data(contentsOf: url)
            //let loadedRemoteCommunities = try JSONDecoder().decode([RemoteCommunity].self, from: data)

            let loadedRemoteCommunities = Bundle.main.decode([RemoteCommunity].self, from: "Remote-Community-Map-Data.json")
                        
            // Add all our data to the context.
            for remoteCommunity in loadedRemoteCommunities {
                print ("Loading: " + String(remoteCommunity.name))
                container.mainContext.insert(remoteCommunity)
                
                print ("Searching for Map File" + String(remoteCommunity.mapDataFileName))
                
                Bundle.main.decodeGeoJSON( context: container.mainContext, community: remoteCommunity, from: remoteCommunity.mapDataFileName)
            }
            
        } catch {
            //print (error.localizedDescription)
            fatalError(error.localizedDescription)
            //fatalError("Failed to configure the SwiftData container")
            //print (error.localizedDescription)
            
        }
    }
}
     
extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
