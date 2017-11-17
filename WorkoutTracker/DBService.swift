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
    private var _types = [String]()
    private var _challengeExercises = [Exercise]()
    private var _typePassed:String!
    private var _emomTime:String!
    private var _tabataTime:String!
    private var _crossfitHeroWods = [String]()
    private var _notificationCount:Int = 0
    private var _supersetExercises = [Exercise]()
    private var _edit = false
    private var _emailCheckBoolean = false
    private var _currentWeekNumber = ""
    private var _currentYear = ""
    private var _selectedDate = ""
    private var _currentDay = ""
    private var _sessions = [Session]()
    private var _sessionsCount = 0
    private var _passedSession = Session()
    private var _passedDate = ""
    private var _dateRange = ""
    private var _exSessionEdit = false
    private var _passToNextVC = false
    private var _progressData = [(key: String, value: String)]()
    private var _progressTypes = [String]()
    private var _progressCategories = [String]()
    private var _progressTypePassed:String!
    private var _progressExerciseNames = [String]()
    private var _defaultChartTitle = ""
    private var _selectedProgressCategory = ""
    private var _selectedProgressExercise = ""
    
    private init() {
        initDatabase()
    }
    
    private func initDatabase() {
        _ref = FIRDatabase.database().reference()
    }
    
    func initUser() {
        setCurrentYearNumber(strYear: String(DateConverter.getCurrentYear()))
        setCurrentWeekNumber(strWeek: String(DateConverter.getCurrentWeekNum()))
        if let u = FIRAuth.auth()?.currentUser {
            _user = u
            
            retrieveExercisesForUser(completion: {
                self._exercisesForUser.sort(by: {a, b in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "y-M-d HH:mm:ss"
                    let dateA = dateFormatter.date(from: a.uploadTime)!
                    let dateB = dateFormatter.date(from: b.uploadTime)!
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
    
    func sortDataByDate(){
        _progressData = self._progressData.sorted(by: {a, b in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-M-d HH:mm:ss"
            
            
            let dateA = dateFormatter.date(from: a.key)!
            let dateB = dateFormatter.date(from: b.key)!
            if dateA < dateB {
                return true
            }
            return false
            
        })
    }
    
    func checkOpponentEmail(email:String, completion:@escaping ()->Void){
        
        _ref.child("emails").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let value = snapshot.value as! NSDictionary
            let keys = value.allKeys as! [String]
            for key in keys{
                if key == email{
                    self._emailCheckBoolean = true
                    completion()
                    return
                }
            }
            self._emailCheckBoolean = false
            completion()
        })
    }
    
    func setEdit(bool:Bool){
        _edit = bool
    }
    
    func setExSessionEdit(bool:Bool){
        _exSessionEdit = bool
    }
    
    func setCurrentWeekNumber(strWeek:String){
        _currentWeekNumber = strWeek
    }
    
    func setCurrentYearNumber(strYear:String){
        _currentYear = strYear
    }
    
    func setCurrentDay(day:String){
        _currentDay = day
    }
    
    func setPassedSession(session:Session){
        _passedSession = session
    }
    
    func updateNewClient(newClient: [String:Any], completion:@escaping ()->Void) {
        _ref.child("users").child(_user.uid).child("Clients").child(newClient["clientKey"] as! String).updateChildValues(newClient)
        retrieveClients(completion: {
            completion()
        })
    }
    
    func addDataToPersonalProgress(selection:String, newData: [String:String], completion:@escaping ()->Void) {
        _ref.child("users").child(_user.uid).child("Progress").child(selection).updateChildValues(newData)
        completion()
    }
    
    func addDataToClientProgress(selection:String, newData: [String:String], completion:@escaping ()->Void) {
        _ref.child("users").child(_user.uid).child("Clients").child(_passedClient.clientKey).child("Progress").child(selection).updateChildValues(newData)
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
            //update firebase client session and client date branch
        self._ref.child("users").child(self.user.uid).child("Clients").child(_passedClient.clientKey).child("Sessions").child(_passedSession.key).child("exercises").updateChildValues([exerciseDictionary["exerciseKey"]as! String:true])
        self._ref.child("users").child(self.user.uid).child("Clients").child(_passedClient.clientKey).child("Exercises").child(exerciseDictionary["exerciseKey"] as! String).updateChildValues(exerciseDictionary)
        
        //update firebase client all branch
        
//        if exerciseDictionary["type"] as! String == "Endurance"{
//            self._ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("All").child(exerciseDictionary["type"] as! String).child(exerciseDictionary["category"] as! String).child(exerciseDictionary["name"] as! String).child(exerciseDictionary["description"] as! String).child(exerciseDictionary["exerciseKey"] as! String).updateChildValues(exerciseDictionary)
//        }else{
        self._ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("All").child(exerciseDictionary["type"] as! String).child(exerciseDictionary["category"] as! String).child(exerciseDictionary["name"] as! String).child(exerciseDictionary["exerciseKey"] as! String).updateChildValues(exerciseDictionary)
    //    }
        
        completion()
    }
    
    func createSessionForClient(sessionDictionary:[String:Any]){
        self._ref.child("users").child(self.user.uid).child("Clients").child(passedClient.clientKey).child("Calendar").child(currentYear).child(currentWeekNumber).child(currentDay).updateChildValues([sessionDictionary["key"] as! String:true])
        
        self._ref.child("users").child(self.user.uid).child("Clients").child(passedClient.clientKey).child("Sessions").child(sessionDictionary["key"] as! String).updateChildValues(sessionDictionary)
    }
    
    func retrieveSessionInfo(key:String, completion: @escaping () -> Void){
        _sessions.removeAll()
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("Sessions").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let session = Session()
                session.day = value?["day"] as! String
                session.duration = value?["duration"] as! String
                session.exercises = value?["exercises"] as? [String]
                session.key = value?["key"] as! String
                session.sessionName = value?["sessionName"] as! String
                session.sessionNumber = value?["sessionNumber"] as! String
                session.paid = value?["paid"] as! Bool
                session.weekNumber = value?["weekNumber"] as! String
                session.clientName = value?["clientName"] as! String
                session.year = value?["year"] as! String
                self._sessions.append(session)
                completion()
            }else{
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func createExerciseKey() -> String{
        let str = _ref.child("users").child(user.uid).child("Exercises").childByAutoId().key
        _currentKey = str
        return str
    }
    
    func createSessionKey() -> String{
        let str = _ref.child("users").child(user.uid).child("Sessions").childByAutoId().key
        _currentKey = str
        return str
    }
    
    func createClientID() -> String{
        let str = _ref.child("users").child(user.uid).child("Clients").childByAutoId().key
        _currentKey = str
        return str
    }
    
    func updateExerciseForUser(exerciseDictionary:[String:Any], completion: () -> Void) {
       
        //update firebase date branch
        self._ref.child("users").child(user.uid).child("Exercises").child(currentYear).child(currentWeekNumber).child(exerciseDictionary["exerciseKey"] as! String).updateChildValues(exerciseDictionary)
        
        //update firebase all branch
        
        if exerciseDictionary["type"] as! String == "Endurance"{
        self._ref.child("users").child(user.uid).child("Exercises").child("All").child(exerciseDictionary["type"] as! String).child(exerciseDictionary["category"] as! String).child(exerciseDictionary["name"] as! String).child(exerciseDictionary["description"] as! String).child(exerciseDictionary["exerciseKey"] as! String).updateChildValues(exerciseDictionary)
        }else{
        self._ref.child("users").child(user.uid).child("Exercises").child("All").child(exerciseDictionary["type"] as! String).child(exerciseDictionary["category"] as! String).child(exerciseDictionary["name"] as! String).child(exerciseDictionary["exerciseKey"] as! String).updateChildValues(exerciseDictionary)
        }
        
        completion()
    }
    
    func setNewDate(dateString:String){
        _selectedDate = dateString
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
    
    func setPassedClient(client:Client, completion:()->Void){
        _passedClient = client
        completion()
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
    
    func setSupersetExercises(exercises:[Exercise]){
        _supersetExercises = exercises
    }
    
    func setSupersetExercise(exercise:Exercise){
        _supersetExercises.append(exercise)
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
    
    func retrieveClientProgressCategoriesForType(type:String, completion: @escaping () -> Void){
        _progressCategories.removeAll()
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("All").child(type).observeSingleEvent(of: .value, with: { (snapshot) in
            if let tempCategories = snapshot.value as? NSDictionary{
                for category in tempCategories{
                    self._progressCategories.append(category.key as! String)
                }
            }
            
            //remove categories that cannot be displayed on graph
            if self._progressCategories.contains("Amrap"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Amrap")!)
            }
            if self._progressCategories.contains("Emom"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Emom")!)
            }
            if self._progressCategories.contains("For Time"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "For Time")!)
            }
            if self._progressCategories.contains("Metcon"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Metcon")!)
            }
            if self._progressCategories.contains("Tabata"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Tabata")!)
            }
            if self._progressCategories.contains("Hero Wods"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Hero Wods")!)
            }
            if self._progressCategories.contains("Superset"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Superset")!)
            }
            completion()
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveProgressCategoriesForType(type:String, completion: @escaping () -> Void){
        _progressCategories.removeAll()
        _ref.child("users").child(user.uid).child("Exercises").child("All").child(type).observeSingleEvent(of: .value, with: { (snapshot) in
            if let tempCategories = snapshot.value as? NSDictionary{
                for category in tempCategories{
                    self._progressCategories.append(category.key as! String)
                }
            }
            //remove categories that cannot be displayed on graph
            if self._progressCategories.contains("Amrap"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Amrap")!)
            }
            if self._progressCategories.contains("Emom"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Emom")!)
            }
            if self._progressCategories.contains("For Time"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "For Time")!)
            }
            if self._progressCategories.contains("Metcon"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Metcon")!)
            }
            if self._progressCategories.contains("Tabata"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Tabata")!)
            }
            if self._progressCategories.contains("Hero Wods"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Hero Wods")!)
            }
            if self._progressCategories.contains("Superset"){
                self._progressCategories.remove(at:self._progressCategories.index(of: "Superset")!)
            }
            completion()
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveClientProgressResultsForExerciseName(type:String, category:String, exerciseName:String, completion: @escaping () -> Void){
        _progressData.removeAll()
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("All").child(type).child(category).child(exerciseName).observeSingleEvent(of: .value, with: { (snapshot) in
            if let exerciseKeys = snapshot.value as? [String: [String: AnyObject]]{
                var tempExercises = [Exercise]()
                for exercise in exerciseKeys{
                    let tempExercise = Exercise()
                    tempExercise.year = exercise.value["year"] as! String
                    tempExercise.week = exercise.value["week"] as! String
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
                    tempExercise.uploadTime = exercise.value["uploadTime"] as! String
                    tempExercises.append(tempExercise)
                }
                
                for exercise in tempExercises{
                    self._progressData.append((key:exercise.uploadTime, value:exercise.result))
                }
                completion()
            }
        })
    }
    
    func retrieveProgressResultsForExerciseName(type:String, category:String, exerciseName:String, completion: @escaping () -> Void){
        _progressData.removeAll()
        _ref.child("users").child(user.uid).child("Exercises").child("All").child(type).child(category).child(exerciseName).observeSingleEvent(of: .value, with: { (snapshot) in
            if let exerciseKeys = snapshot.value as? [String: [String: AnyObject]]{
                var tempExercises = [Exercise]()
                for exercise in exerciseKeys{
                    let tempExercise = Exercise()
                    tempExercise.year = exercise.value["year"] as! String
                    tempExercise.week = exercise.value["week"] as! String
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
                    tempExercise.uploadTime = exercise.value["uploadTime"] as! String
                    tempExercises.append(tempExercise)
                    
                }
                
                for exercise in tempExercises{
                    self._progressData.append((key:exercise.uploadTime, value:exercise.result))
                }
                completion()
            }
        })
    }
    
    func retrieveClientProgressExercisesForCategory(type:String, category:String, completion: @escaping () -> Void){
        _progressExerciseNames.removeAll()
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("All").child(type).child(category).observeSingleEvent(of: .value, with: { (snapshot) in
            if let tempExercises = snapshot.value as? NSDictionary{
                for exercise in tempExercises{
                    self._progressExerciseNames.append(exercise.key as! String)
                }
            }
            completion()
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveProgressExercisesForCategory(type:String, category:String, completion: @escaping () -> Void){
       _progressExerciseNames.removeAll()
        _ref.child("users").child(user.uid).child("Exercises").child("All").child(type).child(category).observeSingleEvent(of: .value, with: { (snapshot) in
            if let tempExercises = snapshot.value as? NSDictionary{
                for exercise in tempExercises{
                    self._progressExerciseNames.append(exercise.key as! String)
                }
            }
            completion()
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveClientProgressTypesAndCategories(completion: @escaping () -> Void){
        _progressTypes.removeAll()
        _progressCategories.removeAll()
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("All").observeSingleEvent(of: .value, with: { (snapshot) in
            if let tempTypes = snapshot.value as? NSDictionary{
                for type in tempTypes{
                    self._progressTypes.append(type.key as! String)
                }
                //remove types that cannot be displayed on graph
//                if self._progressTypes.contains("Endurance"){
//                    self._progressTypes.remove(at:self._progressTypes.index(of: "Endurance")!)
//                }
                if self._progressTypes.contains("Crossfit"){
                    let tempProgressCategories = tempTypes["Crossfit"] as! NSDictionary
                    var tempExercise = [String]()
                    for ex in tempProgressCategories{
                        tempExercise.append(ex.key as! String)
                    }
                    if tempExercise.contains("Amrap"){
                        tempExercise.remove(at: tempExercise.index(of: "Amrap")!)
                    }
                    if tempExercise.contains("For Time"){
                        tempExercise.remove(at: tempExercise.index(of: "For Time")!)
                    }
                    if tempExercise.contains("Tabata"){
                        tempExercise.remove(at: tempExercise.index(of: "Tabata")!)
                    }
                    if tempExercise.contains("Emom"){
                        tempExercise.remove(at: tempExercise.index(of: "Emom")!)
                    }
                    if tempExercise.contains("Metcon"){
                        tempExercise.remove(at: tempExercise.index(of: "Metcon")!)
                    }
                    if tempExercise.contains("Hero Wods"){
                        tempExercise.remove(at: tempExercise.index(of: "Hero Wods")!)
                    }
                    if tempExercise.count == 0{
                        self._progressTypes.remove(at:self._progressTypes.index(of: "Crossfit")!)
                    }
                }
                if self._progressTypes.contains("Bodybuilding"){
                    //retrieve categories for bodybuilding
                    let tempProgressCategories = tempTypes["Bodybuilding"] as! NSDictionary
                    var tempExercise = [String]()
                    for ex in tempProgressCategories{
                        tempExercise.append(ex.key as! String)
                    }
                    if tempExercise.contains("Superset"){
                        tempExercise.remove(at: tempExercise.index(of: "Superset")!)
                        
                        //remove bodybuilding type if superset is the only bodybuilding exercise
                        if tempExercise.count == 0{
                            self._progressTypes.remove(at: self._progressTypes.index(of: "Bodybuilding")!)
                        }
                    }
                }
                completion()
                
            }else{
                self._progressTypes.removeAll()
                self._progressCategories.removeAll()
                completion()
            }
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveUserProgressTypesAndCategories(completion: @escaping () -> Void){
       _progressTypes.removeAll()
        _progressCategories.removeAll()
        _ref.child("users").child(user.uid).child("Exercises").child("All").observeSingleEvent(of: .value, with: { (snapshot) in
            if let tempTypes = snapshot.value as? NSDictionary{
                for type in tempTypes{
                    self._progressTypes.append(type.key as! String)
                }
                //remove types that cannot be displayed on graph
//                if self._progressTypes.contains("Endurance"){
//                    self._progressTypes.remove(at:self._progressTypes.index(of: "Endurance")!)
//                }
                if self._progressTypes.contains("Crossfit"){
                   let tempProgressCategories = tempTypes["Crossfit"] as! NSDictionary
                    var tempExercise = [String]()
                    for ex in tempProgressCategories{
                        tempExercise.append(ex.key as! String)
                    }
                    if tempExercise.contains("Amrap"){
                        tempExercise.remove(at: tempExercise.index(of: "Amrap")!)
                    }
                    if tempExercise.contains("For Time"){
                        tempExercise.remove(at: tempExercise.index(of: "For Time")!)
                    }
                    if tempExercise.contains("Tabata"){
                        tempExercise.remove(at: tempExercise.index(of: "Tabata")!)
                    }
                    if tempExercise.contains("Emom"){
                        tempExercise.remove(at: tempExercise.index(of: "Emom")!)
                    }
                    if tempExercise.contains("Metcon"){
                        tempExercise.remove(at: tempExercise.index(of: "Metcon")!)
                    }
                    if tempExercise.contains("Hero Wods"){
                        tempExercise.remove(at: tempExercise.index(of: "Hero Wods")!)
                    }
                    if tempExercise.count == 0{
                        self._progressTypes.remove(at:self._progressTypes.index(of: "Crossfit")!)
                    }
                }
                if self._progressTypes.contains("Bodybuilding"){
                    //retrieve categories for bodybuilding
                    let tempProgressCategories = tempTypes["Bodybuilding"] as! NSDictionary
                    var tempExercise = [String]()
                    for ex in tempProgressCategories{
                        tempExercise.append(ex.key as! String)
                    }
                    if tempExercise.contains("Superset"){
                        tempExercise.remove(at: tempExercise.index(of: "Superset")!)
                        
                        //remove bodybuilding type if superset is the only bodybuilding exercise
                        if tempExercise.count == 0{
                            self._progressTypes.remove(at: self._progressTypes.index(of: "Bodybuilding")!)
                        }
                    }
                }
                completion()
                
            }else{
                self._progressTypes.removeAll()
                self._progressCategories.removeAll()
                completion()
            }
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveExercisesForUser(completion: @escaping () -> Void){
        _exercisesForUser.removeAll()
        _ref.child("users").child(user.uid).child("Exercises").child(currentYear).child(currentWeekNumber).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            if let exercisesVal = snapshot.value as? [String: [String: AnyObject]] {
                for exercise in exercisesVal {
                    let tempExercise = Exercise()
                    tempExercise.year = exercise.value["year"] as! String
                    tempExercise.week = exercise.value["week"] as! String
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
                    tempExercise.uploadTime = exercise.value["uploadTime"] as! String
                    self._exercisesForUser.append(tempExercise)
                    completion()
                }
            }else{
                self._exercisesForUser.removeAll()
                completion()
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
    
    func retrieveTypes(completion: @escaping () -> Void){
        _types.removeAll()
        _ref.child("users").child(user.uid).child("Types").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                self._types = keyArray
                self._types.sort()
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
    
    func retrieveClientInfo(clientKey:String)->Client{
        let c = Client()
        for client in _clients{
            if client.clientKey == clientKey{
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
    
    func updateClientPassed(completion: @escaping () -> Void){
        _ref.child("users").child(user.uid).child("Clients").child(_passedClient.clientKey).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let client = value
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
                self._passedClient = c
                completion()
            }else{
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
                    self.sortClients()
                    completion()
                }
            }else{
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func checkSessionNumber(completion: @escaping () -> Void){
        _sessionsCount = 0
        
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("Calendar").child(currentYear).child(currentWeekNumber).child(currentDay).observeSingleEvent(of: .value, with: { (snapshot) in
            if let sessions = snapshot.value as? NSDictionary{
                let keys = sessions.allKeys
                for _ in keys{
                    self._sessionsCount += 1
                }
                completion()
            }else{
                completion()
            }
        }){(error) in
            print(error.localizedDescription)
        }
    }
    
    func saveDurationForSession(str:String, completion: @escaping (String) -> Void){
        self._ref.child("users").child(user.uid).child("Clients").child(_passedClient.clientKey).child("Sessions").child(_passedSession.key).updateChildValues(["duration":str])
        completion(str)
    }
    
    func updatePaidForSession(boolean:Bool, completion: @escaping () -> Void){
        self._ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("Sessions").child(_passedSession.key).updateChildValues(["paid":boolean])
        completion()
    }
    
    func retrieveExerciseListFromSessionKey(keyStr:String, completion: @escaping () -> Void){
        print(keyStr)
        _exercisesForClient.removeAll()
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("Sessions").child(keyStr).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let session = snapshot.value as? NSDictionary
            if session != nil{
                if let exerciseStrings = session?["exercises"] as? NSDictionary{
                    let keys = exerciseStrings.allKeys
                    for key in keys{
                        self.retrieveExercisesForSession(exerciseStr:key as! String, completion: {
                            completion()
                        })
                    }
                }else{
                    completion()
                }
            }else{
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveExercisesForSession(exerciseStr:String, completion: @escaping () -> Void){
        print(passedClient.clientKey)
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("Exercises").child(exerciseStr).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let exercise = snapshot.value as? [String:Any]
            if exercise != nil{
                let tempExercise = Exercise()
                tempExercise.year = exercise?["year"] as! String
                tempExercise.week = exercise?["week"] as! String
                tempExercise.name = exercise?["name"] as! String
                tempExercise.exerciseDescription = exercise?["description"] as! String
                tempExercise.result = exercise?["result"] as! String
                tempExercise.exerciseKey = exercise?["exerciseKey"] as! String
                tempExercise.date = exercise?["date"] as! String
                tempExercise.client = exercise?["client"] as! String
                tempExercise.creatorEmail = exercise?["creatorEmail"] as! String
                tempExercise.creatorID = exercise?["creatorID"] as! String
                tempExercise.category = exercise?["category"] as! String
                tempExercise.type = exercise?["type"] as! String
                tempExercise.uploadTime = exercise?["uploadTime"] as! String
                self._exercisesForClient.append(tempExercise)
                completion()
            }else{
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveSessionsForWeekForClient(completion:@escaping ()-> Void){
        _sessions.removeAll()
        _ref.child("users").child(user.uid).child("Clients").child(passedClient.clientKey).child("Calendar").child(currentYear).child(currentWeekNumber).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let exercisesVal = snapshot.value as? NSDictionary {
                let days = exercisesVal.allKeys as! [String]
                for day in days{
                    let keys = exercisesVal[day] as? NSDictionary
                    for key in keys!{
                        self.retrieveSessionInfo(key: key.key as! String, completion: {completion()})
                    }
                }
            }else{
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveSessionsForDateForClient(dateStr:String, completion:@escaping ()-> Void){
        _sessions.removeAll()
        _ref.child("users").child(user.uid).child("Clients").child(_passedClient.clientKey).child("Calendar").child(String(DateConverter.getYearFromDate(dateStr: dateStr))).child(String(DateConverter.getWeekNumberFromDate(dateStr: dateStr))).child(DateConverter.getNameForDay(dateStr: dateStr)).observeSingleEvent(of: .value, with: { (snapshot) in
            let exercisesVal = snapshot.value as? NSDictionary
            if exercisesVal != nil{
                let keys = exercisesVal?.allKeys as! [String]
                for key in keys{
                    self.retrieveSessionInfo(key: key, completion: {completion()})
                }
            }else{
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveChallengesExercises(completion:@escaping ()->Void){
        _ref.child("users").child(user.uid).child("Challenges").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // let value = snapshot.value as! NSDictionary
            if let exercisesVal = snapshot.value as? [String: [String: AnyObject]] {
                self._challengeExercises.removeAll()
                for exercise in exercisesVal {
                    let tempExercise = Exercise()
                    tempExercise.week = exercise.value["week"] as! String
                    tempExercise.year = exercise.value["year"] as! String
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
                    tempExercise.viewed = exercise.value["viewed"] as! String
                    tempExercise.uploadTime = exercise.value["uploadTime"] as! String
                    self._challengeExercises.append(tempExercise)
                    completion()
                }
            }else{
                self._challengeExercises.removeAll()
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func notificationCheck(completion: @escaping () -> Void){
        retrieveChallengesExercises {
            self._notificationCount = 0
            for exercise in self.challengeExercises{
                if exercise.viewed == "false"{
                    self._notificationCount += 1
                }
            }
            completion()
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
    
    func retrieveClientExerciseData(type:String,completion:@escaping ()->Void){
        self.retrieveClientProgressCategoriesForType(type: type, completion: {
            //select value if empty
            if self._selectedProgressCategory == ""{
                self._selectedProgressCategory = self._progressCategories[0]
            }
            self.retrieveClientProgressExercisesForCategory(type: type, category: self._progressCategories[0], completion: {
                if self._selectedProgressExercise == ""{
                    self._selectedProgressExercise = self._progressExerciseNames[0]
                }
                self.retrieveClientProgressResultsForExerciseName(type: type, category: self._selectedProgressCategory, exerciseName: self._selectedProgressExercise, completion: {self._defaultChartTitle = self.selectedProgressExercise
                    completion()
                })
                
            })
        })
    }
    
    func retrieveExerciseData(type:String,completion:@escaping ()->Void){
        self.retrieveProgressCategoriesForType(type: type, completion: {
            //select value if empty
            if self._selectedProgressCategory == ""{
                self._selectedProgressCategory = self._progressCategories[0]
            }
            self.retrieveProgressExercisesForCategory(type: type, category: self._selectedProgressCategory, completion: {
                if self._selectedProgressExercise == ""{
                    self._selectedProgressExercise = self._progressExerciseNames[0]
                }
                self.retrieveProgressResultsForExerciseName(type: type, category: self._selectedProgressCategory, exerciseName: self._selectedProgressExercise, completion: {self._defaultChartTitle = self._selectedProgressExercise
                    completion()
                })
                
            })
        })
    }
    
    //retrieve client weight
    func retrieveProgressDataForClient(selection:String, completion:@escaping()->Void){
        _progressData.removeAll()
        _ref.child("users").child(user.uid).child("Clients").child(DBService.shared.passedClient.clientKey).child("Progress").child(selection).observeSingleEvent(of: .value, with: { (snapshot) in
            if let values = snapshot.value as? [String:String]{
                
                var formatedValues = [(key:String, value:String)]()
                for element in values{
                    formatedValues.append((element.key, element.value))
                }
                
                if selection == "Weight"{
                    self._progressData = formatedValues
                }
                self.sortDataByDate()
                completion()
            }else{
                completion()
            }
        })
    }
    
    //retrieve user weight
    func retrieveProgressData(selection:String, completion:@escaping()->Void){
        _progressData.removeAll()
        _ref.child("users").child(user.uid).child("Progress").child(selection).observeSingleEvent(of: .value, with: { (snapshot) in
            if let values = snapshot.value as? [String:String]{
                
                var formatedValues = [(key:String, value:String)]()
                for element in values{
                    formatedValues.append((element.key, element.value))
                }
                
                if selection == "Weight"{
                    self._progressData = formatedValues
                }
                self.sortDataByDate()
                completion()
            }else{
                completion()
            }
        })
    }
    
    func deleteProgressDataForPersonal(data:(key: String, value: String), selection:String){
        self._ref.child("users").child(user.uid).child("Progress").child(selection).child(data.key).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func deleteProgressDataForClient(data:(key: String, value: String), selection:String){
        self._ref.child("users").child(user.uid).child("Clients").child(DBService.shared.passedClient.clientKey).child("Progress").child(selection).child(data.key).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func deleteClient(id:String){
        self._ref.child("users").child(user.uid).child("Clients").child(id).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func deleteExerciseFromKey(exerciseKey:String){
        self._ref.child("users").child(user.uid).child("Clients").child(_passedClient.clientKey).child("Exercises").child(exerciseKey).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func deleteSessionForClient(session:Session, completion: @escaping () -> Void){
        self._ref.child("users").child(self.user.uid).child("Clients").child(_passedClient.clientKey).child("Calendar").child(session.year).child(session.weekNumber).child(session.day).child(session.key).removeValue { (error, ref) in
            
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        self._ref.child("users").child(self.user.uid).child("Clients").child(passedClient.clientKey).child("Sessions").child("exercises").observeSingleEvent(of: .value, with: { (snapshot) in
            let exercisesKey = snapshot.value as? NSDictionary
            if exercisesKey != nil{
                let keys = exercisesKey?.allKeys as! [String]
                for key in keys{
                    self.deleteExerciseFromKey(exerciseKey: key)
                }
            }else{
                completion()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        self._ref.child("users").child(self.user.uid).child("Clients").child(passedClient.clientKey).child("Sessions").child(session.key).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        completion()
    }
    
    func deleteExerciseForClient(exercise:Exercise, completion: @escaping () -> Void){
        
        self._ref.child("users").child(self.user.uid).child("Clients").child(_passedClient.clientKey).child("All").child(exercise.type).child(exercise.category).child(exercise.name).child(exercise.exerciseKey).removeValue()
        self._ref.child("users").child(self.user.uid).child("Clients").child(_passedClient.clientKey).child("Exercises").child(exercise.exerciseKey).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        self._ref.child("users").child(self.user.uid).child("Clients").child(_passedClient.clientKey).child("Sessions").child(_passedSession.key).child("exercises").child(exercise.exerciseKey).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        completion()
    }
    
    func deleteExerciseForUser(exercise:Exercise, completion: @escaping () -> Void){
        self._ref.child("users").child(self.user.uid).child("Exercises").child("All").child(exercise.type).child(exercise.category).child(exercise.name).child(exercise.exerciseKey).removeValue()
        
        self._ref.child("users").child(self.user.uid).child("Exercises").child(exercise.year).child(exercise.week).child(exercise.exerciseKey).removeValue { (error, ref) in
            completion()
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func deleteChallengeExerciseForUser(exercise:Exercise){
        self._ref.child("users").child(self.user.uid).child("Challenges").child(exercise.exerciseKey).removeValue { (error, ref) in
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
    
    func deleteExerciseForCategoryForType(exercise:String, category:String, type:String, completion: @escaping () -> Void){
        self._ref.child("users").child(self.user.uid).child("Types").child(type).child(category).child(exercise).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
            completion()
        }
    }
    
    func setChallengesToViewed(){
        retrieveChallengesExercises {
            for exercise in self._challengeExercises{
                self._ref.child("users").child(self.user.uid).child("Challenges").child(exercise.exerciseKey).updateChildValues(["viewed":"true"])
            }
        }
    }
    
    func resetNotificationCount(){
        _notificationCount = 0
    }
    
    func clearSupersetExercises(){
        _supersetExercises.removeAll()
    }
    
    func clearPassedClient(){
        _passedClient.clientKey = ""
    }
    
    func clearExercisePassed(){
        _passedExercise?.exerciseKey = ""
    }
    
    func clearDefautChartTitle(){
        _defaultChartTitle = ""
    }
    
    func setPassedClientToPersonal(){
        _passedClient.firstName = "Personal"
    }
    
    func setDateRange(dateRange:String){
        _dateRange = dateRange
    }
    
    func setPassedDate(dateStr:String){
        _passedDate = dateStr
    }
    
    func setPassToNextVC(bool:Bool){
        _passToNextVC = bool
    }
    
    func setSelectedProgressCategory(categoryStr:String){
        _selectedProgressCategory = categoryStr
    }
    
    func setSelectedProgressExercise(exerciseStr:String){
        _selectedProgressExercise = exerciseStr
    }
    
    func initializeData(){
        self._ref.child("types").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                self._types = value?.allKeys as! [String]
                for type in self._types{
                    var categoryDictionary = [String:Any]()
                    categoryDictionary = value?[type] as! [String : Any]
                    self._ref.child("users").child(self.user.uid).child("Types").child(type).updateChildValues(categoryDictionary)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
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
    
    var notificationCount:Int{
        get{
            return _notificationCount
        }
    }
    
    var supersetExercises:[Exercise]{
        get{
            return _supersetExercises
        }
    }
    
    var edit:Bool{
        get{
            return _edit
        }
    }
    
    var emailCheckBoolean:Bool{
        get{
            return _emailCheckBoolean
        }
    }
    
    var currentWeekNumber:String{
        get{
            return _currentWeekNumber
        }
    }
    
    var currentYear:String{
        get{
            return _currentYear
        }
    }
    
    var currentDay:String{
        get{
            return _currentDay
        }
    }
    
    var selectedDate:String{
        get{
            return _selectedDate
        }
    }
    
    var types:[String]{
        get{
            return _types
        }
    }
    
    var sessions:[Session]{
        get{
            return _sessions
        }
    }
    
    var sessionsCount:Int{
        get{
            return _sessionsCount
        }
    }
    
    var passedSession:Session{
        get{
            return _passedSession
        }
    }
    
    var dateRange:String{
        get{
            return _dateRange
        }
    }
    
    var passedDate:String{
        get{
            return _passedDate
        }
    }
    
    var exSessionEdit:Bool{
        get{
            return _exSessionEdit
        }
    }
    
    var passToNextVC:Bool{
        get{
            return _passToNextVC
        }
    }
    
    var progressData:[(key: String, value: String)]{
        get{
            return _progressData
        }
    }
    
    var progressTypes:[String]{
        get{
            return _progressTypes
        }
    }
    
    var progressCategories:[String]{
        get{
            return _progressCategories
        }
    }
    
    var progressTypePassed:String{
        get{
            return _progressTypePassed
        }
    }
    
    var progressExerciseNames:[String]{
        get{
            return _progressExerciseNames
        }
    }
    
    var defaultChartTitle:String{
        get{
            return _defaultChartTitle
        }
    }
    
    var selectedProgressCategory:String{
        get{
            return _selectedProgressCategory
        }
    }
    
    var selectedProgressExercise:String{
        get{
            return _selectedProgressExercise
        }
    }
    
}
