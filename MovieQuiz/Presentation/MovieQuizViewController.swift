import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var questionCounterLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var questionTextLabel: UILabel!
    
    private var currentQuestionNumber: Int = 1
    private var correctAnswers: Int = .zero
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - Actions
    
    @IBAction private func onTapYesButton(_ sender: UIButton) {
        handleAnswer(answer: true)
    }
    
    @IBAction private func onTapNoButton(_ sender: UIButton) {
        handleAnswer(answer: false)
    }
    
    // MARK: - Private functions
    
    private func convert(model: QuizQuestion?) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model?.image ?? "") ?? UIImage(),
                                 question: model?.text ?? "",
                                 questionNumber: "\(currentQuestionNumber)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel?) {
        questionCounterLabel.text = step?.questionNumber
        questionTextLabel.text = step?.question
        posterImageView.layer.borderWidth = 0
        posterImageView.image = step?.image
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        posterImageView.layer.borderWidth = 8
        posterImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    private func handleAnswer(answer: Bool) {
        let isCorrect = answer == currentQuestion?.correctAnswer
        
        correctAnswers += isCorrect ? 1 : 0
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let completion = { [weak self] in
            guard let self = self else { return }
            self.correctAnswers = 0
            self.currentQuestionNumber = 1
            questionFactory.requestNextQuestion()
        }
        let alertPresenter = AlertPresenter()
        alertPresenter.controller = self
        
        alertPresenter.showAlert(alertData: AlertModel(title: result.title,
                                                       message: result.text,
                                                       buttonText: result.buttonText,
                                                       completion: completion))
    }
    
    private func showNextQuestionOrResults() {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        if currentQuestionNumber == questionsAmount {
            statisticService.store(GameResult(correct: correctAnswers,
                                              total: questionsAmount,
                                              date: Date.now))
            let textResult = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            + "\nКоличество сыграных квизов: \(statisticService.gamesCount)"
            + "\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"
            + " (\(formatter.string(from: statisticService.bestGame.date)))"
            + "\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            show(quiz: QuizResultsViewModel(title: "Раунд окончен!",
                                            text: textResult,
                                            buttonText: "Сыграть еще раз"))
        } else {
            currentQuestionNumber += 1
            questionFactory.requestNextQuestion()
            show(quiz: convert(model: currentQuestion))
        }
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
