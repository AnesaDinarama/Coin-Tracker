//
//  FavoritetController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/13/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage


class FavoritetController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var rezultati:[String] = []
    var coinsTable:[CoinCellModel] = []
    var coins:CoinCellModel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        cell.lblEmri.text = coinsTable[indexPath.row].coinName
        cell.lblSymboli.text = coinsTable[indexPath.row].coinSymbol
        cell.lblTotali.text = coinsTable[indexPath.row].totalSuppy
        cell.lblAlgoritmi.text = coinsTable[indexPath.row].coinAlgo
        cell.imgFotoja.af_setImage(withURL: URL(string: coinsTable[indexPath.row].coinImage())!)
        print(coinsTable[indexPath.row].coinImage())
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let perdoruesiIRi = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        perdoruesiIRi.returnsObjectsAsFaults = false
        
        do {
            let rezultati = try context.fetch(perdoruesiIRi)
            for elementi in rezultati as! [NSManagedObject]{
                self.coinsTable.append(CoinCellModel(coinName: (elementi.value(forKey: "coinName") as? String)!, coinSymbol: (elementi.value(forKey: "coinSymbol") as? String)!, coinAlgo: (elementi.value(forKey: "coinAlgo") as? String)!, totalSuppy: (elementi.value(forKey: "totalSuppy") as? String)!, imagePath: (elementi.value(forKey: "imagePath") as? String)!))
            }
           
            
            
        } catch {
            print("Gabim!")
        }
        
        
    }
    
    @IBAction func kthehu(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
