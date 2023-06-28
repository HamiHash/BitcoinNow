import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: Double)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "?apikey=FD5D8803-037A-4A18-88C1-EA24D775479F"
    var cur: String?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    mutating func getCoinPrice(for currency: String) {
        cur = currency
    }
    
    func fetchApi() {
        let urlString = "\(baseURL)\(cur ?? "USD")\(apiKey)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {  // the "with" makes it easier to read. it's like "_"
        // create url
        let url = URL(string: urlString)!
        
        // create session
        let session = URLSession(configuration: .default)
        
        // give session a task
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error!)
                return
            }
            
            if let safeData = data {
                // we used "if let" here becouse parseJSON's returned value is optional
                if let coinParsed = self.parseJSON(safeData) {
                    self.delegate?.didUpdateCoin(self, coin: coinParsed)
                }
            }
        }
        
        // start task
        task.resume()
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let coin = decodedData.rate
            return coin
            
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
