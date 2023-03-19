//
//  OpenAI.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/19/23.
//

import Foundation
import OpenAISwift
class OpenAIService{
    
    
    var apiKey: String {
        ProcessInfo.processInfo.environment["OPENAI_API_KEY"]!
    }

    var organization: String {
        ProcessInfo.processInfo.environment["OPENAI_ORGANIZATION"]!
    }
    
    
    var client: OpenAISwift!
    
    init() {
        self.client = OpenAISwift(authToken: apiKey)
    }
    
    func generatePromptForRoutine () -> String {
        
        let InventoryProducts = InventoryService().list()
        let productNames = InventoryProducts.map { $0.name }
        let joinedNames = productNames.joined(separator: ", ")
        
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(InventoryProducts)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return "Please provide me a skincare routine only using the following products: \(joinedNames). Product information: \(jsonString) . Provide the routine in step by step format. Include Morning Routine and Night Routine. Also include how many times a day to apply the items, etc."
           
        } catch {
            print("Error encoding InventoryProducts to JSON: \(error.localizedDescription)")
        }


        return ""
        
    }
    
    
}
