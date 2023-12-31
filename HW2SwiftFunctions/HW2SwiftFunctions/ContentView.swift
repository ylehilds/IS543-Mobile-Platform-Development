//
//  ContentView.swift
//  HW2SwiftFunctions
//
//  Created by Lehi Alcantara on 9/8/23.
//

import SwiftUI

struct ContentView: View {
    private var formatter = NumberFormatter()
    @State private var fibNumberInput = ""
    @State private var fibNumberLocation = ""
    
    @State private var factorialNumberInput = ""
    @State private var factorialNumberResult = ""
    
    @State private var number1 = ""
    @State private var number2 = ""
    @State private var sumResult = ""
    
    @State private var centsNumberInput = ""
    @State private var centsNumberResult = ""
    @State private var quarters = ""
    @State private var dimes = ""
    @State private var nickles = ""
    @State private var pennies = ""

    var body: some View {
        VStack (alignment: .leading){
            Text("Compute the ith Fibonacci number: ")
            TextField("Type in Fibonacci Number Location", text: $fibNumberInput)
                .onSubmit {
                    findIthFibonacciNumber()
                }
            TextField("Fibonacci Number Result", text: $fibNumberLocation)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            
            HStack {
                Button("Search") {
                    findIthFibonacciNumber()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .clipShape(Capsule())
                
                Button("Clear") {
                    clearFibonacciTextFields()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.red)
                .clipShape(Capsule())
            }
            .fixedSize(horizontal: true, vertical: false)
            
//            Spacer()
        }
        .padding()
        
        VStack (alignment: .leading){
            Text("Compute n! (factorial) for integer n ≥ 0: ")
            TextField("Factorial Number", text: $factorialNumberInput)
                .onSubmit {
                    calculateFactorial()
                }
            TextField("Factorial Number Result: ", text: $factorialNumberResult)
                .disabled(true)
            
            HStack {
                Button("Factorial") {
                    calculateFactorial()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .clipShape(Capsule())
                
                Button("Clear") {
                    clearFactorialTextFields()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.red)
                .clipShape(Capsule())
            }
            .fixedSize(horizontal: true, vertical: false)
            
//            Spacer()
        }
        .padding()
        
        VStack (alignment: .leading){
            Text("Sum of all integers between 2 integers: ")
            TextField("Number 1", text: $number1)
            TextField("Number 2", text: $number2)
                .onSubmit {
                    sumOfAllIntegers()
                }
            TextField("Sum Result: ", text: $sumResult)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            HStack {
                Button("Calculate Sum") {
                    sumOfAllIntegers()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .clipShape(Capsule())
                
                Button("Clear") {
                    clearSumOfAllIntegersTextFields()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.red)
                .clipShape(Capsule())
            }
            .fixedSize(horizontal: true, vertical: false)
            
//            Spacer()
        }
        .padding()
        
        VStack (alignment: .leading){
            Text("Solution that needs the fewest coins: ")
            TextField("Enter cents Number", text: $centsNumberInput)
                .onSubmit {
                    calculateCoinsNumbers()
                }
            TextField("Cents Number Result", text: $centsNumberResult)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            HStack {
                Button("Calculate") {
                    calculateCoinsNumbers()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .clipShape(Capsule())
                
                Button("Clear") {
                    clearCentsNumbersTextFields()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.red)
                .clipShape(Capsule())
            }
            .fixedSize(horizontal: true, vertical: false)
            
            Spacer()
        }
        .padding()
    }
    
    func findIthFibonacciNumber() {
        if let fibNumberLoc = formatter.number(from: fibNumberInput) {
            if Int(fibNumberLoc) > 0 && Int(fibNumberLoc) < 93 {
                var fibNumbers: [Int] = []
                for i in 1...fibNumberLoc.intValue {
                    if i == 1 || i == 2 {
                        fibNumbers.append(1)
                    } else {
                        fibNumbers.append(fibNumbers[i-3] + fibNumbers[i-2])
                    }
                }
                if fibNumbers.count <= 2 {
                    fibNumberLocation = String(1)
                } else {
                    fibNumberLocation = "Fibonacci Number Result: \(String(fibNumbers[Int(fibNumberLoc) - 1]))"
                }
            } else {
                fibErrorMessage()
            }
        } else {
            fibErrorMessage()
        }
    }
    
    func calculateFactorial() {
        if let factorialNumber = formatter.number(from: factorialNumberInput) {
            if Int(factorialNumber.intValue) >= 0 && Int(factorialNumber.intValue) < 21 {
                if Int(factorialNumber.intValue) != 0 {
                    var factorial = 1
                    for i in 1...factorialNumber.intValue {
                        factorial *= i
                    }
                    factorialNumberResult = "Factorial Number Result: \(String(factorial))"
                } else {
                    factorialNumberResult = "Factorial Number Result: \(String(1))"
                }
               
            } else {
                factorialErrorMessage()
            }
        } else {
            factorialErrorMessage()
        }
    }
    
    func sumOfAllIntegers() {
        if let sumNumber1 = formatter.number(from: number1),
           let sumNumber2 = formatter.number(from: number2) {
            var sum = 0
            for i in sumNumber1.intValue...sumNumber2.intValue {
                sum += i
            }
            sumResult = "Sum Result: \(String(sum))"
        } else {
            sumErrorMessage()
        }
    }
    
    func calculateCoinsNumbers() {
        if let centsNumber = formatter.number(from: centsNumberInput) {
            quarters = String(Int(centsNumber.intValue/25))
            let remainderQuarters = round(Double(centsNumber.doubleValue/25).truncatingRemainder(dividingBy: 1) * 100 * 25) / 100
            
            dimes = String(Int(remainderQuarters/10))
            let remainderDimes = round(Double(remainderQuarters/10).truncatingRemainder(dividingBy: 1) * 100 * 10) / 100
            
            nickles = String(Int(remainderDimes/5))
            let remainderNickles =  round(Double(remainderDimes/5).truncatingRemainder(dividingBy: 1) * 100 * 5) / 100
            
            pennies = String(Int(remainderNickles/1))
            let remainderPennies = round(Double(remainderNickles/1).truncatingRemainder(dividingBy: 1) * 100 * 1) / 100
            
            let quartersText = "\(Int(quarters)! > 1 ? "\"\(quarters) quarters\"" : Int(quarters)! == 1 ? "\"\(quarters) quarter\"" : "")"
            let dimesText = "\(Int(dimes)! > 1 ? "\"\(dimes) dimes\"" : Int(dimes)! == 1 ? "\"\(dimes) dime\"" : "")"
            let nicklesText = "\(Int(nickles)! > 1 ? "\"\(nickles) nickles\"" : Int(nickles)! == 1 ? "\"\(nickles) nickle\"" : "")"
            let penniesText = "\(Int(pennies)! > 1 ? "\"\(pennies) pennies\"" : Int(pennies)! == 1 ? "\"\(pennies) penny\"" : "")"
            
            var coinPrint: [String] = [quartersText, dimesText, nicklesText, penniesText]
            coinPrint = coinPrint.filter({ $0 != ""})
            let temp = coinPrint.joined(separator: ", ")
            centsNumberResult = temp
        } else {
            fewestCoinsErrorMessage()
        }
    }
    
    func clearFibonacciTextFields() {
        fibNumberInput = ""
        fibNumberLocation = ""
    }
    
    func clearFactorialTextFields() {
        factorialNumberInput = ""
        factorialNumberResult = ""
    }
    
    func clearSumOfAllIntegersTextFields() {
        number1 = ""
        number2 = ""
        sumResult = ""
    }   
    
    func clearCentsNumbersTextFields() {
        quarters = ""
        dimes = ""
        nickles = ""
        pennies = ""
        pennies = ""
        centsNumberInput = ""
        centsNumberResult = ""
    }
    
    func fibErrorMessage() {
        fibNumberLocation = "Search must be >= 1 and <= 92"
    }
    
    func factorialErrorMessage() {
        factorialNumberResult = "Factorial Number must be >= 0 and <= 20"
    }
    
    func sumErrorMessage() {
        sumResult = "Number 1 and 2 must be Numbers"
    }
    
    func fewestCoinsErrorMessage() {
        centsNumberResult = "Cents Number must be > 0"
    }
    
}

#Preview {
    ContentView()
}
