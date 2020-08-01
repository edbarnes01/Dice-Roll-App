//
//  ContentView.swift
//  DiceRollApp
//
//  Created by Ed Barnes on 23/05/2020.
//  Copyright © 2020 Ed Barnes. All rights reserved.
//

import SwiftUI

struct die: Identifiable, Hashable {
    var id: Int
    var value: Int
}

struct diceRollView: View {
    @ObservedObject var diceSelector: diceSideSelector
    
    var body: some View {
        HStack {
            if self.diceSelector.twoDice {
                if self.diceSelector.isDark {
                    Image("inverted-dice-" + String(self.diceSelector.dice[0].value)).resizable()
                    .frame(width: 150.0, height: 150.0).padding()
                    Image("inverted-dice-" + String(self.diceSelector.dice[1].value)).resizable()
                    .frame(width: 150.0, height: 150.0).padding()
                } else {
                    Image("dice-six-faces-" + String(self.diceSelector.dice[0].value)).resizable()
                    .frame(width: 150.0, height: 150.0).padding()
                    Image("dice-six-faces-" + String(self.diceSelector.dice[1].value)).resizable()
                        .frame(width: 150.0, height: 150.0).padding()
                }
            } else {
                VStack{
                    if self.diceSelector.isDark {
                        Image("inverted-dice-" + String(self.diceSelector.dice[0].value)).resizable()
                        .frame(width: 200.0, height: 200.0).padding()
                    } else {
                        Image("dice-six-faces-" + String(self.diceSelector.dice[0].value)).resizable()
                        .frame(width: 200.0, height: 200.0).padding()
                    }
                }
            }
        }
    }
}

class diceSideSelector: ObservableObject {
    @Published var diceSide: Int = 0
    @Published var isDark: Bool = false
    @Published var twoDice: Bool = false
    @Published var dice = [die(id: 0, value: 0), die(id: 1, value: 0)]
    
    func roll() {
        for (n, _) in self.dice.enumerated() {
            let x = getDiceValue()
            self.dice[n].value = x
        }
    }
    
    func getDiceValue() -> Int {
        let diceSide = Int.random(in: 1..<7)
        return diceSide
    }
    
    func addDie() {
        let value = Int.random(in: 1..<7)
        let numberOfDice = self.dice.count
        dice.append(die(id: numberOfDice, value: value))
    }
    
    func removeDie(index: Int) {
        dice.remove(at: index)
    }
    
}

struct optionsView: View {
    @ObservedObject var diceSelector: diceSideSelector
    @State var expand = false
    
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "gear").font(.largeTitle)
                
                if expand {
                    Image(systemName: "chevron.up").font(.largeTitle)
                } else {
                    Image(systemName: "chevron.down").font(.largeTitle)
                }
                
            }
            .onTapGesture {
                self.expand.toggle()
            }
            
            if expand {
                
                HStack{
                    Spacer()
                    Text("Dark Dice")
                    Toggle("", isOn: self.$diceSelector.isDark).labelsHidden()
                        .padding(.trailing, 20)
                    Spacer()
                }.padding(.top, 20)
                
                HStack{
                    Spacer()
                    Text("Two Dice")
                    Toggle("", isOn: self.$diceSelector.twoDice).labelsHidden()
                        .padding(.trailing, 20)
                    Spacer()
                }
            }
        }
        .padding(.top, 30)
        .animation(.easeInOut)
    }
    
}

struct ContentView: View {
    @EnvironmentObject var diceSelector: diceSideSelector
    
    var body: some View {
        VStack {
            
            optionsView(diceSelector: diceSelector)
            Spacer()
    
            diceRollView(diceSelector: diceSelector)
            Spacer()
            
            Button(action: {
                self.diceSelector.roll()
            }) {
                Text("Roll")
                    .font(.largeTitle)
                    .padding(10.0)
                    .padding(.horizontal , 15.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .shadow(color: .blue, radius: 10.0)
                    )
            }
            Spacer()
            Text("© Ed Barnes")
                .frame(width: 250.0, height: 20.0)
                .padding(5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(diceSideSelector())
    }
}
