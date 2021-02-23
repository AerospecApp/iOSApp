//
//  TodoApp.swift
//  Todo
//
//  Created by Tran Tran on 2/21/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins

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
    public init() {
        configureAmplify()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
