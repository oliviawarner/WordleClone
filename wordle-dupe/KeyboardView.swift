import SwiftUI

struct KeyboardView: View {
    @ObservedObject var game: WordleGame

    let rows = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["Enter", "Z", "X", "C", "V", "B", "N", "M", "⌫"]
    ]

    var body: some View {
        VStack(spacing: 5) { // Slightly reduced row spacing
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 5) { // Slightly reduced key spacing
                    ForEach(row, id: \.self) { key in
                        Button(action: { game.handleKeyPress(key) }) {
                            Text(key)
                                .font(.system(size: 13)) // Slightly smaller font
                                .frame(width: keyWidth(for: key), height: 40) // Reduced height
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(5) // Balanced corner radius
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10) // Adjust padding for alignment
        .frame(height: 150) // Slightly reduced overall height
    }

    private func keyWidth(for key: String) -> CGFloat {
        key == "Enter" || key == "⌫" ? 50 : 34 // Slightly narrower keys
    }
}
