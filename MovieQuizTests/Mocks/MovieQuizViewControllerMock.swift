//
//  MovieQuizViewControllerMock.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 13.02.2025.
//
import Foundation
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel?) {}
    func blockUI() {}
    func unblockUI() {}
    func show(quiz result: QuizResultsViewModel) {}
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showAlert(model: AlertModel) {}
}
