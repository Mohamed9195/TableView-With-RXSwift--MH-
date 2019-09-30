//
//  ViewController.swift
//  TableViewByRXSWift
//
//  Created by mohamed hashem on 9/30/19.
//  Copyright © 2019 mohamed hashem. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class PersonalData {
    var name: String?
    var age: String?
    
    init(_ name: String, _ age: String) {
        self.name = name
        self.age = age
    }
}

class MockPersonallData {
    var shard: [PersonalData?] = []
    
     func setPersonal() {
        shard.append(PersonalData("mostafa", "12"))
        shard.append(PersonalData("mostafa", "13"))
        shard.append(PersonalData("mostafa", "14"))
        shard.append(PersonalData("mostafa", "15"))
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var RXTable: UITableView!
    
    var behavior = BehaviorSubject<[PersonalData]>(value:[])
    var disposed = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = MockPersonallData()
        data.setPersonal()
        behavior.onNext(data.shard as! [PersonalData])
       
        RXTable.separatorStyle = .none
        setTable()
        selectCell()
        selectmodel()
    }
    
    private func setTable() {
        behavior.bind(to: RXTable.rx.items(cellIdentifier: "celll")) {row, model, cell in
            if let celll = cell as? RXTableCell {
                celll.RXTableLAbel.text = (model.age ?? "   ") + "  " + (model.name ?? "  ")
            }
        }.disposed(by: disposed)
    }
    
    private func selectmodel() {
        RXTable.rx.modelSelected(PersonalData.self).subscribe { (PersonalData) in
            print(PersonalData.element?.age as Any)
        }.disposed(by: disposed)
    }
    
    private func selectCell() {
        RXTable.rx.itemSelected.subscribe { [weak self] (indexPath) in
            guard let index = indexPath.element else {
                return
            }
            
            let cellTable = self?.RXTable.cellForRow(at: index)  as! RXTableCell
            cellTable.RXTableLAbel.text = "Wellcom new Value"
            self?.RXTable.deselectRow(at: index, animated: false)
        }.disposed(by: disposed)
    }
    
    private func selectAccessoris() {
        RXTable.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
               
                let cellTable = self.RXTable.cellForRow(at: indexPath)  as! RXTableCell
                cellTable.RXTableLAbel.text = "Wellcom new aCCESSo"
            }).disposed(by: disposed)
    }
}

