//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 08.01.2025.
//

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
}
