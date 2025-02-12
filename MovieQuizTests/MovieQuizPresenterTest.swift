//
//  MovieQuizPresenterTest.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 12.02.2025.
//
import XCTest
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

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "0/10")
    }
}
