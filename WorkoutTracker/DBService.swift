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
    private var _userStats = [String:Any]()
    private var _clients = [Client]()
    private var _passedExercise:Exercise? = Exercise()
    private var _passedClient = Client()
    private var _currentKey = ""
    private var _exercisesForClient = [Exercise]()
    private var _exercisesForUser = [Exercise]()
    private var _categoryPassed = ""
    private var _exercisesForBodybuildingCategory = [String]()
    private var _exercisesForCrossfitCategory = [String]()
    private var _exercisesForEnduranceCategory = [String]()
    private var _crossfitCategories = [String]()
    private var _bodybuildingCategories = [String]()
    private var _enduranceCategories = [String]()
    private var _challengeExercises = [Exercise]()
    private var _typePassed:String!
    private var _emomTime:String!
    private var _tabataTime:String!
    private var _crossfitHeroWods = [String]()
    
    private init() {
        initDatabase()
    }
    
    private func initDatabase() {
        _ref = FIRDatabase.database().reference()
    }
    
    func initUser() {
        if let u = FIRAuth.auth()?.currentUser {
            _user = u
            
//            retrieveClients(completion: {
//               self.sortClients()
//            })
            
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
    
    func sortClients(){
        self._clients.sort(by: {a, b in
            if a.firstName < b.firstName {
                return true
            }
            return false
        })
    }
    
    func updateNewClient(newClient: [String:Any], completion:@escaping ()->Void) {
        _ref.child("users").child(_user.uid).child("Clients").child(newClient["clientKey"] as! String).updateChildValues(newClient)
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
    
    func updateProfileStats(newStats: [String:Any], completion:@escaping ()->Void) {
        _ref.child("users").child(_user.uid).child("Profile").updateChildValues(newStats)
        completion()
    }
    
    func retrieveUserStats(completion:@escaping ()->Void){
        _ref.child("users").child(_user.uid).child("Profile").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                self._userStats["age"] = value?["age"] as! String
                self._userStats["feet"] = value?["feet"] as! String
                self._userStats["inches"] = value?["inches"] as! String
                self._userStats["weight"] = value?["weight"] as! String
                completion()
            }
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
    
    func setEmomTime(time:String){
        _emomTime = time
    }
    
    func setTabataTime(time:String){
        _tabataTime = time
    }
    
    func createEnduranceExercise(dictionary:[String:Any]){
        self._ref.child("users").child(user.uid).child("Types").child("Endurance").child(categoryPassed).updateChildValues(dictionary)
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
    
    func createEnduranceCategories(dictionary:[String:Any]){
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
    
    func retrieveEnduranceCategories(completion: @escaping () -> Void){
        _enduranceCategories.removeAll()
        
        _ref.child("users").child(user.uid).child("Types").child("Endurance").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                self._enduranceCategories = keyArray
                self._enduranceCategories.sort()
                completion()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveEnduranceCategoryExercises(completion: @escaping () -> Void){
        _exercisesForEnduranceCategory.removeAll()
        
        _ref.child("users").child(user.uid).child("Types").child("Endurance").child(categoryPassed).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                self._exercisesForEnduranceCategory = keyArray
                self._exercisesForEnduranceCategory.sort()
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveClientInfo(lastName:String)->Client{
        let c = Client()
        for client in _clients{
            if client.lastName == lastName{
                return client
            }
        }
        return c
    }
    
    func retrieveClientInfoByFullName(fullName:String)->Client{
        let c = Client()
        for client in _clients{
            if (client.firstName + " " + client.lastName) == fullName{
                return client
            }
        }
        return c
    }
    
    
    func retrieveClients(completion: @escaping () -> Void){
        _clients.removeAll()
        _ref.child("users").child(user.uid).child("Clients").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                self._clients.removeAll()
                for key in keyArray{
                    let client = value?[key] as? NSDictionary
                    let c = Client()
                    c.firstName = client?["firstName"] as! String
                    c.lastName = client?["lastName"] as! String
                    c.gender = client?["gender"] as! String
                    c.age = client?["age"] as! String
                    c.clientKey = client?["clientKey"] as! String
                    c.activityLevel = client?["activityLevel"] as! String
                    c.weight = client?["weight"] as! String
                    c.feet = client?["feet"] as! String
                    c.inches = client?["inches"] as! String
                    self._clients.append(c)
                    completion()
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
    
    func retrieveHeroWods(completion: @escaping () -> Void){
        _crossfitHeroWods.removeAll()
        
        self._ref.child("hero wods").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                self._crossfitHeroWods = keyArray
                self._crossfitHeroWods.sort()
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveWodDescription(wodName:String, completion:@escaping (String)->Void){
        self._ref.child("hero wods").child(wodName).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    func deleteEnduranceCategory(category:String){
        self._ref.child("users").child(self.user.uid).child("Types").child("Endurance").child(category).removeValue { (error, ref) in
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
    
    func setPassedClientToPersonal(){
        _passedClient.firstName = "Personal"
    }
    
    func initializeData(){
        //set notifications to 0
        updateNotifications(num: 0)
        
        var enduranceDictionary = [String:Any]()
        enduranceDictionary["Running"] = true
        enduranceDictionary["Cycling"] = true
        enduranceDictionary["Rowing"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Endurance").updateChildValues(enduranceDictionary)
        
        var crossfitDictionary = [String:Any]()
        crossfitDictionary["1 Rep Max"] = true
        crossfitDictionary["Amrap"] = true
        crossfitDictionary["Emom"] = true
        crossfitDictionary["Metcon"] = true
        crossfitDictionary["Tabata"] = true
        crossfitDictionary["For Time"] = true
        crossfitDictionary["Hero Wods"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Crossfit").updateChildValues(crossfitDictionary)
        
        var oneRepMaxDictionary = [String:Any]()
        oneRepMaxDictionary["Deadlift"] = true
        oneRepMaxDictionary["Squat"] = true
        oneRepMaxDictionary["Front Squats"] = true
        oneRepMaxDictionary["Snatch"] = true
        oneRepMaxDictionary["Clean and Jerk"] = true
        oneRepMaxDictionary["Bench Press"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Crossfit").child("1 Rep Max").updateChildValues(oneRepMaxDictionary)
        
        var bodybuildingDictionary = [String:Any]()
        bodybuildingDictionary["Abs"] = true
        bodybuildingDictionary["Chest"] = true
        bodybuildingDictionary["Legs"] = true
        bodybuildingDictionary["Biceps"] = true
        bodybuildingDictionary["Triceps"] = true
        bodybuildingDictionary["Back"] = true
        bodybuildingDictionary["Shoulders"] = true
        bodybuildingDictionary["Superset"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").updateChildValues(bodybuildingDictionary)
        
        var bodybuildingAbsExercise = [String:Any]()
        bodybuildingAbsExercise["Bicycle Crunches"] = true
        bodybuildingAbsExercise["Hanging Knee Raises"] = true
        bodybuildingAbsExercise["Sit-Ups"] = true
        bodybuildingAbsExercise["Russian Twists"] = true
        bodybuildingAbsExercise["Decline Sit-Ups"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").child("Abs").updateChildValues(bodybuildingAbsExercise)
        
        var bodybuildingChestExercise = [String:Any]()
        bodybuildingChestExercise["Dumbbell Press"] = true
        bodybuildingChestExercise["Incline Dumbbell Press"] = true
        bodybuildingChestExercise["Decline Dumbbell Press"] = true
        bodybuildingChestExercise["Bench Press"] = true
        bodybuildingChestExercise["Dumbbell Flies"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").child("Chest").updateChildValues(bodybuildingChestExercise)
        
        var bodybuildingLegsExercise = [String:Any]()
        bodybuildingLegsExercise["Deadlift"] = true
        bodybuildingLegsExercise["Squats"] = true
        bodybuildingLegsExercise["Leg Press"] = true
        bodybuildingLegsExercise["Smith Machine Squats"] = true
        bodybuildingLegsExercise["Barbell Lunges"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").child("Legs").updateChildValues(bodybuildingLegsExercise)
        
        var bodybuildingBicepsExercise = [String:Any]()
        bodybuildingBicepsExercise["Dumbbell Alternating Curls"] = true
        bodybuildingBicepsExercise["Hammer Curls"] = true
        bodybuildingBicepsExercise["Barbell Curls"] = true
        bodybuildingBicepsExercise["Close grip Easy Bar Curls"] = true
        bodybuildingBicepsExercise["Seated Dumbbell Preacher Curls"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").child("Biceps").updateChildValues(bodybuildingBicepsExercise)
        
        var bodybuildingTricepsExercise = [String:Any]()
        bodybuildingTricepsExercise["Seated Extensions"] = true
        bodybuildingTricepsExercise["Incline Barbell Skull Crushers"] = true
        bodybuildingTricepsExercise["Cable Pull Downs"] = true
        bodybuildingTricepsExercise["Dumbbell Skull Crushers"] = true
        bodybuildingTricepsExercise["Cable Pull Downs reverse grip"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").child("Triceps").updateChildValues(bodybuildingTricepsExercise)
        
        var bodybuildingBackExercise = [String:Any]()
        bodybuildingBackExercise["Single Arm Dumbbell Rows"] = true
        bodybuildingBackExercise["Bent Over Barbell Row"] = true
        bodybuildingBackExercise["Lat Pulldown"] = true
        bodybuildingBackExercise["Seated Row Close Grip"] = true
        bodybuildingBackExercise["Seated Row Wide Grip"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").child("Back").updateChildValues(bodybuildingBackExercise)
        
        var bodybuildingShouldersExercise = [String:Any]()
        bodybuildingShouldersExercise["Dumbbell Lateral Raises"] = true
        bodybuildingShouldersExercise["Barbell High Pulls"] = true
        bodybuildingShouldersExercise["Shoulder Press"] = true
        bodybuildingShouldersExercise["Dumbbell Front Raises "] = true
        bodybuildingShouldersExercise["Arnold Press"] = true
        self._ref.child("users").child(user.uid).child("Types").child("Bodybuilding").child("Shoulders").updateChildValues(bodybuildingShouldersExercise)
    }
    
    var user: FIRUser {
        get {
            return _user
        }
    }
    
    var userStats: [String:Any]{
        get{
            return _userStats
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
    
    var enduranceCategories:[String]{
        get{
            return _enduranceCategories
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
    
    var exercisesForEnduranceCategory:[String]{
        get{
            return _exercisesForEnduranceCategory
        }
    }
    
    var challengeExercises:[Exercise]{
        get{
            return _challengeExercises
        }
    }
    
    var emomTime:String{
        get{
            return _emomTime
        }
    }
    
    var tabataTime:String{
        get{
            return _tabataTime
        }
    }
    
    var crossfitHeroWods:[String]{
        get{
            return _crossfitHeroWods
        }
    }
}
