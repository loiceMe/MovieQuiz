//
//  GameResult.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 22.01.2025.
//
import Foundation

struct GameResult: Codable {
    let correct: Int
    let total: Int
    let date: Date
    var accuracy: Double {
        get {
            guard total != 0 else { return 0 }
            
            return Double(correct) / Double(total) * 100
        }
    }
    
    func betterThan(anotherResult: GameResult) -> Bool {
        return correct > anotherResult.correct
    }
}
