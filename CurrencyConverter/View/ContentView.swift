import SwiftUI

struct ContentView: View {
    @State private var inputCurrency = 0
    @State private var outputCurrency = 1
    @State private var amount: String
    = ""
    @State private var amount2
    = ""
    @State var currencyDict = [String:Double]()
    private let getFlag = [ "🇧🇾", "🇪🇺",  "🇷🇺", "🇺🇸"]
    private let currencies = ["BYN", "EUR", "RUB", "USD"]
    func convertTo(_ convert: String) -> String {
        var conversion: Double = 1.0
        let amount = Double(convert.doubleValue)
        let stringAmount = String(amount)
        let selectedCurrency = currencies[inputCurrency]
        let to = currencies[outputCurrency]
        switch (selectedCurrency) {
        case "USD" :
            let usdRates =  makeRequest(stringAmount: stringAmount, inputBase: "USD")
            conversion = amount * (usdRates[to] ?? 0.0)
        case "EUR" :
            let euroRates = makeRequest(stringAmount: stringAmount, inputBase: "EUR")
            conversion = amount * (euroRates[to] ?? 0.0)
        case "BYN" :
            let bynRates = makeRequest(stringAmount: stringAmount, inputBase: "BYN")
            conversion = amount * (bynRates[to] ?? 0.0)
        case "RUB" :
            let rubRates = makeRequest(stringAmount: stringAmount, inputBase: "RUB")
            conversion = amount * (rubRates[to] ?? 0.0)
        default:
            print("Somethimg went wrong!")
        }
        return String(format: "%.2f", conversion)
    }
    ///API request
    func makeRequest(currencies: [String] = ["BYN", "EUR", "RUB", "USD"], stringAmount: String, inputBase: String) -> Dictionary<String, Double> {
        apiRequest(url: "https://api.exchangerate.host/latest?base=\(inputBase)&amount=\(stringAmount)") { currency in
            var tempList = [String:Double]()
            for currency in currency.rates {
                if currencies.contains(currency.key)  {
                    let currencyValue = currency.value
                    let countryCode = currency.key
                    tempList.updateValue(currencyValue, forKey: countryCode)
                }
            }
            currencyDict.self = tempList
        }
        return currencyDict
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                HStack() {
                    Text("Currencies").font(.system(size: 30)).bold()
                    Image(systemName: "eurosign.circle.fill").font(.system(size: 30)).foregroundColor(Color.green)
                }
                Form {
                    Section(header: Text("Convert a currency")) {
                        VStack {
                            HStack {
                                TextField("\(convertTo(amount2)) ", text: $amount).keyboardType(.decimalPad).font(.system(size: 20, weight: .medium, design: .default))
                                Picker(selection: $inputCurrency, label: Text(getFlag[inputCurrency]) .font(.system(size: 35))) {
                                    ForEach(0..<currencies.count) { index in
                                        Text(self.currencies[index]).tag(index)
                                    }
                                }
                            }.padding()
                            
                            Rectangle().frame(height: 3.0).foregroundColor(Color.green).opacity(0.5)
                            
                            HStack{
                                TextField("\(convertTo(amount)) ", text: $amount2).keyboardType(.decimalPad).font(.system(size: 20, weight: .medium, design: .default))
                                Picker(selection: $outputCurrency, label: Text(getFlag[outputCurrency]) .font(.system(size: 35))) {
                                    ForEach(0..<currencies.count) { index in
                                        Text(self.currencies[index]).tag(index)
                                    }
                                }
                            }.padding()
                        }
                    }.navigationTitle("Converter").foregroundColor(Color.black)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
