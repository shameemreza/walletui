//
//  Expense.swift
//  WalletUI
//
//  Created by Shameem Reza on 13/3/22.
//

import SwiftUI

// MARK: - EXPENSE MODEL

struct Expense: Identifiable {
    var id = UUID().uuidString
    var amountSpent: String
    var product: String
    var productIcon: String
    var spendType: String
}


// MARK: EXPENSE DATA

var expenses: [Expense] = [

    Expense(amountSpent: "$130", product: "Dribbble", productIcon: "icon1", spendType: "Membership"),
    Expense(amountSpent: "$111", product: "Disney", productIcon: "icon2", spendType: "Streaming"),
    Expense(amountSpent: "$130", product: "Ayana Mart", productIcon: "icon3", spendType: "Groceries"),
    Expense(amountSpent: "&230", product: "Huawei", productIcon: "icon4", spendType: "Gadets"),
    Expense(amountSpent: "$110", product: "House Remt", productIcon: "icon5", spendType: "Family"),
    Expense(amountSpent: "$12", product: "Amazon Prime", productIcon: "icon6", spendType: "Movies"),
    Expense(amountSpent: "$9", product: "Netflix", productIcon: "icon7", spendType: "Movies"),
    Expense(amountSpent: "$90", product: "HP Development", productIcon: "icon8", spendType: "Computer"),
    Expense(amountSpent: "$5", product: "Duolingo", productIcon: "icon9", spendType: "Membership"),
    Expense(amountSpent: "$69", product: "Figma", productIcon: "icon10", spendType: "Membership"),
    Expense(amountSpent: "$80", product: "Airbnb", productIcon: "icon11", spendType: "Tourism"),
    Expense(amountSpent: "$10", product: "Soudagor", productIcon: "icon12", spendType: "Foods"),
    Expense(amountSpent: "$330", product: "Apple", productIcon: "icon13", spendType: "Computer"),
    Expense(amountSpent: "$21", product: "Facebook", productIcon: "icon14", spendType: "Advertising"),
]
