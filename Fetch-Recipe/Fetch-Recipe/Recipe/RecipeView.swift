//
//  ContentView.swift
//  Fetch-Recipe
//
//  Created by Abhishek Dogra on 12/03/25.
//


import SwiftUI

struct RecipeView: View {
    @State var viewModel: RecipeViewModel
    @State private var imageWidth: CGFloat?
    
    var body: some View {
        NavigationStack {
            GridContentView
                .shimmer(when: Binding($viewModel.currentState, is: .loading))
                .contentMargins(.bottom, .p74, for: .scrollContent)
                .scrollIndicators(.hidden)
                .ignoresSafeArea(.all, edges: [.bottom, .horizontal])
                .task { await viewModel.fetchData() }
                .navigationTitle(Constants.title)
        }
    }
    
    private var GridContentView: some View {
        ScrollView {
            if viewModel.shouldShowEmptyState() {
                EmptyContentView
            } else {
                ContentView
            }
        }
        .refreshable { await viewModel.fetchData() }
    }
    
    private var EmptyContentView: some View {
        VStack(alignment: .center) {
            Text(Constants.emptyStateTitle)
                .font(weight: .medium500, size: .size18)
                .multilineTextAlignment(.center)
                .padding(.top, .p74)
                .padding(.horizontal)
        }
    }
    
    private var ContentView: some View {
        LazyVStack(spacing: Constants.spacing) {
            ForEach(Array(viewModel.data.chunked(into: 2)), id: \.self) { row in
                HStack(alignment: .top, spacing: Constants.spacing) {
                    ForEach(row, id: \.id) { model in
                        RecipeCardView(for: model)
                            .frame(maxWidth: .infinity)
                            .background(
                                GeometryReader { proxy in
                                    if imageWidth == nil, viewModel.currentState == .loaded {
                                        Color.clear
                                            .onAppear {
                                                imageWidth = proxy.size.width
                                            }
                                    }
                                }
                            )
                    }
                    if row.count == 1 {
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func RecipeCardView(for model: RecipeModel) -> some View {
        VStack(alignment: .leading) {
            Image(for: model.photo)
                .frame(width: imageWidth ?? 180, height: imageWidth ?? 180)
            Text(model.name)
                .font(weight: .semiBold600, size: .size18)
                .padding(.horizontal)
            Text(model.cuisine)
                .font(weight: .regular400, size: .size14)
                .padding(.horizontal)
            Spacer(minLength: Constants.spacing)
        }
        .clipShape(RoundedRectangle(cornerRadius: .p16))
        .background(
            RoundedRectangle(cornerRadius: .p16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
        )
        .overlay(RoundedRectangle(cornerRadius: .p16)
            .stroke(.black.opacity(0.5), lineWidth: 0.5))
    }
    
    private func Image(for url: String) -> some View {
        AsyncCachedImage(url: url, content: { image in
            image.resizable()
        }, placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
        })
        .aspectRatio(1, contentMode: .fill)
        
    }
}

extension RecipeView {
    struct Constants {
        static let spacing: CGFloat = .p16
        static let title = "Recipes"
        static let emptyStateTitle = "No recipes found. Pull down to refresh or try again later!"
    }
}


#Preview {
    RecipeView(viewModel: RecipeViewModel(usecase: MockRecipeService()))
}
