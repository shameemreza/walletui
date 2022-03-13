//
//  Home.swift
//  WalletUI
//
//  Created by Shameem Reza on 13/3/22.
//

import SwiftUI

struct Home: View {
    // MARK: - CARD ANIAMTION PROPERTIES
    @State var expandCards: Bool = false
    
    // MARK: TRANSACTION LIST PROPERTIES
    @State var currentCard: Card?
    @State var showDetailTransaction: Bool = false
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Wallet UI")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: expandCards ? .leading : .center)
                .padding(.horizontal)
                .overlay(alignment: .trailing) {
                    // MARK: CLOSE BUTTON
                    Button {
                        // MARK: CLOSE ON TOUCH
                        withAnimation(
                            .interactiveSpring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.7)) {
                                expandCards = false
                            }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.pink, in: Circle())
                    }
                    .offset(x: expandCards ? 10 : 15)
                    .opacity(expandCards ? 1 : 0)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - CARD LIST
                    ForEach(cards) {card in
                        Group {
                            if currentCard?.id == card.id && showDetailTransaction {
                                CardView(card: card)
                                    .opacity(0)
                            } else {
                                CardView(card: card)
                                    .matchedGeometryEffect(id: card.id, in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                currentCard = card
                                showDetailTransaction = true
                            }
                        }
                    }
                }
                .overlay {
                    Rectangle()
                        .fill(.black.opacity(expandCards ? 0 : 0.01))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                expandCards = true
                            }
                        }
                }
                .padding(.top, expandCards ? 30 : 0)
                
            }
            .coordinateSpace(name: "SCROLL")
            .offset(y: expandCards ? 0 : 30)
            
            // MARK: ADD BUTTON
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(.green, in: Circle())
            }
            .scaleEffect(expandCards ? 0.01 : 1)
            .opacity(!expandCards ? 1 : 0)
            .frame(height: expandCards ? 0 : nil)
            .padding(.bottom, expandCards ? 0 : 30)
        }
        .padding([.horizontal, .top])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if let currentCard = currentCard, showDetailTransaction {
                TransactionView(currentCard: currentCard, showDetailTransaction: $showDetailTransaction, animation: animation)
            }
        }
    }
    
    // MARK: CARD VIEW
    @ViewBuilder
    func CardView(card: Card)->some View {
        GeometryReader {proxy in
            
            let rect = proxy.frame(in: .named("SCROLL"))
            let offset = CGFloat(getIndex(Card: card) * (expandCards ? 10 : 70))
            
            ZStack(alignment: .bottomLeading) {
                
                // MARKK - CARD BACKGROUND
                Image(card.cardImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                // MARK: - CARD DETAILS
                VStack(alignment: .leading, spacing: 10) {
                    Text(card.name)
                        .fontWeight(.bold)
                    
                    Text(hideCardNumber(number:card.cardNumber))
                        .font(.callout)
                        .fontWeight(.bold)
                }
                .padding()
                .padding(.bottom, 10)
                .foregroundColor(.white)
            }
            .offset(y: expandCards ? offset: -rect.minY + offset)
        }
        .frame(height: 200)
        .padding(.horizontal)
    }
    
    // MARK: - GET CARD INDEX NUMBER
    func getIndex(Card: Card)-> Int {
        return cards.firstIndex { currentCard in
            return currentCard.id == Card.id
        } ?? 0
    }
}

// MARK: - HIDE FIRST FEW DIGIT
func hideCardNumber(number: String)->String {
    var newValue: String = ""
    let maxCount = number.count - 4
    
    number.enumerated().forEach {value in
        if value.offset >= maxCount {
            let string = String(value.element)
            newValue.append(contentsOf: string)
            
        } else {
            // MARK: - SHOW START
            let string = String(value.element)
            if string == " " {
                newValue.append(contentsOf: " ")
            } else {
                newValue.append(contentsOf: "*")
            }
        }
    }
    return newValue
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


// MARK: DETAIL TRANSACITON VIEW

struct TransactionView: View {
    var currentCard: Card
    @Binding var showDetailTransaction: Bool
    // MARK: GEOMETRY EFFECT
    var animation: Namespace.ID
    
    // MARK: DELAY EXPENSE VIEW
    @State var showExpenseView: Bool = false
    
    var body: some View {
        VStack {
            CardView()
                .matchedGeometryEffect(id: currentCard.id, in: animation)
                .frame(height: 200)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showExpenseView = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            showDetailTransaction = false
                        }
                    }
                    
                }
                .zIndex(10)
            
            GeometryReader {proxy in
                let height = proxy.size.height + 50
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        //MARK: SHOW EXPENSES
                        ForEach(expenses) {expense in
                            ExpenseCardView(expense: expense)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .ignoresSafeArea()
                )
                .offset(y: showExpenseView ? 0 : height)
            }
            .padding([.horizontal, .top])
            .zIndex(-10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("ColorBG").ignoresSafeArea())
        .onAppear {
            withAnimation(.easeInOut.delay(0.1)) {
                showExpenseView = true
            }
        }
    }
    
    @ViewBuilder
    func CardView()->some View {
        ZStack(alignment: .bottomLeading) {
            
            // MARKK - CARD BACKGROUND
            Image(currentCard.cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            // MARK: - CARD DETAILS
            VStack(alignment: .leading, spacing: 10) {
                Text(currentCard.name)
                    .fontWeight(.bold)
                
                Text(hideCardNumber(number:currentCard.cardNumber))
                    .font(.callout)
                    .fontWeight(.bold)
            }
            .padding()
            .padding(.bottom, 10)
            .foregroundColor(.white)
    }
    }
}


// MARK: EXPENSE CARD VIEW

struct ExpenseCardView: View {
    var expense: Expense
    
    // MARK: - SHOW EXPENSE BASED ON INDEX
    @State var showView: Bool = false
    
    var body: some View {
        HStack(spacing: 14) {
            Image(expense.productIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(expense.product)
                    .fontWeight(.bold)
                
                Text(expense.spendType)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                Text(expense.amountSpent)
                    .fontWeight(.bold)
                
                Text(Date().formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .opacity(showView ? 1 : 0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.3).delay(Double(getIndex()) * 0.1)) {
                    showView = true
                }
            }
        }
        
    }
    
    func getIndex()-> Int {
        return expenses.firstIndex { currentExpense in
            return expense.id == currentExpense.id
        } ?? 0
    }
}
