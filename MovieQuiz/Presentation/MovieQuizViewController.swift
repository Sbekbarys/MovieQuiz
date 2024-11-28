import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IB Outlets

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    // MARK: - Private Properties
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0

    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestion(at: currentQuestionIndex)
    }
    
    // MARK: - IB Actions

    @IBAction private func answerButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false

        let givenAnswer = sender == yesButton
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)

        if isCorrect {
            correctAnswers += 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()

            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    // MARK: - Private Methods

    private func loadQuestion(at index: Int) {
        guard index < questions.count else { return }
        let question = questions[index]
        let viewModel = convert(model: question)
        show(quiz: viewModel)
    }

    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let resultText = "Ваш результат: \(correctAnswers)/\(questions.count)"
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: resultText,
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: resultViewModel)
        } else {
            currentQuestionIndex += 1
            loadQuestion(at: currentQuestionIndex)
        }
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.loadQuestion(at: self.currentQuestionIndex)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods (Helper)

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
}

// MARK: - Struct

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
