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
    
    @IBOutlet weak var swipeToDeleteLabel: UILabel!
    @IBOutlet weak var arrowsLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var dataInputBtn: UIButton!
    @IBOutlet weak var noValuesLabel: UILabel!
    @IBOutlet weak var chartTitleLabel: UILabel!
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    
    var dataValues = [(key: String, value: String)]()
    var lineChartEntry = [ChartDataEntry]()
    var spinner = UIActivityIndicatorView()
    weak var xAxisFormatDelegate: IAxisValueFormatter?
    var types = [String]()
    var categories = [String]()
    var unit = "lb(s)"
    
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
        leftArrow.alpha = 0
        rightArrow.alpha = 0
        DBService.shared.clearDefautChartTitle()
        dataValues.removeAll()
        types.removeAll()
        categories.removeAll()
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
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
           
            if DBService.shared.passedClient.clientKey != ""{
                DispatchQueue.global(qos: .userInitiated).async {
                    DBService.shared.retrieveClientProgressTypesAndCategories(completion: {
                        self.types = DBService.shared.progressTypes
                        self.types.insert("Weight", at: 0)
                        if self.types.count > 1{
                            self.leftArrow.alpha = 1
                            self.rightArrow.alpha = 1
                        }
                    })
                }
                if dataInputBtn.titleLabel?.text == "Weight"{
                  setClientWeightGraph()
                }else{
                    setClientDefaultGraph()
                }
            }else{
                DispatchQueue.global(qos: .userInitiated).async {
                    DBService.shared.retrieveUserProgressTypesAndCategories(completion: {
                        self.types = DBService.shared.progressTypes
                        self.types.insert("Weight", at: 0)
                        if self.types.count > 1{
                            self.leftArrow.alpha = 1
                            self.rightArrow.alpha = 1
                        }
                    })
                }
                if dataInputBtn.titleLabel?.text == "Weight"{
                    self.setWeightGraph()
                }else{
                    self.setDefaultGraph()
                }
            }
        }
    }
    
    func setClientWeightGraph(){
        swipeToDeleteLabel.alpha = 1
        arrowsLabel.alpha = 1
         let btnTitle = dataInputBtn.titleLabel?.text
        spinner.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
        DispatchQueue.global(qos: .userInitiated).async {
            DBService.shared.retrieveProgressDataForClient(selection:btnTitle!,completion:{
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
    
    func setWeightGraph(){
        swipeToDeleteLabel.alpha = 1
        arrowsLabel.alpha = 1
        let btnLabel = dataInputBtn.titleLabel?.text
        spinner.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
        DispatchQueue.global(qos: .userInitiated).async {
            DBService.shared.retrieveProgressData(selection:btnLabel!,completion:{
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
    
    func setClientDefaultGraph(){
        swipeToDeleteLabel.alpha = 0
        arrowsLabel.alpha = 0
        let btnLabel = dataInputBtn.titleLabel?.text
        spinner.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
        DispatchQueue.global(qos: .userInitiated).async {
            DBService.shared.retrieveClientExerciseData(type:btnLabel!, completion: {
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
    
    func setDefaultGraph(){
        swipeToDeleteLabel.alpha = 0
        arrowsLabel.alpha = 0
        let btnLabel = dataInputBtn.titleLabel?.text
        spinner.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
        DispatchQueue.global(qos: .userInitiated).async {
            DBService.shared.retrieveExerciseData(type:btnLabel!, completion: {
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
    
    func createChart(values:[(key: String, value: String)]){
        var mutableValues = values
        lineChartEntry.removeAll()
        chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawLabelsEnabled = true
        chartView.xAxis.axisMinimum = 0.0
        chartView.xAxis.axisMaximum = Double(values.count+1)
        chartView.xAxis.labelCount = 4
        chartView.legend.enabled = false
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.leftAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 15)!
        chartView.rightAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 15)!
        chartView.xAxis.labelFont = UIFont(name: "DJBCHALKITUP", size: 15)!
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.granularity = 1
        
        //sort values by time
        mutableValues = mutableValues.sorted(by: {a, b in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-M-d HH:mm:ss"
            let dateA = dateFormatter.date(from: a.key)!
            let dateB = dateFormatter.date(from: b.key)!
            if dateA < dateB {
                return true
            }
            return false
        })
        
        var count = 1
        for element in mutableValues{
            var elementWithoutUnit = element.value.components(separatedBy: " ")
            if elementWithoutUnit.count == 1{
                unit = "min(s)"
                elementWithoutUnit[0] = String(Double(elementWithoutUnit[0])!/60)
            }else{
                unit = elementWithoutUnit[1]
            }
            
            let dataEntry = ChartDataEntry(x: Double(count), y: Double(elementWithoutUnit[0])!)
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
        self.chartTitleLabel.text = DBService.shared.defaultChartTitle
        data.setValueFormatter(MyValueFormatter(unitStr:unit))
    }
    
    func setChartTitle(title:String){
        chartTitleLabel.text = title
    }
    
    @IBAction func inputData(_ sender: UIButton) {
        //clear selected progress category
        DBService.shared.selectedProgressCategory = ""
        //clear selected progress exercise
        DBService.shared.selectedProgressExercise = ""
        //clear selected progress detail
        DBService.shared.selectedProgressDetail = ""
        let xPosition = dataInputBtn.frame.minX + (dataInputBtn.frame.width/2)
        let yPosition = dataInputBtn.frame.maxY - 15
        let currentController = self.getCurrentViewController()
        
        if dataInputBtn.titleLabel?.text == "Weight"{
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
            
            popController.setTag(tag: 1)
            
            // present the popover
            currentController?.present(popController, animated: true, completion: nil)
        }else{
            // get a reference to the view controller for the popover
            let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerSelectionVC") as! ProgressPickerSelectionViewController
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = currentController?.view
            popController.preferredContentSize = CGSize(width: 300, height: 480)
            
            popController.setType(type:(dataInputBtn.titleLabel?.text)!)
            popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
            
            // present the popover
            currentController?.present(popController, animated: true, completion: nil)
        }
    }

    @IBAction func arrowBtns(_ sender: UIButton) {
        DBService.shared.clearDefautChartTitle()
        //clear selected progress category
        DBService.shared.selectedProgressCategory = ""
        //clear selected progress exercise
        DBService.shared.selectedProgressExercise = ""
        //clear selected progress detail
        DBService.shared.selectedProgressDetail = ""
        
        let currentIndex = types.index(of: (dataInputBtn.titleLabel?.text)!)
        if sender.tag == 0{
            if currentIndex == 0{
                dataInputBtn.titleLabel?.text = types[types.count-1]
                dataInputBtn.setTitle(types[types.count-1], for: .normal)
            }else{
                dataInputBtn.titleLabel?.text = types[currentIndex!-1]
                dataInputBtn.setTitle(types[currentIndex!-1], for: .normal)
            }
        }else{
            if currentIndex == types.count-1{
                dataInputBtn.titleLabel?.text = types[0]
                dataInputBtn.setTitle(types[0], for: .normal)
            }else{
                dataInputBtn.titleLabel?.text = types[currentIndex!+1]
                dataInputBtn.setTitle(types[currentIndex!+1], for: .normal)
            }
        }
        
        if dataInputBtn.titleLabel?.text == "Weight"{
            if DBService.shared.passedClient.clientKey != ""{
                setClientWeightGraph()
            }else{
                 setWeightGraph()
            }
        }else{
            if DBService.shared.passedClient.clientKey != ""{
                setClientDefaultGraph()
            }else{
                setDefaultGraph()
            }
        }
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
        if dataInputBtn.titleLabel?.text == "Weight"{
            if sender.direction == .right{
                let deleteProgressDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "deleteProgressDataVC") as! DeleteProgressDataViewController
                deleteProgressDataVC.passDataValues(passedData:dataValues)
                deleteProgressDataVC.passSelection(passedSelection:(dataInputBtn.titleLabel?.text)!)
                self.navigationController?.pushViewController(deleteProgressDataVC, animated: true)
            }
        }
    }
}

// MARK: axisFormatDelegate
extension ProgressChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let valuePassed = value
        if Int(valuePassed) == 0 || Int(valuePassed) > dataValues.count{
            if Int(value) == 1{
                let dataTuple = dataValues[Int(valuePassed)-1]
                let date = dataTuple.key
                let formattedDate = DateConverter.formatFullDateForGraphDisplay(date:date)
                return formattedDate
            }
            return ""
        }else{
            let dataTuple = dataValues[Int(valuePassed)-1]
            let date = dataTuple.key
            let formattedDate = DateConverter.formatFullDateForGraphDisplay(date:date)
            return formattedDate
        }
    }
}

class MyValueFormatter:NSObject, IValueFormatter{
    var unit:String!
    
    init(unitStr:String){
        unit = unitStr
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        var newValue = ""
        if unit == "min(s)"{
            newValue = Formatter.changeTimeToSmallDisplayFormat(minutes: value)
        }else{
            if String(value).contains("."){
                let tempArr = String(value).components(separatedBy: ".")
                    newValue = tempArr[0] + " " + unit
            }else{
                newValue = String(value)
            }
        }
        return newValue
    }
}
