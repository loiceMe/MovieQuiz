//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 21.01.2025.
//
import Foundation

final class StatisticServiceImplementation: StatisticService {
    var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    var bestGame: GameResult {
        get { GameResult(correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                         total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                         date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date.now) }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    var totalAccuracy: Double {
        get { storage.double(forKey: Keys.totalAccuracy.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalAccuracy.rawValue) }
    }
    
    private var storage = UserDefaults.standard
    
    func store(_ result: GameResult) {
        gamesCount += 1
        guard gamesCount != 0 else { return }
        
        totalAccuracy = (totalAccuracy * Double(gamesCount - 1) + result.accuracy) / Double(gamesCount)
        
        if result.betterThan(anotherResult: bestGame) {
            bestGame = result
        }
    }
    
    enum Keys: String {
        case gamesCount
        case totalAccuracy
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
}
