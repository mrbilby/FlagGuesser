//
//  ContentView.swift
//  FlagGuesser
//
//  Created by James Bailey on 19/03/2023.
//

import SwiftUI

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func flagView() -> some View {
        modifier(Title())
    }
}

struct Title2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.white)
    }
}

extension View {
    func titleView() -> some View {
        modifier(Title2())
    }
}


struct ContentView: View {
    
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    @State private var scoreTotal = 0
    @State private var gamePlayed = 0
    @State private var countries = ["estonia", "france", "germany", "ireland", "italy", "nigeria", "poland", "russia", "spain", "uk", "us"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var animationAmount = 0.0
    @State private var fadeAmount = 1.0
    @State private var enabled = false
    @State private var flagChoice = 1


    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .titleView()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of").font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer].capitalizingFirstLetter()).font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagChoice = number
                            flagTapped(number)
                            enabled.toggle()
                            withAnimation {
                                animationAmount += 360
                                fadeAmount -= 0.5
                            }

                        } label: {
                            if number == flagChoice {
                                Image(countries[number])
                                    .renderingMode(.original).shadow(radius: 5)
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                                

                            } else {
                                Image(countries[number])
                                    .renderingMode(.original).shadow(radius: 5)
                                    .opacity(fadeAmount)
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 1, y: 0, z: 1))
                                    .animation(.default, value: enabled)
                            }
                        }


//.animation(.default, value: enabled)

       


                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(scoreTotal)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Games played: \(gamePlayed)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if gameOver {
                Button("Restart", action: resetGame)
            } else {
                Button("Continue", action: askQuestion)
            }
        } message: {
            if gameOver {
                Text("Game Over score is \(scoreTotal) out of 8")
            } else {
                Text("Your score is \(scoreTotal)")
            }
        }

    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreTotal = scoreTotal + 1
            gamePlayed = gamePlayed + 1
            if gamePlayed == 8 {
                gameOver = true
            }
        } else {
            scoreTitle = "Wrong, that is \(countries[number].capitalizingFirstLetter())"
            gamePlayed = gamePlayed + 1
            if gamePlayed == 8 {
                gameOver = true
            }

        }

        showingScore = true
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagChoice = 3
        fadeAmount = 1
    }
    func resetGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        scoreTotal = 0
        gamePlayed = 0
        showingScore = false
        gameOver = false
        flagChoice = 3
        fadeAmount = 1
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
