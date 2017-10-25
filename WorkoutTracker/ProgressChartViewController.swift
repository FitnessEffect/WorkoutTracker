//
//  ProgressChartViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 10/24/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Charts

class ProgressChartViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var dataInputBtn: UIButton!
    
    var weightValues = [210,200,215,220]
    var lineChartEntry = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if weightValues.count == 0{
            chartView.noDataText = "No Values"
            chartView.noDataFont = UIFont(name: "DJBCHALKITUP", size: 23)
        }else{
            createChart(weightValues: weightValues)
        }
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
    }

    @IBAction func inputData(_ sender: UIButton) {
        let xPosition = dataInputBtn.frame.minX + (dataInputBtn.frame.width/2)
        let yPosition = dataInputBtn.frame.maxY - 25
        
        let currentController = self.getCurrentViewController()
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "progressPickerVC") as! ProgressPickerViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = currentController?.view
        popController.preferredContentSize = CGSize(width: 300, height: 210)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        if dataInputBtn.titleLabel?.text == "Weight"{
            popController.setTag(tag: 1)
        }
        
        // present the popover
        currentController?.present(popController, animated: true, completion: nil)
    }
    
    func getCurrentViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
