//
//  StockEpsViewController.swift
//  AssetsManager
//
//  Created by min on 10/22/17.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StockEpsViewModel{
    var stockName:String = ""
    var thisYearEpsChanges:Double? = 0
    var nextYearEpsChanges:Double? = 0
    var yearAfterNextEpsChanges:Double? = 0
}

class StockEpsViewController:ViewController,UITableViewDelegate,UITableViewDataSource {
       let activityIndicator:NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.ballTrianglePath, color:UIColor.untSelectColor, padding: 0.0)
    @IBOutlet weak var endDateTextfield: UITextField!
    
    @IBOutlet weak var stockListView: UITableView!
    @IBOutlet weak var startDateTextfield: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var stockList = Array<StockEpsViewModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.activityIndicator.isHidden = true
        self.endDateTextfield.text = Utility.currentDate()
    }
    
    @IBAction func back(_ sender: Any) {
        print("back")
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func epsSelectChanged(_ sender: UISegmentedControl) {
        print("select tap : \(sender.selectedSegmentIndex)")
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if(sender.selectedSegmentIndex == 0){
            //내후년 eps 변동순 으로 정렬
            self.stockList.sort(by: { (model1, model2) -> Bool in
                if let model1chanage = model1.nextYearEpsChanges, let model2change = model2.nextYearEpsChanges {
                if(model1chanage > model2change){
                    return true
                    }
                }
                return false;
            })
        }
        else{
            //내연 eps 변동순으로 정렬
            self.stockList.sort(by: { (model1, model2) -> Bool in
                if let model1chanage = model1.yearAfterNextEpsChanges, let model2change = model2.yearAfterNextEpsChanges {
                    if(model1chanage > model2change){
                        return true
                    }
                }
                return false;
            })
        }
        self.stockListView.reloadData()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    @IBAction func dateRefreshButtonTap(_ sender: Any) {
        self.stockList.removeAll()
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if let startDate = self.startDateTextfield.text, let endDate = self.endDateTextfield.text {
            StockManager.shared.checkEpsChange(startDate: startDate, endDate: endDate, completeHandler: { list in
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                list.allKeys.forEach({ stockName in
                    let value = list.object(forKey: stockName) as! NSMutableDictionary
                    let model = StockEpsViewModel()
                    model.stockName = stockName as! String
                    model.thisYearEpsChanges = value.object(forKey: "201712") as? Double
                    model.nextYearEpsChanges = value.object(forKey: "201812") as? Double
                    model.yearAfterNextEpsChanges = value.object(forKey: "201912") as? Double
                    self.stockList.append(model)
                })
                self.stockListView.reloadData()
            })
        }
        else{
            self.activityIndicator.stopAnimating()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "stockepscell") as! StockEpsCell
        let model = self.stockList[indexPath.row]
        cell.nextYear.backgroundColor = UIColor.clear
        cell.yearAfter.backgroundColor = UIColor.clear
        cell.stockname.text = "\(model.stockName)"
        if let nextYear = model.nextYearEpsChanges {
            if(nextYear > 0){
                cell.nextYear.backgroundColor = UIColor.red
            }
            else if(nextYear < 0 ){
                cell.nextYear.backgroundColor = UIColor.green
            }
            cell.nextYear.text = String(format:"%0.2f%%",nextYear)
        }
        if let yearAfter = model.yearAfterNextEpsChanges {
            if(yearAfter > 0){
                cell.yearAfter.backgroundColor = UIColor.red
            }
            else if(yearAfter < 0 ){
                cell.yearAfter.backgroundColor = UIColor.green
            }
            cell.yearAfter.text = String(format:"%0.2f%%",yearAfter)
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
