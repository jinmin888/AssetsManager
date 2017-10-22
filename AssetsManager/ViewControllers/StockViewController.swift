
//
//  StockViewController.swift
//  AssetsManager
//
//  Created by min on 10/13/17.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StockViewController: UITableViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet weak var headerView: UICollectionView!
    var stockList:Array<Stock> = []
    let sortOption = ["저평가순","고성장순","저PBR순"]
    var isInitStatus = false
    let activityIndicator:NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.ballTrianglePath, color:UIColor.untSelectColor, padding: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.tableView.center
        self.tableView.addSubview(activityIndicator)
        
        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        StockManager.shared.getStock("20171021") { (list, error) in
            self.stockList = list
            self.activityIndicator.isHidden = true
            self.tableView.reloadData()
            self.collectionView(self.headerView, didSelectItemAt: IndexPath(row: 0, section: 0))
        };
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:StockTableviewCell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! as! StockTableviewCell
        let stock:Stock = self.stockList[indexPath.row]
        cell.stockName.text = stock.stockName
        cell.epsEstimate.text = String(format:"%0.2f%",stock.fwd24MEpsCompondIncrease)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.sortOption.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isInitStatus == true {
            self.collectionView(self.headerView, didDeselectItemAt: IndexPath(item: 0, section: 0))
            self.isInitStatus = false
        }
        let cell:SortOptionCell = collectionView.cellForItem(at: indexPath) as! SortOptionCell
        cell.backgroundColor = UIColor.untSelectColor
        cell.textLabel.textColor = UIColor.white
        self.isInitStatus = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell:SortOptionCell = collectionView.cellForItem(at: indexPath) as! SortOptionCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel.textColor = UIColor.black
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SortOptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionLabel",
                                                      for: indexPath) as! SortOptionCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel.text = self.sortOption[indexPath.row]
        return cell
    }
    
}


