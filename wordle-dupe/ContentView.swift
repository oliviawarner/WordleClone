import SwiftUI

struct ContentView: View {
    @StateObject private var game = WordleGame()

    var body: some View {
        VStack {
            Spacer()
            GameGridView(game: game)
            Spacer()
            KeyboardView(game: game)
                .padding(.horizontal)
        }
        .onAppear {
            game.fetchNewWord()
        }
        .alert(isPresented: .constant(game.gameOver)) {
            Alert(title: Text(game.message),
                  dismissButton: .default(Text("Play Again"), action: {
                      game.resetGame()
                  }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
