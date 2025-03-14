//
//  RecipeModel.swift
//  Fetch-Recipe
//
//  Created by Abhishek Dogra on 12/03/25.
//
import Foundation

struct RecipeResponse : Codable {
    let recipes : [RecipeModel]?
    enum CodingKeys: String, CodingKey {
        case recipes = "recipes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recipes = try values.decodeIfPresent([RecipeModel].self, forKey: .recipes)
    }
}

struct RecipeModel : Codable, Hashable {
    let cuisine: String
    let name: String
    let photo: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case cuisine = "cuisine"
        case name = "name"
        case photo = "photo_url_small"
        case id = "uuid"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cuisine = try values.decode(String.self, forKey: .cuisine)
        name = try values.decode(String.self, forKey: .name)
        photo = try values.decode(String.self, forKey: .photo)
        id = try values.decode(String.self, forKey: .id)
    }
    
    init(name: String, cuisine: String, photo: String, id: String) {
        self.name = name
        self.cuisine = cuisine
        self.photo = photo
        self.id = id
    }
    
    static func mockArray() -> [RecipeModel] {
        return [
            RecipeModel(name: "Margherita Pizza Margherita Pizza Margherita Pizza", cuisine: "Italian", photo: "https://placehold.co/150", id: "1"),
            RecipeModel(name: "Margherita Pizza", cuisine: "Italian", photo: "https://placehold.co/150", id: "2"),
            RecipeModel(name: "Tacos", cuisine: "Mexican", photo: "https://placehold.co/150", id: "3"),
            RecipeModel(name: "Butter Chicken", cuisine: "Indian", photo: "https://placehold.co/150", id: "4"),
            RecipeModel(name: "Paella", cuisine: "Spanish", photo: "https://placehold.co/150", id: "5"),
            RecipeModel(name: "Beef Stroganoff", cuisine: "Russian", photo: "https://placehold.co/150", id: "6"),
            RecipeModel(name: "Pho", cuisine: "Vietnamese", photo: "https://placehold.co/150", id: "7"),
            RecipeModel(name: "Shakshuka", cuisine: "Middle Eastern", photo: "https://placehold.co/150", id: "8"),
            RecipeModel(name: "Bulgogi", cuisine: "Korean", photo: "https://placehold.co/150", id: "9"),
            RecipeModel(name: "Peking Duck", cuisine: "Chinese", photo: "https://placehold.co/150", id: "10"),
            RecipeModel(name: "Moussaka", cuisine: "Greek", photo: "https://placehold.co/150", id: "11"),
            RecipeModel(name: "Pad Thai", cuisine: "Thai", photo: "https://placehold.co/150", id: "12"),
            RecipeModel(name: "Goulash", cuisine: "Hungarian", photo: "https://placehold.co/150", id: "13"),
            RecipeModel(name: "Shepherd's Pie", cuisine: "British", photo: "https://placehold.co/150", id: "14"),
            RecipeModel(name: "Jollof Rice", cuisine: "West African", photo: "https://placehold.co/150", id: "15"),
            RecipeModel(name: "Bibimbap", cuisine: "Korean", photo: "https://placehold.co/150", id: "16"),
            RecipeModel(name: "Biryani", cuisine: "Indian", photo: "https://placehold.co/150", id: "17"),
            RecipeModel(name: "Ceviche", cuisine: "Peruvian", photo: "https://placehold.co/150", id: "18"),
            RecipeModel(name: "Coq au Vin", cuisine: "French", photo: "https://placehold.co/150", id: "19"),
            RecipeModel(name: "Chiles Rellenos", cuisine: "Mexican", photo: "https://placehold.co/150", id: "20")
        ]
    }
}
