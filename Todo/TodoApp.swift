//
//  TodoApp.swift
//  Todo
//
//  Created by Tran Tran on 2/21/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins
import GoogleMaps
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("AIzaSyARbyDDNNrxbTYFfmYYX91wWgZGki4rIl8")
        GMSPlacesClient.provideAPIKey("AIzaSyARbyDDNNrxbTYFfmYYX91wWgZGki4rIl8")
        return true
    }
}

func configureAmplify() {
    let models = AmplifyModels()
    let apiPlugin = AWSAPIPlugin(modelRegistration: models)
    let dataStorePlugin = AWSDataStorePlugin(modelRegistration: models)
    do {
        try Amplify.add(plugin: apiPlugin)
        try Amplify.add(plugin: dataStorePlugin)
        try Amplify.configure()
        print("Initialized Amplify");
    } catch {
        print("Could not initialize Amplify: \(error)")
    }
}

@main
struct TodoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    public init() {
        configureAmplify()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
