//
//  Untitled.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 12.02.2025.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel?)
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func blockUI()
    func unblockUI()
    
    func showAlert(model: AlertModel)
}
