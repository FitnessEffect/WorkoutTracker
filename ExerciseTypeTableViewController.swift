//
//  ExerciseTypeTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/14/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class ExerciseTypeTableViewController: UITableViewController{
    
    var exerciseTypes = [String]()
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))
        self.tableView.backgroundView?.alpha = 0.1
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        
        spinner.frame = CGRect(x:125, y:125, width:50, height:50)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinner.color = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        spinner.alpha = 0
        view.addSubview(spinner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Have a Great Day", size: 22)!,NSAttributedStringKey.foregroundColor: UIColor.darkText]
        
        DBService.shared.clearSupersetExercises()
        let internetCheck = Reachability.isInternetAvailable()
        if internetCheck == false{
            let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            spinner.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
            DispatchQueue.global(qos: .userInteractive).async {
                DBService.shared.retrieveTypes(completion: {
                    UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                    self.spinner.stopAnimating()
                    self.exerciseTypes = DBService.shared.types
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.exerciseTypes[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        
        return cell
    }
    
    @objc func hitTest(_ sender:UITapGestureRecognizer){
        if tableView.frame.contains(sender.location(in: view)){
            cellClicked(x: sender.location(in: view))
        }
    }
    
    func cellClicked(x:CGPoint){
        if let index = tableView.indexPathForRow(at: x){
            let cell = tableView.cellForRow(at: (index))!
            if cell.textLabel?.text == "Bodybuilding"{
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bodybuildingCategoryVC") as! BodybuildingCategoryTableViewController
                DBService.shared.setPassedType(type: "Bodybuilding")
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else if cell.textLabel?.text == "Crossfit"{
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "crossfitVC") as! CrossfitCategoryTableViewController
                DBService.shared.setPassedType(type: "Crossfit")
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else{
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "enduranceCategoryVC") as! EnduranceCategoryTableViewController
                DBService.shared.setPassedType(type: "Endurance")
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
