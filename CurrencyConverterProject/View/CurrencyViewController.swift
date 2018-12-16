//
//  ViewController.swift
//  CurrencyConverterProject
//
//  Created by Margarita Zherikhova on 16/12/2018.
//  Copyright © 2018 Margarita Zherikhova. All rights reserved.
//

import UIKit

final class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView! 
    
    var viewModel =  CurrencyViewModel()
    
    @IBAction func rateChanged(_ sender: UITextField) {
        viewModel.primaryRate.amount = Double(sender.text!) ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "£ Exchange rate"
        
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.data.addAndNotify(observer: self) { [weak self] in
            guard let `self` = self else { return }
            if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.filter({ $0.row != 0 }),
                !visibleIndexPaths.isEmpty {
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: visibleIndexPaths, with: .automatic)
                self.tableView.endUpdates()
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startAutoUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopAutoUpdate()
    }
}

extension CurrencyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = viewModel.data.value[indexPath.row]
        if viewModel.primaryRate.currency != selected.currency {
            let zeroIndexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: zeroIndexPath, at: .top, animated: false)
            tableView.beginUpdates()
            tableView.moveRow(at: indexPath, to: zeroIndexPath)
            tableView.endUpdates()
            viewModel.primaryRate = selected
        }
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CurrencyCell
        cell?.rateTextField.becomeFirstResponder()
    }
}

extension CurrencyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CurrencyCell.self, for: indexPath)
        let item = viewModel.data.value[indexPath.row]
        cell.currencyLabel.text = item.currency.title
        cell.rateTextField.text = "\(item.amount)"
        return cell
    }
}
