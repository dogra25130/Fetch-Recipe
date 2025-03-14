//
//  Fetch_RecipeApp.swift
//  Fetch-Recipe
//
//  Created by Abhishek Dogra on 12/03/25.
//

import SwiftUI

@main
struct Fetch_RecipeApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeView(viewModel: RecipeViewModel())
        }
    }
}
