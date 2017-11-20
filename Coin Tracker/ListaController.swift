//
//  ListaController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

//Duhet te jete conform protocoleve per tabele
class ListaController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var allCoins:[CoinCellModel] = []
    var selectedCoin:CoinCellModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shfaqDetajet"{
            let allCoins = segue.destination as! DetailsController
            
            allCoins.selectedCoin = selectedCoin
            
        }
    }
    
    
    
    
    //URL per API qe ka listen me te gjithe coins
    //per me shume detaje : https://www.cryptocompare.com/api/
    let APIURL = "https://min-api.cryptocompare.com/data/all/coinlist"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
       getDataFromAPI()
    }
    
    
    func getDataFromAPI(){
        
        Alamofire.request(APIURL, method: .get).responseData { (data) in
            
            if data.result.isSuccess{
                let CoinJSON = try! JSON(data: data.result.value!)
                for (_,value) : (String, JSON) in CoinJSON["Data"]{
                
                    let coincellModel = CoinCellModel (coinName: value["CoinName"].stringValue, coinSymbol: value["Name"].stringValue, coinAlgo: value["Algorithm"].stringValue, totalSuppy: value["TotalCoinSupply"].stringValue, imagePath: value["ImageUrl"].stringValue)
                    self.allCoins.append(coincellModel)
                
                }
                self.tableView.reloadData()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCoins.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        cell.lblEmri.text = allCoins[indexPath.row].coinName
        cell.lblTotali.text = allCoins[indexPath.row].totalSuppy
        cell.lblSymboli.text = allCoins[indexPath.row].coinSymbol
        cell.lblAlgoritmi.text = allCoins[indexPath.row].coinAlgo
        cell.imgFotoja.af_setImage(withURL: URL(string: allCoins[indexPath.row].coinImage())!)
        return cell
        
        
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
       let coin =  allCoins[indexPath.row]
        selectedCoin = coin
        performSegue(withIdentifier: "shfaqDetajet", sender: self)
   }
    
    

   

}
