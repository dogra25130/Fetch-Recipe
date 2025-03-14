//
//  Fetch_RecipeTests.swift
//  Fetch-RecipeTests
//
//  Created by Abhishek Dogra on 12/03/25.
//

import Testing
import SwiftUI
@testable import Fetch_Recipe

@MainActor
struct Fetch_RecipeTests {
    
    @Test func testRecipeViewModel_initialState_isLoading() {
        let mockService = MockRecipeService()
        
        let viewModel = RecipeViewModel(usecase: mockService)
        
        #expect(viewModel.currentState == .loading)
        #expect(viewModel.data.count > 0)
    }
    
    @Test func testRecipeViewModel_fetchData_success() async {
        let mockService = MockRecipeService()
        let viewModel = RecipeViewModel(usecase: mockService)
        
        await viewModel.fetchData()
        
        #expect(viewModel.currentState == .loaded)
        #expect(viewModel.data.count == RecipeModel.mockArray().count)
    }
    
    @Test func testRecipeViewModel_shouldShowEmptyStateForSuccess() async {
        
        let mockService = MockRecipeService(state: .success)
        let viewModel = RecipeViewModel(usecase: mockService)
        
        await viewModel.fetchData()
        
        #expect(viewModel.currentState == .loaded)
        #expect(!viewModel.shouldShowEmptyState())
        #expect(viewModel.data.count == RecipeModel.mockArray().count)
    }
    
    @Test func testRecipeViewModel_shouldShowEmptyStateForError() async {
        
        let mockService = MockRecipeService(state: .error)
        let viewModel = RecipeViewModel(usecase: mockService)
        
        await viewModel.fetchData()
        
        #expect(viewModel.currentState == .error)
        #expect(viewModel.shouldShowEmptyState())
        #expect(viewModel.data.count == .zero)
    }
    
    @Test func testRecipeViewModel_shouldShowEmptyStateForEmptyResults() async {
        
        let mockService = MockRecipeService(state: .empty)
        let viewModel = RecipeViewModel(usecase: mockService)
        
        await viewModel.fetchData()
        
        #expect(viewModel.currentState == .loaded)
        #expect(viewModel.shouldShowEmptyState())
        #expect(viewModel.data.count == .zero)
    }
}
