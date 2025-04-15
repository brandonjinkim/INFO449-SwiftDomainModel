struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    func toUSD() -> Money {
        let USDconversion: Int
        
        switch currency {
        case "EUR":
            USDconversion = amount * 3 / 2
        case "GBP":
            USDconversion = amount * 2
        case "CAN":
            USDconversion = amount * 5 / 4
        default:
            USDconversion = amount
        }
        return Money(amount: USDconversion, currency: "USD")
    }
    
    func convert(_ conversion: String) -> Money {
        
        let amountUSD = self.toUSD().amount
        
        let result = switch conversion {
        case "EUR":
            Money(amount: amountUSD * 2 / 3, currency: "EUR")
        case "GBP":
            Money(amount: amountUSD / 2, currency: "GBP")
        case "CAN":
            Money(amount: amountUSD * 4 / 5, currency: "CAN")
        default:
            Money(amount: amountUSD, currency: currency)
        }
        
        return result
    }
    
    func add (_ addend: Money) -> Money {
        
        if (addend.currency == self.currency) {
            return Money(amount: self.amount + addend.amount, currency: self.currency)
        }
        else {
            let convertedAddend = addend.convert(self.currency)
            return Money(amount: self.amount + convertedAddend.amount, currency: self.currency)
            
        }
    }
    
    func subtract (_ addend: Money) -> Money {
        
        if (addend.currency == self.currency) {
            return Money(amount: self.amount - addend.amount, currency: self.currency)
        }
        else {
            let convertedAddend = addend.convert(self.currency)
            return Money(amount: self.amount - convertedAddend.amount, currency: self.currency)
            
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome (_ hours: Int) -> Int {
        switch type {
        case .Hourly(let hourlyRate):
            return Int(hourlyRate * Double(hours))
        case .Salary(let annualSalary):
            return Int(annualSalary)
        }
    }
    
    //raising flat amount
    func raise(byAmount amount: Double) {
        switch type {
        case .Hourly(let hourlyRate):
            type = .Hourly(hourlyRate + amount)
        case .Salary(let annualSalary):
            type = .Salary(annualSalary + UInt(amount))
        }
    }
    
    // raising by percent
    func raise(byPercent percent: Double) {
        switch type {
        case .Hourly(let hourlyRate):
            type = .Hourly(hourlyRate * (1 + percent))
        case .Salary(let annualSalary):
            let newSalary = Double(annualSalary) * (1 + percent)
            type = .Salary(UInt(newSalary))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    
    var job: Job? {
        didSet {
            if age < 16 {
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if age < 18 {
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        if (job == nil && spouse == nil) {
            return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:nil spouse:nil]"
        }
        else if (job == nil) {
            return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:nil spouse:\(spouse!.firstName)]"
        }
        else if (spouse == nil) {
            return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job!.type) spouse:nil]"
        }
        else {
            return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job!.type) spouse:\(spouse!.firstName)]"
        }
    }}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person] = []
    
    init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        if (members[0].age >= 21 || members[1].age >= 21) {
            members.append(child)
            return true
        }
        return false
    }
    
    func householdIncome() -> Int {
        var totalIncome: Int = 0
        for member in members {
            if let job = member.job {
                totalIncome += job.calculateIncome(2000)
            }
        }
        return totalIncome
    }
}
