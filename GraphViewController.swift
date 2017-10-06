//
//  GraphViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 10/5/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    weak var yAxisFormatDelegate: IAxisValueFormatter?
    var weekTimes:[Double]! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormatDelegate = self
        
        if weekTimes.count == 0{
            barChartView.noDataText = "No entries saved."
            barChartView.noDataFont = UIFont(name: "Gill Sans", size: 20)
        }else{
            setChart(values: weekTimes)
        }
    }
    
    func setChart(values: [Double]) {
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelPosition = .bottom
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.rightAxis.axisMinimum = 0.0
        barChartView.isUserInteractionEnabled = false
        barChartView.drawGridBackgroundEnabled = true
        barChartView.gridBackgroundColor = UIColor.white
        barChartView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<weekTimes.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Duration")
        chartDataSet.colors = [UIColor(red: 255/255, green: 122/255, blue: 21/255, alpha: 1)]
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: axisFormatDelegate
extension GraphViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var days = ["Fri", "Sat", "Sun", "Mon", "Tue", "Wed", "Thu"]
        return days[Int(value)]
    }
}

