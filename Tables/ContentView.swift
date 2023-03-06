//
//  ContentView.swift
//  Tables
//
//  Created by Prakhar Trivedi on 5/3/23.
//

import SwiftUI

enum QuestionNumberVariant: Int {
    case five = 5, ten = 10, twenty = 20
}

enum CurrentScreen {
    case settings, game
}

struct UserAttempt {
    let id = UUID()
    
    var correct: Bool
    var question: String
    var correctAnswer: Int
    var userAnswer: Int
    
    var correctMultiplicationString: String {
        "\(question) = \(correctAnswer)"
    }
    
    var userMultiplicationString: String {
        "\(question) = \(userAnswer)"
    }
}

struct ContentView: View {
    // Root View Properties
    @State var currentScreen: CurrentScreen = .settings
    
    // Settings screen properties
    @State var tablesOf: Int = 2
    @State var numQuestions: Int = QuestionNumberVariant.five.rawValue
    
    let questionNumberVariants: [QuestionNumberVariant] = [.five, .ten, .twenty]
    
    // Game screen properties
    @State var currentMultiplier: Int = 1
    @State var multiplicationValue: String = ""
    @State var userAttemptsStack: [UserAttempt] = []
    
    var body: some View {
        switch currentScreen {
        case .settings:
            NavigationView {
                Form {
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tables of")
                            Stepper("\(tablesOf)", value: $tablesOf, in: 2...12)
                        }
                    }
                    
                    Section {
                        Picker("Number of questions", selection: $numQuestions) {
                            ForEach(questionNumberVariants, id: \.self.rawValue) {
                                Text("\($0.rawValue)")
                            }
                        }
                    }
                    
                    Button {
                        currentMultiplier = 1
                        
                        currentScreen = .game
                    } label: {
                        Text("Play!")
                            .font(.title3.weight(.bold))
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                }
                .navigationTitle("Tables: Game Settings")
            }
        case .game:
            NavigationView {
                Form {
                    Section {
                        HStack {
                            Text("\(tablesOf) x \(currentMultiplier) = ")
                                .font(.headline)
                            
                            TextField("\(tablesOf) x \(currentMultiplier) = ", text: $multiplicationValue, prompt: Text("Enter answer here"))
                                .labelsHidden()
                                .keyboardType(.numberPad)
                        }
                        .onSubmit {
                            let attempt = UserAttempt(correct: Int(multiplicationValue) == (tablesOf * currentMultiplier), question: "\(tablesOf) x \(currentMultiplier)", correctAnswer: (tablesOf * currentMultiplier), userAnswer: Int(multiplicationValue) ?? 0)
                            
                            withAnimation {
                                userAttemptsStack.insert(attempt, at: 0)
                                currentMultiplier += 1
                                multiplicationValue = ""
                            }
                        }
                    }
                    
                    Section {
                        ForEach(userAttemptsStack, id: \.id) { attempt in
                            HStack {
                                Image(systemName: "\(attempt.correct ? "checkmark": "x").circle.fill")
                                    .foregroundColor(attempt.correct ? .green: .red)
                                Text("\(attempt.userMultiplicationString)")
                                
                                if !attempt.correct {
                                    Spacer()
                                    Text("Ans: \(attempt.correctAnswer)")
                                }
                            }
                        }
                    } header: {
                        Text(userAttemptsStack.count == 0 ? "": "Previous Sums")
                    }
                }
                .navigationTitle("Tables of \(tablesOf)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
