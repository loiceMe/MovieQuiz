import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var questionCounterLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var questionTextLabel: UILabel!
    
    private var currentQuestionIndex: Int = .zero
    private var correctAnswers: Int = .zero
    private let questions: [QuizQuestion] = mockQuestions
    
    private var currentQuestion: QuizQuestion {
        get {
            return questions.indices.contains(currentQuestionIndex)
            ? questions[currentQuestionIndex]
            : QuizQuestion(image: "", correctAnswer: false)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        show(quiz: convert(model: currentQuestion))
    }
    
    @IBAction private func onTapYesButton(_ sender: UIButton) {
        handleAnswer(answer: true)
    }
    
    @IBAction private func onTapNoButton(_ sender: UIButton) {
        handleAnswer(answer: false)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        questionCounterLabel.text = step.questionNumber
        questionTextLabel.text = step.question
        posterImageView.layer.borderWidth = 0
        posterImageView.image = step.image
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        posterImageView.layer.borderWidth = 8
        posterImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view.isUserInteractionEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    private func handleAnswer(answer: Bool) {
        let isCorrect = answer == currentQuestion.correctAnswer
        
        correctAnswers += isCorrect ? 1 : 0
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            self.show(quiz: self.convert(model: self.currentQuestion))
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(title: "Раунд окончен!",
                                            text: "Ваш результат: \(correctAnswers)/\(questions.count)",
                                            buttonText: "Сыграть еще раз"))
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: currentQuestion))
        }
    }
}

fileprivate struct QuizQuestion {
    let image: String
    let text: String = "Рейтинг этого фильма больше чем 6?"
    let correctAnswer: Bool
}

fileprivate struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

fileprivate struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

fileprivate let mockQuestions = [
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

