import UIKit

class CoinViewController: UIViewController {
    @IBOutlet weak var bitcoinLable: UILabel!
    @IBOutlet weak var currencyLable: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    var selectedCurrency: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

//MARK: - CoinManagerDelegate

extension CoinViewController: CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: Double) {
        DispatchQueue.main.async { // This is basically "Async".
            let rateToTwoDecimal = String(format: "%.2f", coin)

            self.bitcoinLable.text = rateToTwoDecimal
            self.currencyLable.text = self.selectedCurrency
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

//MARK: - UIPickerViewDataSource and UIPickerViewDelegate

extension CoinViewController: UIPickerViewDataSource, UIPickerViewDelegate {func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency ?? "USD")
        coinManager.fetchApi()
    }
}
