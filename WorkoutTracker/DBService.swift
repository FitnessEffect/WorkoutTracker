//
//  DBService.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/7/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Foundation
import Firebase

class DBService {
    
    static let shared = DBService()
    
    private var _ref: FIRDatabaseReference!
    private var _user: FIRUser!
    private var _clients = [Client]()
    private var _passedExercise:Exercise? = Exercise()
    private var _passedClient = Client()
    private var _currentKey = ""
    private var _exercisesForClient = [Exercise]()
    private var _exercisesForUser = [Exercise]()
    private var _categoryPassed = ""
    private var _exercisesForBodybuildingCategory = [String]()
    private var _exercisesForCrossfitCategory = [String]()
    private var _crossfitCategories = [String]()
    private var _bodybuildingCategories = [String]()
    private var _challengeExercises = [Exercise]()
    private var _typePassed:String!
    
    private init() {
        initDatabase()
        initUser()
    }
    
    private func initDatabase() {
        _ref = FIRDatabase.database().reference()
    }
    
    private func initUser() {
        if let user = FIRAuth.auth()?.currentUser {
            _user = user
            
            retrieveClients(completion: {
                self._clients.sort(by: {a, b in
                    if a.firstName < b.firstName {
                        return true
                    }
                    return false
                })
            })
            
            retrieveExercisesForUser(completion: {
                self._exercisesForUser.sort(by: {a, b in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let dateA = dateFormatter.date(from: a.date)!
                    let dateB = dateFormatter.date(from: b.date)!
                    if dateA > dateB {
                        return true
                    }
                    return false
                })
            })
        }
    }
    
    //automatically called when user logs in or out
    func setUser(completion handler: (FIRUser?, String?) -> Void) {
        if let user = FIRAuth.auth()?.currentUser {
            _user = user
            handler(user, nil)
            return
        }
        // if they are nil...
        handler(nil, "No user logged in")
    }
    
    func createNewClient(newClient: [String:Any], completion:@escaping ()->Void) {
        _ref.child("users").child(_user.uid).child("Clients").child(currentkey).setValue(newClient)
        retrieveClients(completion: {
            self._clients.sort(by: {a, b in
                if a.firstName < b.firstName {
                    return true
                }
                return false
            })
            completion()
        })
    }
    
    func saveChallengeExercise(exerciseDictionary:[String:Any]){
        self._ref.child("users").child(user.uid).child("Challenges").child(exerciseDictionary["exerciseKey"] as! String).setValue(exerciseDictionary)
    }
    
    func updateExerciseForClient(exerciseDictionary:[String:Any], completion: () -> Void){
        self._ref.child("users").child(self.user.uid).child("Clients").child(passedClient.clientKey).child("Exercises").child(exerciseDictionary["exerciseKey"] as! String).updateChildValues(exerciseDictionary)
        completion()
    }
    
    func createExerciseKey() -> String{
        let str = _ref.child("users").child(user.uid).child("Exercises").childByAutoId().key
        _currentKey = str
        return str
    }
    
    func createClientID() -> String{
        let str = _ref.child("users").child(user.uid).child("Clients").childByAutoId().key
        _currentKey = str
        return str
    }
    
    func updateExerciseForUser(exerciseDictionary:[String:Any], completion: () -> Void) {
        self._ref.child("users").child(user.uid).child("Exercises").child(exerciseDictionary["exerciseKey"] as! String).updateChildValues(exerciseDictionary)
        completion()
    }
    
    func clearCurrentKey(){
        _currentKey = ""
    }
    
    func getIDforClient(id:String) -> String{
        let str = ""
        return str
    }
    
    func setPassedExercise(exercise:Exercise){
        _passedExercise = exercise
    }
    
    func setPassedClient(client:Client){
        _passedClient = client
    }
    
    func setCategory(category:String){
        _categoryPassed = category
    }
    
    func setPassedType(type:String){
        _typePassed = type
    }
    
    func createCrossfitExercise(dictionary:[String:Any]){
        self._ref.child("users").child(user.uid).child("Types").child("Crossfit").child(categoryPassed).updateChildValues(dictionary)
    }
    
    func createBodybuildingExercise(dictionary:[String:Any]){
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").child(categoryPassed).updateChildValues(dictionary)
    }
    
    func createBodybuildingCategories(dictionary:[String:Any]){
        self._ref.child("users").child(user.uid).child("Types").child(_typePassed).updateChildValues(dictionary)
    }
    
    func retrieveExercisesForUser(completion: @escaping () -> Void){
        _exercisesForUser.removeAll()
        
        _ref.child("users").child(user.uid).child("Exercises").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            if let exercisesVal = snapshot.value as? [String: [String: AnyObject]] {
                for exercise in exercisesVal {
                    let tempExercise = Exercise()
                    tempExercise.name = exercise.value["name"] as! String
                    tempExercise.exerciseDescription = exercise.value["description"] as! String
                    tempExercise.result = exercise.value["result"] as! String
                    tempExercise.exerciseKey = exercise.value["exerciseKey"] as! String
                    tempExercise.date = exercise.value["date"] as! String
                    tempExercise.client = exercise.value["client"] as! String
                    tempExercise.opponent = exercise.value["opponent"] as! String
                    tempExercise.creatorEmail = exercise.value["creatorEmail"] as! String
                    tempExercise.creatorID = exercise.value["creatorID"] as! String
                    tempExercise.category = exercise.value["category"] as! String
                    tempExercise.type = exercise.value["type"] as! String
                    self._exercisesForUser.append(tempExercise)
                    completion()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveBodybuildingCategoryExercises(completion: @escaping () -> Void){
        _exercisesForBodybuildingCategory.removeAll()
        
        _ref.child("users").child(user.uid).child("Types").child("Bodybuilding").child(categoryPassed).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                self._exercisesForBodybuildingCategory = keyArray
                self._exercisesForBodybuildingCategory.sort()
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveCrossfitCategories(completion: @escaping () -> Void){
        _crossfitCategories.removeAll()
        
        _ref.child("users").child(user.uid).child("Types").child("Crossfit").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                self._crossfitCategories = keyArray
                self._crossfitCategories.sort()
                completion()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveCrossfitCategoryExercises(completion: @escaping () -> Void){
        _exercisesForCrossfitCategory.removeAll()
        
        _ref.child("users").child(user.uid).child("Types").child("Crossfit").child(categoryPassed).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                
                self._exercisesForCrossfitCategory = keyArray
                self._exercisesForCrossfitCategory.sort()
                
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveBodybuildingCategories(completion: @escaping () -> Void){
        _bodybuildingCategories.removeAll()
        
        _ref.child("users").child(user.uid).child("Types").child("Bodybuilding").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                self._bodybuildingCategories = keyArray
                self._bodybuildingCategories.sort()
                completion()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveClients(completion: @escaping () -> Void){
        _clients.removeAll()
        
        _ref.child("users").child(user.uid).child("Clients").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                for client in keyArray{
                    self._ref.child("users").child(self.user.uid).child("Clients").child(client).observeSingleEvent(of: .value, with: { (snapshot) in
                        let client = snapshot.value as? NSDictionary
                        let c = Client()
                        c.firstName = client?["firstName"] as! String
                        c.lastName = client?["lastName"] as! String
                        c.gender = client?["gender"] as! String
                        c.age = client?["age"] as! String
                        c.clientKey = client?["clientKey"] as! String
                        self._clients.append(c)
                        completion()
                    })
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveExercisesForClient(completion:@escaping ()-> Void){
        _exercisesForClient.removeAll()
        
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("Exercises").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let exercisesVal = snapshot.value as? [String: [String: AnyObject]] {
                for exercise in exercisesVal {
                    
                    let tempExercise = Exercise()
                    tempExercise.name = exercise.value["name"] as! String
                    tempExercise.exerciseDescription = exercise.value["description"] as! String
                    tempExercise.result = exercise.value["result"] as! String
                    tempExercise.exerciseKey = exercise.value["exerciseKey"] as! String
                    tempExercise.date = exercise.value["date"] as! String
                    tempExercise.client = exercise.value["client"] as! String
                    tempExercise.opponent = exercise.value["opponent"] as! String
                    tempExercise.creatorEmail = exercise.value["creatorEmail"] as! String
                    tempExercise.creatorID = exercise.value["creatorID"] as! String
                    tempExercise.category = exercise.value["category"] as! String
                    tempExercise.type = exercise.value["type"] as! String
                    self._exercisesForClient.append(tempExercise)
                    completion()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveChallengesExercises(completion:@escaping ()->Void){
        _challengeExercises.removeAll()
        
        _ref.child("users").child(user.uid).child("Challenges").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // let value = snapshot.value as! NSDictionary
            if let exercisesVal = snapshot.value as? [String: [String: AnyObject]] {
                for exercise in exercisesVal {
                    
                    let tempExercise = Exercise()
                    tempExercise.name = exercise.value["name"] as! String
                    tempExercise.exerciseDescription = exercise.value["description"] as! String
                    tempExercise.result = exercise.value["result"] as! String
                    tempExercise.exerciseKey = exercise.value["exerciseKey"] as! String
                    tempExercise.date = exercise.value["date"] as! String
                    tempExercise.date = exercise.value["date"] as! String
                    tempExercise.client = exercise.value["client"] as! String
                    tempExercise.opponent = exercise.value["opponent"] as! String
                    tempExercise.creatorEmail = exercise.value["creatorEmail"] as! String
                    tempExercise.creatorID = exercise.value["creatorID"] as! String
                    tempExercise.category = exercise.value["category"] as! String
                    tempExercise.type = exercise.value["type"] as! String
                    self._challengeExercises.append(tempExercise)
                    completion()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveWod(wodName:String, completion:@escaping (String)->Void){
        self._ref.child("wods").child(wodName).observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let str = value?["description"] as! String
            completion(str)
        })
    }
    
    func deleteClient(id:String){
        self._ref.child("users").child(user.uid).child("Clients").child(id).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func deleteExerciseForClient(id:String){
        self._ref.child("users").child(self.user.uid).child("Clients").child(passedClient.clientKey).child("Exercises").child(id).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func deleteExerciseForUser(id:String){
        self._ref.child("users").child(self.user.uid).child("Exercises").child(id).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func deleteChallengeExerciseForUser(id:String){
        self._ref.child("users").child(self.user.uid).child("Challenges").child(id).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func deleteCategory(category:String){
        self._ref.child("users").child(self.user.uid).child("Types").child("Bodybuilding").child(category).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func updateNotifications(num:Int){
        let formattedEmail = Formatter.formateEmail(email: self.user.email!)
        var dictionary = [String:Any]()
        dictionary[formattedEmail] = num
        self._ref.child("notification").updateChildValues(dictionary)
        UIApplication.shared.applicationIconBadgeNumber = num
    }

    
    func clearExercisePassed(){
        _passedExercise?.exerciseKey = ""
    }
    
    func initializeData(){
        //set notifications to 0
        updateNotifications(num: 0)
        //set pickerView categories
        
        var crossfitDictionary = [String:Any]()
        crossfitDictionary["1 Rep Max"] = true
        crossfitDictionary["Amrap"] = true
        crossfitDictionary["Emom"] = true
        crossfitDictionary["Metcon"] = true
        crossfitDictionary["Tabata"] = true
        crossfitDictionary["Wods"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Crossfit").updateChildValues(crossfitDictionary)
        
        var wodDictionary = [String:Any]()
        wodDictionary["Murph"] = true
        wodDictionary["Grace"] = true
        wodDictionary["Fran"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Crossfit").child("Wods").updateChildValues(wodDictionary)
        
        var bodybuildingDictionary = [String:Any]()
        bodybuildingDictionary["Abs"] = true
        bodybuildingDictionary["Chest"] = true
        bodybuildingDictionary["Legs"] = true
        bodybuildingDictionary["Arms"] = true
        bodybuildingDictionary["Back"] = true
        bodybuildingDictionary["Shoulders"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").updateChildValues(bodybuildingDictionary)
    }
    
    var user: FIRUser {
        get {
            return _user
        }
    }
    
    var clients: [Client]{
        get{
            return _clients
        }
    }
    
    var passedExercise: Exercise{
        get{
            return _passedExercise!
        }
    }
    
    var passedClient: Client{
        get{
            return _passedClient
        }
    }
    
    var currentkey:String{
        get{
            return _currentKey
        }
    }
    
    var exercisesForClient:[Exercise]{
        get{
            return _exercisesForClient
        }
    }
    
    var exercisesForUser:[Exercise]{
        get{
            return _exercisesForUser
        }
    }
    
    var categoryPassed:String{
        get{
            return _categoryPassed
        }
    }
    
    var crossfitCategories:[String]{
        get{
            return _crossfitCategories
        }
    }
    
    var bodybuildingCategories:[String]{
        get{
            return _bodybuildingCategories
        }
    }
    
    var exercisesForBodybuildingCategory:[String]{
        get{
            return _exercisesForBodybuildingCategory
        }
    }
    
    var exercisesForCrossfitCategory:[String]{
        get{
            return _exercisesForCrossfitCategory
        }
    }
    
    var challengeExercises:[Exercise]{
        get{
            return _challengeExercises
        }
    }
}


