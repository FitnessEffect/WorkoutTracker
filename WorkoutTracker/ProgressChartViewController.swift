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

    @IBOutlet weak var arrowLabel1: UILabel!
    @IBOutlet weak var arrowLabel2: UILabel!
    @IBOutlet weak var arrowLabel3: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var dataInputBtn: UIButton!
    @IBOutlet weak var noValuesLabel: UILabel!
    
    var dataValues = [(key: String, value: String)]()
    var lineChartEntry = [ChartDataEntry]()
    var spinner = UIActivityIndicatorView()
    weak var xAxisFormatDelegate: IAxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noValuesLabel.alpha = 0
        xAxisFormatDelegate = self
        spinner.frame = CGRect(x:(chartView.frame.width/2)-25, y:(chartView.frame.height/2)-25, width:50, height:50)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinner.color = UIColor.white
        spinner.alpha = 0
        chartView.addSubview(spinner)
        let xaxis = chartView.xAxis
        xaxis.valueFormatter = xAxisFormatDelegate
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector (self.swipe(_:)))
        self.view.addGestureRecognizer(swipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noValuesLabel.alpha = 0
        self.chartView.alpha = 1
        let internetCheck = Reachability.isInternetAvailable()
        if internetCheck == false{
            let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            spinner.startAnimating()
            dataValues.removeAll()
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
            let btnTitle = dataInputBtn.titleLabel?.text
            DispatchQueue.global(qos: .userInitiated).async {
                if DBService.shared.passedClient.clientKey != ""{
                    DBService.shared.retrieveProgressDataForClient(selection:btnTitle!,completion:{
                        UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                        self.spinner.stopAnimating()
                        self.dataValues = DBService.shared.progressData
                        self.chartView.reloadInputViews()
                            self.createChart(values: self.dataValues)
                        if self.dataValues.count == 0{
                            self.chartView.alpha = 0
                            self.noValuesLabel.alpha = 1
                        }
                    })
                }else{
                    DBService.shared.retrieveProgressData(selection:btnTitle!,completion:{
                        UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                        self.spinner.stopAnimating()
                        self.dataValues = DBService.shared.progressData
                        
                            self.createChart(values: self.dataValues)
                        if self.dataValues.count == 0{
                            self.chartView.alpha = 0
                            self.noValuesLabel.alpha = 1
                        }
                    })
                }
            }
        }
    }
    
    func createChart(values:[(key: String, value: String)]){
        lineChartEntry.removeAll()

        chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawLabelsEnabled = true
        chartView.xAxis.axisMinimum = 0.0
        chartView.xAxis.axisMaximum = Double(values.count+1)
        chartView.xAxis.labelCount = values.count
        chartView.legend.enabled = false
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.leftAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 18)!
        chartView.rightAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 18)!
        chartView.xAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 15)!
        
        var count = 1
        for element in values{
            let lbsNum = element.value.components(separatedBy: " ")
            let dataEntry = ChartDataEntry(x: Double(count), y: Double(lbsNum[0])!)
            lineChartEntry.append(dataEntry)
            count += 1
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Weight")
        line1.setColor(NSUIColor.blue)
        
        let data = LineChartData()
        data.addDataSet(line1)
        data.setValueFont(NSUIFont(name: "DJBCHALKITUP", size: 18))
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
    
    @objc func swipe(_ sender:UISwipeGestureRecognizer){
        if sender.direction == .right{
        let deleteProgressDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "deleteProgressDataVC") as! DeleteProgressDataViewController
            deleteProgressDataVC.passDataValues(passedData:dataValues)
            deleteProgressDataVC.passSelection(passedSelection:(dataInputBtn.titleLabel?.text)!)
            self.navigationController?.pushViewController(deleteProgressDataVC, animated: true)
        }
    }
}

// MARK: axisFormatDelegate
extension ProgressChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value == 0.0 || value == Double(dataValues.count) + 1{
            return ""
        }
        return String(value)
    }
}
