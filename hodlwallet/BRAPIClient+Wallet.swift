//
//  BRAPIClient+Wallet.swift
//  breadwallet
//
//  Created by Samuel Sutch on 4/2/17.
//  Copyright © 2017 breadwallet LLC. All rights reserved.
//

import Foundation

private let fallbackRatesURL = "https://bitpay.com/api/rates"
private let primaryRatesURL = "https://api.coingecko.com/api/v3/coins/groestlcoin?localization=false&community_data=false&developer_data=false&sparkline=false"

extension BRAPIClient {
    func feePerKb(_ handler: @escaping (_ fees: Fees, _ error: String?) -> Void) {
        #if Testflight || Debug
            let req = URLRequest(url: url("/hodl/fee-estimator.json"))
        #else
            let req = URLRequest(url: url("/hodl/fee-estimator.json"))
        #endif

        let task = self.dataTaskWithRequest(req) { (data, response, err) -> Void in
            var fastestFee = Fees.defaultFees.fastest
            var regularFee = Fees.defaultFees.regular
            var economyFee = Fees.defaultFees.economy
            var errStr: String? = nil
            if err == nil {
                do {
                    let parsedObject: Any? = try JSONSerialization.jsonObject(
                        with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let top = parsedObject as? NSDictionary,
                        let fastest = top["fastest_sat_per_kilobyte"] as? NSNumber,
                        let regular = top["normal_sat_per_kilobyte"] as? NSNumber,
                        let economy = top["slow_sat_per_kilobyte"] as? NSNumber,
                        let _ = top["fastest_time"] as? NSNumber,
                        let _ = top["normal_time"] as? NSNumber,
                        let _ = top["slow_time"] as? NSNumber,
                        let fastestTimeText = top["fastest_time_text"] as? NSString,
                        let regularTimeText = top["normal_time_text"] as? NSString,
                        let economyTimeText = top["slow_time_text"] as? NSString,
                        let fastestBlocks = top["fastest_blocks"] as? NSNumber,
                        let regularBlocks = top["normal_blocks"] as? NSNumber,
                        let economyBlocks = top["slow_blocks"] as? NSNumber {
                        fastestFee = FeeData(sats: 20000/*fastest.uint64Value*/, time: "1 minute", blocks: fastestBlocks.intValue)
                        regularFee = FeeData(sats: 10000/*regular.uint64Value*/, time: "1 minute", blocks: regularBlocks.intValue)
                        economyFee = FeeData(sats:  5000/*economy.uint64Value*/, time: "3 minutes", blocks: economyBlocks.intValue)
                    }
                } catch (let e) {
                    self.log("fee-per-kb: error parsing json \(e)")
                }
                if fastestFee.sats == 0 || regularFee.sats == 0 || economyFee.sats == 0 {
                    errStr = "invalid json"
                }
            } else {
                self.log("fee-per-kb network error: \(String(describing: err))")
                errStr = "bad network connection"
            }
            handler(Fees(fastest: fastestFee, regular: regularFee, economy: economyFee), errStr)
        }
        task.resume()
    }
    //The old exchangeRates method will be saved here for future reference
    /*
     func exchangeRates(isFallback: Bool = false, _ handler: @escaping (_ rates: [Rate], _ error: String?) -> Void) {
         #if Testflight || Debug
             let request = isFallback ? URLRequest(url: URL(string: fallbackRatesURL)!) : URLRequest(url: url("/hodl/rates.json"))

         #else
             let request = isFallback ? URLRequest(url: URL(string: fallbackRatesURL)!) : URLRequest(url: url("/hodl/rates.json"))

         #endif

         let task = dataTaskWithRequest(request) { (data, response, error) in
             if error == nil, let data = data,
                 let parsedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                 if isFallback {
                     guard let array = parsedData as? [Any] else {
                         return handler([], "/rates didn't return an array")
                     }
                     handler(array.flatMap { Rate(data: $0) }, nil)
                 } else {
                     guard let array = parsedData as? [Any] else {
                         return self.exchangeRates(isFallback: true, handler)
                     }
                     handler(array.flatMap { Rate(data: $0) }, nil)
                 }
             } else {
                 if isFallback {
                     handler([], "Error fetching from fallback url")
                 } else {
                     self.exchangeRates(isFallback: true, handler)
                 }
             }
         }
         task.resume()
     }
     */
    
    func exchangeRates(isFallback: Bool = false, _ handler: @escaping (_ rates: [Rate], _ error: String?) -> Void) {
        
        let request = isFallback ? URLRequest(url: URL(string: primaryRatesURL)!) : URLRequest(url: URL(string: primaryRatesURL)!)

        let task = dataTaskWithRequest(request) { (data, response, error) in
            if error == nil, let data = data,
                let parsedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                if isFallback {
                    if let results = parsedData as? [String: Any] {
                        if let marketData = results["market_data"] as? [String: Any] {
                            if let currencyData  = marketData["current_price"] as? [String: Any] {
                                handler(currencyData.flatMap { CoinGeckoRate(data: $0)!.rateObject }, nil)
                            }
                        }
                    }
                } else {
                    if let results = parsedData as? [String: Any] {
                        if let marketData = results["market_data"] as? [String: Any] {
                            if let currencyData  = marketData["current_price"] as? [String: Any] {
                                handler(currencyData.flatMap { CoinGeckoRate(data: $0)!.rateObject }, nil)
                            }
                        }
                    }
                }
            } else {
                if isFallback {
                    handler([], "Error fetching from fallback url")
                } else {
                    self.exchangeRates(isFallback: true, handler)
                }
            }
        }
        task.resume()
    }
    
    /*func exchangeRatesGRS(isFallback: Bool = false, _ handler: @escaping (_ rate: Double, _ error: String?) -> Void) {

        let request = URLRequest(url: URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=groestlcoin&vs_currencies=BTC")!)
        // {"groestlcoin":{"btc":2.371e-05}}

        let task = dataTaskWithRequest(request) { (data, response, error) in
            if error == nil, let data = data,
                let parsedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any] {
                
                guard let grs = parsedData["groestlcoin"] as? JSONObject, let rate = grs["btc"] as? Double else {
                    handler(0.00, "Error fetching from fallback url")
                }
                handler(rate, nil)
            } else {
                handler(0.00, "Error fetching from fallback url")
            }
        }
        task.resume()
    }*/
    
    func savePushNotificationToken(_ token: Data) {
        var req = URLRequest(url: url("/me/push-devices"))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        let reqJson = [
            "token": token.hexString,
            "service": "apns",
            "data": [   "e": pushNotificationEnvironment(),
                        "b": Bundle.main.bundleIdentifier!]
            ] as [String : Any]
        do {
            let dat = try JSONSerialization.data(withJSONObject: reqJson, options: .prettyPrinted)
            req.httpBody = dat
        } catch (let e) {
            log("JSON Serialization error \(e)")
            return
        }
        dataTaskWithRequest(req as URLRequest, authenticated: true, retryCount: 0) { (dat, resp, er) in
            let dat2 = String(data: dat ?? Data(), encoding: .utf8)
            self.log("save push token resp: \(String(describing: resp)) data: \(String(describing: dat2))")
        }.resume()
    }

    func deletePushNotificationToken(_ token: Data) {
        var req = URLRequest(url: url("/me/push-devices/apns/\(token.hexString)"))
        req.httpMethod = "DELETE"
        dataTaskWithRequest(req as URLRequest, authenticated: true, retryCount: 0) { (dat, resp, er) in
            self.log("delete push token resp: \(String(describing: resp))")
            if let statusCode = resp?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    UserDefaults.pushToken = nil
                    self.log("deleted old token")
                }
            }
        }.resume()
    }

    func publishBCashTransaction(_ txData: Data, callback: @escaping (String?) -> Void) {
        var req = URLRequest(url: url("/bch/publish-transaction"))
        req.httpMethod = "POST"
        req.setValue("application/bcashdata", forHTTPHeaderField: "Content-Type")
        req.httpBody = txData
        dataTaskWithRequest(req as URLRequest, authenticated: true, retryCount: 0) { (dat, resp, er) in
            if let statusCode = resp?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    callback(nil)
                } else if let data = dat, let errorString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    callback(errorString as String)
                } else {
                    callback("\(statusCode)")
                }
            }
        }.resume()
    }
}

private func pushNotificationEnvironment() -> String {
    return E.isDebug ? "d" : "p" //development or production
}
