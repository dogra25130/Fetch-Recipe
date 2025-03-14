//
//  RecipeService.swift
//  Fetch-Recipe
//
//  Created by Abhishek Dogra on 12/03/25.
//
import SwiftUI

protocol RecipeUseCase: Sendable {
    func fetchRecipes() async throws -> [RecipeModel]
}

enum MockRecipeServiceState {
    case success
    case error
    case empty
}

final class MockRecipeService: RecipeUseCase {
    
    let state: MockRecipeServiceState
    
    init(state: MockRecipeServiceState = .success) {
        self.state = state
    }
    
    func fetchRecipes() async throws -> [RecipeModel] {
        try await Task.sleep(for: .seconds(0.5))
        switch state {
        case .success:
            return RecipeModel.mockArray()
        case .error:
            throw HTTPError.unknownError
        case .empty:
            return []
        }
    }
}

final class RecipeService: RecipeUseCase {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchRecipes() async throws -> [RecipeModel] {
        let result: RecipeResponse = try await networkManager.makeAPICall(urlString: .allRecipes, method: .GET)
        return result.recipes ?? []
        
    }
}
