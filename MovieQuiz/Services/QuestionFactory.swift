//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 07.01.2025.
//
import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", correctAnswer: true),
        QuizQuestion(image: "The Avengers", correctAnswer: true),
        QuizQuestion(image: "Deadpool", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", correctAnswer: true),
        QuizQuestion(image: "Old", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", correctAnswer: false),
        QuizQuestion(image: "Tesla", correctAnswer: false),
        QuizQuestion(image: "Vivarium", correctAnswer: false)
    ]
    weak var delegate: QuestionFactoryDelegate?
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        delegate?.didReceiveNextQuestion(question: questions[index])
    }
    
    
}
