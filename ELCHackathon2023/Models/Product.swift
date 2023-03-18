//
//  Product.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/16/23.
//

struct Product: Codable{
    let id: Int
    let name: String
    let slug: String
    let description: String
    let skinTypes: [String]
    let skinConcern: [String]
    let category: String
    let price: Double
    let howToUse: String
    let ingredients: [String: String]
    let colors: [String]
    let images: [String]
}
