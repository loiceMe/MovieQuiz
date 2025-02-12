//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 12.02.2025.
//
import Foundation

final class MovieQuizPresenter: MovieQuizPresenterProtocol {
    private let statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionNumber: Int = .zero
    private var correctAnswers: Int = .zero
    
    private let formatter = DateFormatter()
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController

        questionFactory.delegate = self
        questionFactory.loadData()
        viewController.showLoadingIndicator()
    }
    
    func handleAnswer(answer: Bool) {
        let isCorrect = answer == currentQuestion?.correctAnswer
        
        correctAnswers += isCorrect ? 1 : 0
        viewController?.blockUI()
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.viewController?.unblockUI()
            self.showNextQuestionOrResults()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: model.image,
                                 question: model.text,
                                 questionNumber: "\(currentQuestionNumber)/\(questionsAmount)")
    }
    
    private func showNextQuestionOrResults() {
        currentQuestionNumber += 1
        
        if currentQuestionNumber == questionsAmount + 1 {
            statisticService.store(GameResult(correct: correctAnswers,
                                              total: questionsAmount,
                                              date: Date.now))
            let textResult = getTextResult()
            
            show(quiz: QuizResultsViewModel(title: "Раунд окончен!",
                                            text: textResult,
                                            buttonText: "Сыграть еще раз"))
        } else {
            questionFactory.requestNextQuestion()
            if let currentQuestion = self.currentQuestion {
                viewController?.show(quiz: convert(model: currentQuestion))
            }
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let completion = { [weak self] in
            guard let self = self else { return }
            correctAnswers = 0
            currentQuestionNumber = 1
            questionFactory.requestNextQuestion()
        }
        viewController?.showAlert(model: AlertModel(id: "Result alert",
                                                    title: result.title,
                                                    message: result.text,
                                                    buttonText: result.buttonText,
                                                    completion: completion))
    }
    
    private func showLoadError(error: Error) {
        let completion = { [weak self] in
            guard let self = self else { return }
            viewController?.showLoadingIndicator()
            questionFactory.loadData()
        }
        viewController?.showAlert(model: AlertModel(id: "Error alert",
                                                   title: "Ошибка",
                                                   message: error.localizedDescription,
                                                   buttonText: "Повторить?",
                                                   completion: completion))
    }
    
    private func getTextResult() -> String {
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        return ("Ваш результат: \(correctAnswers)/\(questionsAmount)"
        + "\nКоличество сыграных квизов: \(statisticService.gamesCount)"
        + "\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"
        + " (\(formatter.string(from: statisticService.bestGame.date)))"
        + "\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%")
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        showNextQuestionOrResults()
    }
    
    func didFailToLoadData(with error: any Error) {
        viewController?.hideLoadingIndicator()
        showLoadError(error: error)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
}
