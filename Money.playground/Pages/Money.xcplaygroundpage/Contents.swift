//: Playground - noun: a place where people can play

import UIKit

enum Currency{
    case USD
    case EUR
    case AUD
    case CAD
    case HKD
    case INR
    case GBP
    case JPY
    case MXN
    case CHF
}

struct ExchangeRate: Hashable{
    let currencyOne: Currency
    let currencyTwo: Currency
    let rate: Float
    
    var inverseRate: Float{
        get{
            return 1/rate
        }
    }
    
    var hashValue: Int{
        get{
            return "\(self)".hashValue
        }
    }
}

func ==(lhs:ExchangeRate, rhs: ExchangeRate)->Bool{
    return lhs.hashValue == rhs.hashValue
}

struct Money: Comparable{
    let money: (NSDecimalNumber, Currency)
    static let decimalHandler = NSDecimalNumberHandler(roundingMode: .RoundDown, scale: 2, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
    
    init(amt: Float, currency: Currency){
        money = (NSDecimalNumber(float: amt), currency)
        
    }
    
    init(amt: NSDecimal, currency: Currency){
        money = (NSDecimalNumber(decimal: amt), currency)
        
    }
    
    init(amt: Double, currency: Currency){
        money = (NSDecimalNumber(double: amt), currency)
        
    }
    
    var amount: Float {
        get{
            return money.0.decimalNumberByRoundingAccordingToBehavior(Money.decimalHandler).floatValue
        }
    }
    
    var currency: Currency{
        get{
            return money.1
        }
    }
}


extension Money {
    static var exchange_rates: Set<ExchangeRate> = Set()
    
    func pow(power: Int)->Money{
        let _amt = money.0.decimalNumberByRaisingToPower(power, withBehavior: Money.decimalHandler)
        return Money(amt: _amt.floatValue, currency: currency)
    }
    
    func amountIn(currency: Currency)->Money{
        let curr_exchange_rate = Money.exchange_rates.filter { (er) -> Bool in
            return (er.currencyOne == self.currency && er.currencyTwo == currency) || (er.currencyTwo == self.currency && er.currencyOne == currency)
        }
        
        guard let er = curr_exchange_rate.first else{
            return Money(amt: money.0.floatValue, currency: currency)
        }
        
        
        if er.currencyOne == self.currency{
            return Money(amt: self.money.0.floatValue * er.rate, currency: currency)
        }
        else{
            return Money(amt: self.money.0.floatValue * er.inverseRate, currency: currency)
        }
    }

}


extension Money: CustomStringConvertible{
    var description: String {
        get{
            let _amt = money.0.decimalNumberByRoundingAccordingToBehavior(Money.decimalHandler)
            return "\(_amt) \(money.1)"
        }
    }
}


extension ExchangeRate: CustomStringConvertible{
    var description: String {
        get{
            return "\(currencyOne)-\(currencyTwo): \(rate)"
        }
    }
}

func ==(lhs:Money, rhs:Money)->Bool{
   if lhs.money.0.compare(rhs.money.0) == .OrderedSame &&
    lhs.currency == rhs.currency {
        return true
    }
    
    return false
}

func <(lhs:Money, rhs:Money)->Bool{
    if lhs.currency == rhs.currency && lhs.amount < rhs.amount{
        return true
    }
    
    return false
}


func *(lhs: Money, rhs: Money)->Money{
    if lhs.currency == rhs.currency{
        let money = lhs.money.0.decimalNumberByMultiplyingBy(rhs.money.0)
        
        return Money(amt: money.floatValue, currency: lhs.currency)
    }
    
    return Money(amt: 0.0, currency: lhs.currency)
}

func *(lhs:Money, rhs: Float)->Money{
    let amount = lhs.amount * rhs
    return Money(amt: amount, currency: lhs.currency)
}

func *(lhs:Float, rhs: Money)->Money{
    let amount = lhs * rhs.amount
    return Money(amt: amount, currency: rhs.currency)
}

func /(lhs:Money, rhs:Money)->Money{
    if lhs.currency == rhs.currency{
        let money = lhs.money.0.decimalNumberByDividingBy(rhs.money.0)
        
        return Money(amt: money.floatValue, currency: lhs.currency)
    }
    
    return Money(amt: 0.0, currency: lhs.currency)
 
}

func /(lhs:Money, rhs: Float)->Money{
    if rhs != 0.00{
        let amount = lhs.amount / rhs
        return Money(amt: amount, currency: lhs.currency)
    }
    
    return Money(amt: 0.00, currency: lhs.currency)
}

func /(lhs:Float, rhs: Money)->Money{
    if rhs.amount != 0.00{
        let amount = lhs / rhs.amount
        return Money(amt: amount, currency: rhs.currency)
    }
    
    return Money(amt: 0.00, currency: rhs.currency)
}


func +(lhs:Money, rhs:Money)->Money{
    if lhs.currency == rhs.currency{
        let money = lhs.money.0.decimalNumberByAdding(rhs.money.0)
        
        return Money(amt: money.floatValue, currency: lhs.currency)
    }
    
    return Money(amt: 0.0, currency: lhs.currency)
    
}

func +(lhs:Money, rhs: Float)->Money{
    let amount = lhs.amount + rhs
    return Money(amt: amount, currency: lhs.currency)
}

func +(lhs:Float, rhs: Money)->Money{
    let amount = lhs + rhs.amount
    return Money(amt: amount, currency: rhs.currency)
}


func -(lhs:Money, rhs:Money)->Money{
    if lhs.currency == rhs.currency{
        let money = lhs.money.0.decimalNumberBySubtracting(rhs.money.0)
        
        return Money(amt: money.floatValue, currency: lhs.currency)
    }
    
    return Money(amt: 0.0, currency: lhs.currency)
    
}

func -(lhs:Money, rhs: Float)->Money{
    let amount = lhs.amount - rhs
    return Money(amt: amount, currency: lhs.currency)
}

func -(lhs:Float, rhs: Money)->Money{
    let amount = lhs - rhs.amount
    return Money(amt: amount, currency: rhs.currency)
}

func %(lhs:Money, rhs: Money)->Money{
    if rhs.amount != 0.0 {
        let amt = lhs.amount % rhs.amount
        return Money(amt: amt, currency: lhs.currency)
    }
    
    return Money(amt: 0.0, currency: lhs.currency)
}

func %(lhs:Money, rhs: Float)->Money{
    if rhs != 0.00{
        let amount = lhs.amount % rhs
        return Money(amt: amount, currency: lhs.currency)
    }
    
    return Money(amt: 0.00, currency: lhs.currency)
}

func %(lhs:Float, rhs: Money)->Money{
    if rhs.amount != 0.00{
        let amount = lhs % rhs.amount
        return Money(amt: amount, currency: rhs.currency)
    }
    
    return Money(amt: 0.00, currency: rhs.currency)
}


let usd_money = Money(amt: 10.02, currency: .USD)
let cad_money = usd_money.amountIn(.CAD)
usd_money.amount
cad_money.currency

let small_usd = Money(amt: 9.897, currency: .USD)
usd_money == small_usd
usd_money > small_usd
small_usd.amount
let big_usd = small_usd * usd_money
let x20 = small_usd * 20.0
small_usd / usd_money
small_usd / 3.098

let eur_usd = ExchangeRate(currencyOne: .EUR, currencyTwo: .USD, rate: 1.11679)
let eur_usd2 = ExchangeRate(currencyOne: .EUR, currencyTwo: .USD, rate: 1.13)
eur_usd == eur_usd2
let eur_usd3 = eur_usd
eur_usd == eur_usd3
let usd_eur = ExchangeRate(currencyOne: .USD, currencyTwo: .EUR, rate: eur_usd.inverseRate)
usd_eur == eur_usd
let inverseRate = usd_eur.inverseRate
let usd_cad = ExchangeRate(currencyOne: .USD, currencyTwo: .CAD, rate: 1.328)

Money.exchange_rates.insert(eur_usd)
Money.exchange_rates.insert(usd_cad)

let cad = usd_money.amountIn(.CAD)
let usd = cad.amountIn(.USD)
let eur = usd.amountIn(.EUR)
eur.amount
usd.amount
cad.amount

