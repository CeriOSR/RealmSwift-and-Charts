//
//  ViewController.swift
//  Realm with Charts
//
//  Created by Rey Cerio on 2017-05-20.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tfValue: UITextField!
    
    @IBOutlet weak var barView: BarChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?     //declaring x axis delegate
    
    @IBAction func btnAddTapped(_ sender: Any) {
        if let value = tfValue.text, value != "" {
            let visitorCount = VisitorCount()
            visitorCount.count = (NumberFormatter().number(from: value)?.intValue)!
            visitorCount.save()
            tfValue.text = ""
        }
        updateChartsWithData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormatDelegate = self as? IAxisValueFormatter     //assinging a delegate to the x axis of the charts
        updateChartsWithData()
    }
    
    func updateChartsWithData() {            //updating the BarChart
        var dataEntries: [BarChartDataEntry] = []
        let visitorCounts = getVisitorCountsFromDatabase()
        for i in 0..<visitorCounts.count {
            let timeIntervalForDate: TimeInterval = visitorCounts[i].date.timeIntervalSince1970
            let dataEntry = BarChartDataEntry(x: Double(timeIntervalForDate), y: Double(visitorCounts[i].count))
            dataEntries.append(dataEntry)  //assigning the data for both x and y axis
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Visitor count")
        let chartData = BarChartData(dataSet: chartDataSet)
        barView.data = chartData
        
        let xAxis = barView.xAxis   //assigning value for x axis
        xAxis.valueFormatter = axisFormatDelegate

    }
    
    func getVisitorCountsFromDatabase() -> Results<VisitorCount>{   //getting data from Realm database and returning results as type VisitorCount
        do {
            let realm = try Realm()
            return realm.objects(VisitorCount.self)
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}

//Mark: extension for ViewController where we implement the dates into the X Axis.

extension ViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm.ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}



