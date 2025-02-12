import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private weak var questionCounterLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var questionTextLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var presenter: MovieQuizPresenterProtocol? = nil

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Actions
    
    @IBAction private func onTapYesButton(_ sender: UIButton) {
        presenter?.handleAnswer(answer: true)
    }
    
    @IBAction private func onTapNoButton(_ sender: UIButton) {
        presenter?.handleAnswer(answer: false)
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel?) {
        guard let step = step else { return }
        
        questionCounterLabel.text = step.questionNumber
        questionTextLabel.text = step.question
        posterImageView.layer.borderWidth = 0
        posterImageView.image = UIImage(data: step.image)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        posterImageView.layer.borderWidth = 8
        posterImageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func unblockUI() {
        view.isUserInteractionEnabled = true
    }
    
    func blockUI() {
        view.isUserInteractionEnabled = false
    }
    
    func showAlert(model: AlertModel) {
        let alertPresenter = AlertPresenter()
        alertPresenter.controller = self
        alertPresenter.showAlert(alertData: model)
    }
}
