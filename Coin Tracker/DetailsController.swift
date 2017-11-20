//
//  ViewController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import CoreData

class DetailsController: UIViewController {

    //selectedCoin deklaruar me poshte mbushet me te dhena nga
    //controlleri qe e thrret kete screen (Shiko ListaController.swift)
    var selectedCoin:CoinCellModel!
    var coindetailsmodel:CoinDetailsModel?
    
    
    //IBOutlsets jane deklaruar me poshte
    @IBOutlet weak var imgFotoja: UIImageView!
    @IBOutlet weak var lblDitaOpen: UILabel!
    @IBOutlet weak var lblDitaHigh: UILabel!
    @IBOutlet weak var lblDitaLow: UILabel!
    @IBOutlet weak var lbl24OreOpen: UILabel!
    @IBOutlet weak var lbl24OreHigh: UILabel!
    @IBOutlet weak var lbl24OreLow: UILabel!
    @IBOutlet weak var lblMarketCap: UILabel!
    @IBOutlet weak var lblCmimiBTC: UILabel!
    @IBOutlet weak var lblCmimiEUR: UILabel!
    @IBOutlet weak var lblCmimiUSD: UILabel!
    @IBOutlet weak var lblCoinName: UILabel!
    
    //APIURL per te marre te dhenat te detajume per coin
    //shiko: https://www.cryptocompare.com/api/ per detaje
    let APIURL = "https://min-api.cryptocompare.com/data/pricemultifull"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCoinName.text = selectedCoin.coinName
        imgFotoja.af_setImage(withURL: URL(string: selectedCoin.coinImage())!)
        
        let params : [String : String] = ["fsyms" : selectedCoin.coinSymbol, "tsyms" : "BTC, USD, EUR"]
        
        getDetails(params: params)
    }

    func getDetails(params:[String:String]){
        //Thrret Alamofire me parametrat qe i jan jap funksionit
        //dhe te dhenat qe kthehen nga API te mbushin labelat
        //dhe pjeset tjera te view
        Alamofire.request(APIURL, method: .get, parameters: params).responseData { (data) in
            
            if data.result.isSuccess{
                let CoinJSON = try! JSON(data: data.result.value!)
                
                    let coindetailsmodel = CoinDetailsModel (marketCap: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["MKTCAP"].stringValue, hourHigh: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["HIGH24HOUR"].stringValue, hourLow: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["LOW24HOUR"].stringValue, hourOpen: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["MKTCAP"].stringValue, dayHigh: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["HIGHDAY"].stringValue, dayLow: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["LOWDAY"].stringValue, dayOpen: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["OPENDAY"].stringValue, priceEUR: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["PRICE"].stringValue, priceUSD: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["PRICE"].stringValue, priceBTC: CoinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["PRICE"].stringValue)
                    
                    self.updateUI(CoinDetailsModelObject: coindetailsmodel)
                
            }
           
            }
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateUI (CoinDetailsModelObject:CoinDetailsModel)
    {
        coindetailsmodel = CoinDetailsModelObject
        lblDitaOpen.text = CoinDetailsModelObject.dayOpen
        lblDitaLow.text = CoinDetailsModelObject.dayLow
        lbl24OreLow.text = CoinDetailsModelObject.hourLow
        lblDitaHigh.text = CoinDetailsModelObject.dayHigh
        lblCmimiBTC.text = CoinDetailsModelObject.priceBTC
        lblCmimiEUR.text = CoinDetailsModelObject.priceEUR
        lblCmimiUSD.text = CoinDetailsModelObject.priceUSD
        lblMarketCap.text = CoinDetailsModelObject.marketCap
        lbl24OreHigh.text = CoinDetailsModelObject.hourHigh
        lbl24OreOpen.text = CoinDetailsModelObject.hourOpen
        
    }
   
    @IBAction func mbylle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func ruaj(_ sender: Any) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let request = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        request.setValue(selectedCoin.coinImage(), forKey: "imagePath")
        request.setValue(selectedCoin.coinSymbol, forKey: "coinSymbol")
        request.setValue(selectedCoin.coinAlgo, forKey: "coinAlgo")
        request.setValue(selectedCoin.coinName, forKey: "coinName")
        request.setValue(selectedCoin.totalSuppy, forKey: "totalSuppy")
        
        do{
            try context.save()
        }catch{
            print("Gabim gjate ruajtjes!")
        }
        
    }
}
