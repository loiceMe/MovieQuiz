//
//  QuestionFactoryDelegateProtocol.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 08.01.2025.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
