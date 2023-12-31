/*:
 # Homework 2 Solution
 This is one possible solution to HW 2.  There are many good solutions.  The most important aspect of a programming project is that it works.  Whether the solution is *elegant* is a secondary question.
 */
import Foundation
/*:
 We start with an iterative approach to the Fibonacci problem.  This is generally the most *efficient* way to program the function, but is it the most *understandable*?
 In most of these functions, note that I've eliminated the external name for the first parameter by placing
 an underscore in front of the internal name.
 */
func fibonacci(_ i: Int) -> Int {
    if i <= 0 {
        return 0
    } else if i < 3 {
        return 1
    }
    
    var f1 = 1
    var f2 = 1
    
    for _ in 3 ... i {
        let f = f1 + f2
        f1 = f2
        f2 = f
    }
    
    return f2
}
/*:
 Here is a recursive solution.  It's quite a bit less verbose, but does the use of the ternary `? :` operator make it harder to read?
 */
func recursiveFibonacci(_ i: Int) -> Int {
    i <= 0 ? 0 : (i < 3 ? 1 : recursiveFibonacci(i - 2) + recursiveFibonacci(i - 1))
}
/*:
 Here's the same thing with `if` statements instead.
 */
func recursiveFibonacci2(_ i: Int) -> Int {
    if i <= 0 {
        return 0
    }

    if i < 3 {
        return 1
    }

    return recursiveFibonacci(i - 2) + recursiveFibonacci(i - 1)
}
/*:
 Let's verify that it works:
 */
fibonacci(-2)
recursiveFibonacci(-2)
fibonacci(-1)
recursiveFibonacci(-1)
fibonacci(0)
recursiveFibonacci(0)
fibonacci(1)
recursiveFibonacci(1)
fibonacci(2)
recursiveFibonacci(2)
fibonacci(3)
recursiveFibonacci(3)
fibonacci(4)
recursiveFibonacci(4)
fibonacci(9)
recursiveFibonacci(9)
fibonacci(10)
recursiveFibonacci(10)
recursiveFibonacci2(10)
/*:
 The following case would run very slowly in the recursive form.  Try it if you'd like.  Note that we could speed up the recursive algorithm by "memoizing" it (or in other words caching each intermediate value as we calculate it; then before calling a recursive sub-function, we first check to see if it's already in the cache; if yes, we return the cached value).  Of course that's a *lot* more complicated.  As with all software engineering decisions, it's all about trade-offs.
 */
fibonacci(60)
/*:
 Now we do the same drill with the factorial function.  Iterative is more verbose, but more efficient.
 */
func factorial(_ n: Int) -> Int {
    if n <= 1 {
        return 1
    }
    
    // The recursive implementation is to return n * factorial(n - 1)
    
    var f = 1
    
    for i in 2 ... n {
        f *= i
    }
    
    return f
}
/*:
 The recursive expression is clear and concise, but slower.
 */
func recursiveFactorial(_ n: Int) -> Int {
    return n <= 1 ? 1 : n * recursiveFactorial(n - 1)
}
/*:
 Be sure to test an interesting set of possible input values.
 */
factorial(-1)
recursiveFactorial(-1)
factorial(0)
recursiveFactorial(0)
factorial(1)
recursiveFactorial(1)
factorial(2)
recursiveFactorial(2)
factorial(3)
recursiveFactorial(3)
factorial(4)
recursiveFactorial(4)
factorial(5)
recursiveFactorial(5)
factorial(6)
recursiveFactorial(6)
factorial(10)
recursiveFactorial(10)
factorial(20)
recursiveFactorial(20)
/*:
 This next function is pretty straightforward.
 */
func sum(_ m: Int, _ n: Int) -> Int {
    var sum = 0

    if n >= m {
        for i in m ... n {
            sum += i
        }
    }

    return sum
}

sum(-10, -1)
sum(-2, 5)
sum(6, 10)
sum(1, 1)
sum(1, 2)
sum(1, 3)
sum(1, 4)
sum(1, 5)
sum(1, 10)
/*:
 Note that there is a mathematical formula you can use to calculate the sum of integers.  So if I were solving this problem in an industrial-strength app, I'd use the formula, sum = (m + n)(n - m + 1)/2.  Proof: ![Derivation of formula to sum integers between m and n](SumFormulaDerivation.png)
 */
/*:
 And finally my solution to the coins problem.  There are lots of fine alternatives to my approach.
 */
func computeCoinsFor(totalCents: Int) {
    let coinAmount = [25, 10, 5, 1]
    let coinName = ["quarters", "dimes", "nickels", "pennies"]
    let coinSingular = ["quarter", "dime", "nickel", "penny"]
    var total = totalCents
    
    print("\nTo get \(totalCents) cents, use the following coins:")
    
    for i in 0 ..< coinAmount.count {
        let count = total / coinAmount[i]
        total -= count * coinAmount[i]
        
        if count == 1 {
            print("\(count) \(coinSingular[i])")
        } else if count > 1 {
            print("\(count) \(coinName[i])")
        }
    }
}

computeCoinsFor(totalCents: 113)
computeCoinsFor(totalCents: 1000)
computeCoinsFor(totalCents: 527)
computeCoinsFor(totalCents: 41)
computeCoinsFor(totalCents: 55)
computeCoinsFor(totalCents: 48)
/*:
 As I looked through student solutions, here's a technique I saw that is worth highlighting to everyone: the use of "tuple" types.
 */
let coins = [
    (singular: "quarter", plural: "quarters", amount: 25),
    (singular: "dime",    plural: "dimes",    amount: 10),
    (singular: "nickel",  plural: "nickels",  amount: 5),
    (singular: "penny",   plural: "pennies",  amount: 1)
]
/*:
 Here, `coins` is an array of tuples, or more specifically, triples.  The labels on each
 position are optional.  You can instead reference elements of a tuple by position (0, 1, ...).
 So now we can rewrite our last function to be a little cleaner:
 */
func computeCoins2For(totalCents: Int) {
    let coins = [
        (singular: "quarter", plural: "quarters", amount: 25),
        (singular: "dime",    plural: "dimes",    amount: 10),
        (singular: "nickel",  plural: "nickels",  amount: 5),
        (singular: "penny",   plural: "pennies",  amount: 1)
    ]
    var total = totalCents

    print("\nTo get \(totalCents) cents, use the following coins:")

    for coin in coins {
        let count = total / coin.amount
        total -= count * coin.amount

        if count == 1 {
            print("\(count) \(coin.singular)")
        } else if count > 1 {
            print("\(count) \(coin.plural)")
        }
    }
}

computeCoins2For(totalCents: 113)
computeCoins2For(totalCents: 1000)
computeCoins2For(totalCents: 527)
computeCoins2For(totalCents: 41)
computeCoins2For(totalCents: 55)
computeCoins2For(totalCents: 48)
