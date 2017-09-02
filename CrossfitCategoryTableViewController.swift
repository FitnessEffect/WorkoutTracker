//
//  CrossfitWorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/14/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class CrossfitCategoryTableViewController: UITableViewController {
    
    var categories = [String]()
    var typePassed:String!
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePassed = "Crossfit"
        title = typePassed
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        spinner.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
        DispatchQueue.global(qos: .userInteractive).async {
            DBService.shared.retrieveCrossfitCategories(completion: {
                UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                self.spinner.stopAnimating()
                self.categories = DBService.shared.crossfitCategories
                self.tableView.reloadData()
            })
        }
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if tableView.frame.contains(sender.location(in: view)){
            cellClicked(x: sender.location(in: view))
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "crossfitCell")!
        cell.textLabel?.text = self.categories[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        return cell
    }
    
    func cellClicked(x:CGPoint){
        if let index = tableView.indexPathForRow(at: x){
            let cell = tableView.cellForRow(at: index)!
            if cell.textLabel?.text == "1 Rep Max" || cell.textLabel?.text == "Hero Wods"{
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "heroWodsVC") as! HeroWodsViewController
                let title = cell.textLabel?.text
                DBService.shared.setCategory(category: title!)
                nextVC.setCategory(category:title!)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else if cell.textLabel?.text == "For Time"{
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectExerciseForForTimeVC") as! SelectExerciseForForTimeViewController
                let title = cell.textLabel?.text
                DBService.shared.setCategory(category: title!)
                nextVC.setCategory(category:title!)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else if cell.textLabel?.text == "Tabata"{
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectExerciseForTabataVC") as! SelectExerciseForTabataViewController
                let title = cell.textLabel?.text
                DBService.shared.setCategory(category: title!)
                nextVC.setCategory(category:title!)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else if cell.textLabel?.text == "Metcon"{
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectExerciseForMetconVC") as! SelectExerciseForMetconViewController
                let title = cell.textLabel?.text
                DBService.shared.setCategory(category: title!)
                nextVC.setCategory(category:title!)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else{
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectExerciseForAmrapVC") as! SelectExerciseForAmrapViewController
                let title = cell.textLabel?.text
                DBService.shared.setCategory(category: title!)
                nextVC.setCategory(category:title!)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
