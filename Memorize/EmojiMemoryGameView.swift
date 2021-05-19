//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Katerina Utlik on 2/7/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        NavigationView {
            VStack {
                Grid(viewModel.cards) { card in
                    CardView(card: card,
                        gradient: Gradient(colors: [viewModel.theme.color, viewModel.theme.accentColor ?? viewModel.theme.color]))
                        .onTapGesture {
                            withAnimation(.linear(duration: animationDuration)) {
                                viewModel.choose(card: card)
                            }
                        }
                    .padding(cardPadding)
                }
                .padding()
                .foregroundColor(viewModel.theme.color)
                
                Text("Score: \(viewModel.score)")
            }
            .navigationBarTitle("Theme: \(viewModel.theme.name)")
            .navigationBarItems(trailing: Button("New Game", action: {
                withAnimation(.easeInOut) {
                    viewModel.startNewGame()
                }
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Drawing Constants
    private let animationDuration = 0.75
    private let cardPadding: CGFloat = 5
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var gradient: Gradient
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: pieStartAngle, endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                self.startBonusAnimation()
                            }
                    } else {
                        Pie(startAngle: pieStartAngle, endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(piePadding)
                .opacity(pieOpacity)
                .transition(.scale)
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(card.isMatched ? rotationDegrees : zeroDegrees)
                    .animation(card.isMatched ? Animation.linear(duration: rotationAnimationDuration).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp, gradient: gradient)
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Constants
    private let fontScaleFactor: CGFloat = 0.7
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
    private let pieStartAngle = Angle.degrees(0-90)
    private let pieEndAngle = Angle.degrees(110-90)
    private let piePadding: CGFloat = 5
    private let pieOpacity = 0.4
    private let rotationDegrees = Angle.degrees(360)
    private let zeroDegrees = Angle.degrees(0)
    private let rotationAnimationDuration = 1.0
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}


