//
//  ProgressChartViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 10/24/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Charts

class ProgressChartViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    
    //weak var axisFormatDelegate: IAxisValueFormatter?
    //weak var yAxisFormatDelegate: IAxisValueFormatter?
    
    var weightValues = [210,200,215,220]
    var lineChartEntry = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        axisFormatDelegate = self
        
        if weightValues.count == 0{
            chartView.noDataText = "No Values"
            chartView.noDataFont = UIFont(name: "DJBCHALKITUP", size: 23)
            
        }else{
            createChart(weightValues: weightValues)
        }

        // Do any additional setup after loading the view.
    }
    
    func createChart(weightValues:[Int]){
        
        
        chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.axisMinimum = 0.0
        chartView.legend.enabled = false
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.leftAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 10)!
        chartView.rightAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 10)!

        for i in 0..<weightValues.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(weightValues[i]))
            lineChartEntry.append(dataEntry)
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Weight")
        line1.setColor(NSUIColor.blue)
        
        let data = LineChartData()
        
        data.addDataSet(line1)
        data.setValueFont(NSUIFont(name: "DJBCHALKITUP", size: 10))
        data.setValueTextColor(NSUIColor.white)
        chartView.data = data
        
        //let xaxis = chartView.xAxis
        //xaxis.labelCount = weightValues.count
        
       // chartView.chartDescription?.text = "Weight"
//
//        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Duration")
//        chartDataSet.colors = [UIColor(red: 255/255, green: 122/255, blue: 21/255, alpha: 1)]
//        let chartData = BarChartData(dataSet: chartDataSet)
//        barChartView.data = chartData
//        let xaxis = barChartView.xAxis
//        xaxis.valueFormatter = axisFormatDelegate
    }

    @IBAction func inputData(_ sender: UIButton) {
        
    }
}
