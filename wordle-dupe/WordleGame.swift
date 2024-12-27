import SwiftUI
import Combine

class WordleGame: ObservableObject {
    @Published var guesses: [[String]] = Array(repeating: Array(repeating: "", count: 5), count: 6)
    @Published var colors: [[Color]] = Array(repeating: Array(repeating: Color.gray, count: 5), count: 6)
    @Published var currentRow: Int = 0
    @Published var currentColumn: Int = 0
    @Published var targetWord: String = "apple"
    @Published var gameOver: Bool = false
    @Published var message: String = ""

    private var cancellables = Set<AnyCancellable>()

    func fetchNewWord() {
        let url = URL(string: "https://random-word-api.herokuapp.com/word?number=1&length=5")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [String].self, decoder: JSONDecoder())
            .replaceError(with: ["error"])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wordList in
                self?.targetWord = wordList.first ?? "apple"
            }
            .store(in: &cancellables)
    }

    func handleKeyPress(_ key: String) {
        guard !gameOver else { return }

        if key == "⌫" {
            if currentColumn > 0 {
                currentColumn -= 1
                guesses[currentRow][currentColumn] = ""
            }
        } else if key == "Enter" {
            submitGuess()
        } else {
            if currentColumn < 5 {
                guesses[currentRow][currentColumn] = key
                currentColumn += 1
            }
        }
    }

    func submitGuess() {
        // Normalize casing for both guess and targetWord
        let guess = guesses[currentRow].joined().lowercased()
        let target = targetWord.lowercased()

        print("Guess: \(guess), Target: \(target)")
        
        guard guess.count == 5 else {
            message = "Not enough letters"
            return
        }

        if guess == target {
            for i in 0..<5 {
                colors[currentRow][i] = .green
            }
            message = "🎉 You guessed the word! It's \(targetWord.uppercased())."
            gameOver = true
            return
        }

        var tempTarget = Array(target)
        var tempGuess = Array(guess)
        var resultColors: [Color] = Array(repeating: .gray, count: 5)

        // First Pass: Check for Green
        for i in 0..<5 {
            if tempGuess[i] == tempTarget[i] {
                resultColors[i] = .green
                tempTarget[i] = "#" // Mark as matched
                tempGuess[i] = "*" // Mark as processed
            }
        }

        // Second Pass: Check for Yellow
        for i in 0..<5 {
            if resultColors[i] == .gray, let index = tempTarget.firstIndex(of: tempGuess[i]) {
                resultColors[i] = .yellow
                tempTarget[index] = "#" // Mark as matched
            }
        }

        colors[currentRow] = resultColors
        print("Colors after guess: \(colors[currentRow])")

        if currentRow == 5 {
            message = "💀 Game Over! The word was \(targetWord.uppercased())."
            gameOver = true
        } else {
            currentRow += 1
            currentColumn = 0
        }
    }
    func resetGame() {
        guesses = Array(repeating: Array(repeating: "", count: 5), count: 6)
        colors = Array(repeating: Array(repeating: Color.gray, count: 5), count: 6)
        currentRow = 0
        currentColumn = 0
        gameOver = false
        message = ""
        fetchNewWord()
    }
}
