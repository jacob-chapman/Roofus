//
//  HomeViewController.swift
//  Roofus
//
//  Created by Jacob Chapman on 1/17/18.
//  Copyright © 2018 AireCodes. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController : UIViewController {
    
    var tableView = UITableView()
    var dataSource = TickerTableViewDataSource()
    var coinMarketClient = MarketApiClient()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(TickerTableViewCell.self, forCellReuseIdentifier: TickerTableViewCell.cellIdentifier)
        tableView.dataSource = dataSource
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.top).offset(15)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Ticker.tickers(with: coinMarketClient) { tickers in
            DispatchQueue.main.async {
                self.dataSource.tickers = tickers
                self.tableView.reloadData()
            }
        }
        
    }
}


class TickerTableViewDataSource : NSObject, UITableViewDataSource {

    var tickers: [Ticker] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TickerTableViewCell.cellIdentifier, for: indexPath) as? TickerTableViewCell

        let item = tickers[indexPath.row]
        
        cell?.bind(with: item)
        
        return cell!
    }
}

class TickerTableViewCell : UITableViewCell {
    
    var tickerName = UILabel()
    var tickerSymbol = UILabel()
    var tickerPrice = UILabel()
    
    static let cellIdentifier = "tickerTableCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tickerName.textColor = UIColor.black
        tickerSymbol.textColor = UIColor.black
        tickerPrice.textColor = UIColor.black
        
        self.contentView.addSubview(tickerName)
        self.contentView.addSubview(tickerSymbol)
        self.contentView.addSubview(tickerPrice)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        
        super.updateConstraints()
        
        tickerName.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(self.contentView.snp.left)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        tickerSymbol.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(self.tickerName.snp.right).offset(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        tickerPrice.snp.makeConstraints {(make) -> Void in
            make.right.equalTo(self.contentView.snp.right)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
    }
    
    public func bind(with ticker: Ticker){
        tickerName.text = ticker.name
        tickerSymbol.text = ticker.symbol
        tickerPrice.text = ticker.priceUSD
    }
}
