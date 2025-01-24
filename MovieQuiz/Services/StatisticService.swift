//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 21.01.2025.
//
import Foundation

protocol StatisticService {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(_ result: GameResult)
}
