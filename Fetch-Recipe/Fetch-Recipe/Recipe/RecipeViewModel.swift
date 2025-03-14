//
//  RecipeViewModel.swift
//  Fetch-Recipe
//
//  Created by Abhishek Dogra on 13/03/25.
//

import Foundation

enum RecipeViewStates: Equatable {
    case loading
    case error
    case loaded
}

@Observable
@MainActor
class RecipeViewModel {
    var data: [RecipeModel] {
        if currentState == .loading {
            RecipeModel.mockArray()
        } else {
            dataSource
        }
    }
    
    private var dataSource = [RecipeModel]()
    let usecase: RecipeUseCase
    
    var currentState: RecipeViewStates = .loading
    
    init(usecase: RecipeUseCase = RecipeService()) {
        self.usecase = usecase
    }
    
    
    func fetchData() async {
        currentState = .loading
        do {
            dataSource = try await usecase.fetchRecipes()
            currentState = .loaded
        } catch {
            currentState = .error
        }
    }
    
    func shouldShowEmptyState() -> Bool {
        currentState == .error || (currentState == .loaded && data.isEmpty)
    }
}
