import SwiftUI

struct LetterView: View {
    var letter: String
    var color: Color

    var body: some View {
        Text(letter)
            .font(.title)
            .fontWeight(.bold)
            .frame(width: 50, height: 50)
            .background(color)
            .cornerRadius(5)
            .foregroundColor(.white)
    }
}
struct GameGridView: View {
    @ObservedObject var game: WordleGame

    var body: some View {
        VStack(spacing: 5) {
            ForEach(0..<6) { row in
                HStack(spacing: 5) {
                    ForEach(0..<5) { column in
                        LetterView(letter: game.guesses[row][column],
                                   color: game.colors[row][column])
                    }
                }
            }
        }
    }
}
