import XCTest
@testable import wordle_dupe

final class WordleGameTests: XCTestCase {

    var game: WordleGame!

    override func setUpWithError() throws {
        // Initialize a new game instance before each test
        game = WordleGame()
        game.targetWord = "apple" // Set a fixed target word for testing
    }

    override func tearDownWithError() throws {
        // Deinitialize after each test
        game = nil
    }

    func testSubmitGuessCorrectWord() throws {
        // Simulate entering the correct guess
        game.guesses[0] = ["A", "P", "P", "L", "E"]
        game.submitGuess()

        // Assert the game ends successfully
        XCTAssertTrue(game.gameOver, "Game should end after guessing the correct word")
        XCTAssertEqual(game.message, "🎉 You guessed the word! It's APPLE.")
        XCTAssertEqual(game.colors[0], [.green, .green, .green, .green, .green], "All colors should be green for a correct guess")
    }

    func testSubmitGuessIncorrectWord() throws {
        // Simulate entering an incorrect guess
        game.guesses[0] = ["W", "A", "T", "E", "R"]
        game.submitGuess()

        // Assert the game continues
        XCTAssertFalse(game.gameOver, "Game should not end after an incorrect guess")
        XCTAssertNotEqual(game.colors[0], [.green, .green, .green, .green, .green], "Colors should not be all green for an incorrect guess")
    }
    
    func testResetGame() throws {
        // Simulate a finished game
        game.guesses[0] = ["A", "P", "P", "L", "E"]
        game.submitGuess()
        XCTAssertTrue(game.gameOver, "Game should end after correct guess")

        // Reset the game
        game.resetGame()

        // Assert the game state is reset
        XCTAssertFalse(game.gameOver, "Game should not be over after reset")
        XCTAssertEqual(game.guesses, Array(repeating: Array(repeating: "", count: 5), count: 6), "Guesses should be reset")
        XCTAssertEqual(game.colors, Array(repeating: Array(repeating: .gray, count: 5), count: 6), "Colors should be reset")
    }
    
    func testFetchNewWord() async throws {
        // Simulate fetching a new word
        game.fetchNewWord()
        // Wait briefly to allow async task to complete
        await Task.sleep(1_000_000_000)

        // Assert a new target word is fetched
        XCTAssertNotNil(game.targetWord, "Target word should not be nil after fetching")
        XCTAssertFalse(game.targetWord.isEmpty, "Target word should not be empty")
    }
    
    func testSubmitIncompleteGuess() throws {
        // Simulate entering an incomplete guess
        game.guesses[0] = ["A", "P", "P", ""]
        game.submitGuess()

        // Assert the game state does not change
        XCTAssertFalse(game.gameOver, "Game should not end after incomplete guess")
        XCTAssertEqual(game.message, "Not enough letters", "Message should indicate incomplete guess")
    }
    
    func testSubmitGuessWithRepeatedLetters() throws {
        game.targetWord = "apple"
        game.guesses[0] = ["A", "P", "P", "P", "P"]
        game.submitGuess()

        XCTAssertEqual(game.colors[0], [.green, .green, .green, .gray, .gray], "Colors should account for repeated letters correctly")
    }
}


