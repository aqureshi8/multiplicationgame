//
//  ContentView.swift
//  Multiplication "Game"
//
//  Created by Ahsan Qureshi on 3/26/24.
//

import SwiftUI

struct ContentView: View {
    @State private var game = false;
    @State private var multiplicationTable = 3
    @State private var questionTotal = 5
    
    var body: some View {
        NavigationView {
            if game {
                GameView(multiplicationTable: self.multiplicationTable, questionTotal: self.questionTotal)
            } else {
                SettingsView(onGameStart: handleGameStart)
            }
        }
    }
                                
    func handleGameStart(_ multiplicationTable: Int, _ questionTotal: Int) {
        self.multiplicationTable = multiplicationTable
        self.questionTotal = questionTotal
        self.game = true
    }
}

struct SettingsView: View {
    @State private var multiplicationTable = 3
    @State private var questionCounts = [5, 10, 20]
    @State private var questionTotal = 5
    
    let onGameStart : (_: Int, _: Int) -> Void
    
    var body: some View {
        Form {
            Section("Choose your difficulty") {
                Picker("", selection: $multiplicationTable) {
                    ForEach(2..<13, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: .infinity, height: 100)
            }
            Section("How many questions do you want") {
                Picker("", selection: $questionTotal) {
                    ForEach(questionCounts, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.segmented)
            }
            
            HStack {
                Spacer()
                Button("GO!") {
                    onGameStart(multiplicationTable, questionTotal)
                }
                Spacer()
            }
        }.navigationTitle("Settings")
    }
}

struct GameView: View {
    let multiplicationTable: Int
    let questionTotal: Int
    
    @State private var questionCount = 1
    @State private var firstNumber = 0
    @State private var secondNumber = Int.random(in: 1...12)
    @State private var userAnswer = 0
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertShowing = false
    @State private var score = 0
    @FocusState private var answerIsFocused: Bool
    
    private var answer: Int {
        firstNumber * secondNumber
    }
    
    var body: some View {
        Form {
            HStack {
                Text("Question:").padding()
                Spacer()
                Text( "\(questionCount) / \(questionTotal)").padding()
            }
            HStack {
                Spacer()
                VStack {
                    Text("\(firstNumber) x \(secondNumber)").padding()
                    TextField("Answer", value: $userAnswer, format: .number)
                        .frame(width: 100, height: 100)
                        .background(.regularMaterial)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .focused($answerIsFocused)
                }
                Spacer()
            }
            HStack {
                Text("Score: \(score)")
                Spacer()
                Button ("DONE") {
                    checkAnswer()
                }
            }
        }.onAppear {
            firstNumber = Int.random(in: 1...multiplicationTable)
        }
        .alert(alertTitle, isPresented: $alertShowing) {
            if questionCount == questionTotal {
                Button("Play Again") {
                    restart()
                }
            } else {
                Button("Continue") {
                    nextQuestion()
                }
            }
        }
    }
    
    func checkAnswer() {
        if userAnswer == answer {
            alertTitle = "Correct!"
            score += 1
        } else {
            alertTitle = "Wrong!"
        }
        
        alertMessage = "The answer is \(answer)"
        alertShowing = true
    }
    
    func nextQuestion() {
        firstNumber = Int.random(in: 1...multiplicationTable)
        secondNumber = Int.random(in: 1...12)
        questionCount += 1
    }
    
    func restart() {
        nextQuestion()
        questionCount = 1
        score = 0
    }
}

#Preview {
    GameView(multiplicationTable: 5, questionTotal: 5)
}
