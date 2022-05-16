
import Foundation

var greeting = "Hello, playground"

protocol AppProtocol {
    
    var appName: String { get set }
    var appCategory: String { get set }
    
    var feedback: [String]? { get set }
    var scores: [Int]? { get set }
}

struct App: AppProtocol {
    
    var appName: String
    var appCategory: String
    
    var feedback: [String]?
    var scores: [Int]?
}




protocol AppStoreProtocol {
    
    var appStorage: [AppProtocol]? { get set }
    
    mutating func save(app: AppProtocol) -> [AppProtocol]?
    
    func load(app: AppProtocol)
    
    mutating func delete(app: AppProtocol) -> [AppProtocol]?
    
    mutating func addFeedback(app: AppProtocol, appFeedback: String) -> [AppProtocol]?
    
    mutating func addScore(app: inout AppProtocol, score: Int) -> AppProtocol
}



struct AppStore: AppStoreProtocol {
    
   var appStorage: [AppProtocol]?
    
    mutating func save(app: AppProtocol) -> [AppProtocol]? {
        if (appStorage?.append(app)) == nil { // this is kind of if else that really work
            appStorage = [app]
        }
        print("\(app.appName) was uploaded to the AppStore")
        return appStorage
    }
    
    func load(app: AppProtocol) {
        print("\(app.appName) was opened")
    }
    
    mutating func delete(app: AppProtocol) -> [AppProtocol]? {
        var counter = -1
        for App in appStorage! {
            counter += 1
            if App.appName == app.appName {
                break
            }
        }
        appStorage?.remove(at: counter)
        print("App was deleted")
        return appStorage
    }
    
    mutating func addFeedback(app: AppProtocol, appFeedback: String) -> [AppProtocol]? {
        
        var counter = -1
        for App in appStorage! {
            counter += 1
            if App.appName == app.appName {
                break
                
                
            }
        }
        if (appStorage?[counter].feedback?.append(appFeedback)) == nil { // this is kind of if else that really work
            appStorage?[counter].feedback? = [appFeedback]
        return appStorage
    }
    
    func addScore(app: inout AppProtocol, score: Int) -> AppProtocol {
        switch score {
        case 1...5:
            app.scores?.append(score)
            print("Score for \(app.appName) was added")
        default:
        print("Wrong score")
    }
    return app
}
    
}

var myAppStore = AppStore()

var myTodoList = App(appName: "ToDo list", appCategory: "Self-development")
var myMaps: AppProtocol = App(appName: "Apple maps", appCategory: "Other")
var snakeGame = App(appName: "Snake", appCategory: "Games")
var myPlanner = App(appName: "Planner", appCategory: "Self-development")
var messager = App(appName: "Facelook", appCategory: "Social media")
var instaGigaGram = App(appName: "InstaGigaGram", appCategory: "Social media")

myAppStore.save(app: myTodoList)

myAppStore.save(app: myMaps)
myAppStore.save(app: snakeGame)
myAppStore.save(app: myPlanner)
myAppStore.save(app: messager)
myAppStore.save(app: instaGigaGram)

myAppStore.load(app: myMaps)

myAppStore.delete(app: myPlanner)
myAppStore.delete(app: messager)

myAppStore.addFeedback(app: &myMaps, feedback: "This is awesome")
myAppStore.addFeedback(app: &myMaps, feedback: "Incredible app!")
myAppStore.appStorage
myMaps.feedback


// Seems like i should use struct for AppProtocol because i can't make an instance of AppProtocol without type
///
////
///
///
///

//struct MyAppStore {
//
//   var appStorage: [App]?
//
//    mutating func save(app: App) -> [App]? {
//        if (appStorage?.append(app)) == nil { // this is kind of if else that really work
//            appStorage = [app]
//        }
//        print("\(app.appName) was uploaded to the AppStore")
//        return appStorage
//    }
//}
//
//var newAppStore = MyAppStore()
//newAppStore.save(app: snakeGame)
//newAppStore.save(app: messager)
//newAppStore.appStorage = [myMaps, myPlanner]
//newAppStore.save(app: myTodoList)

// if storage is empty this won't add new app, but if in storage will be something it's working well.


//mutating func addFeedback(app: inout AppProtocol, feedback: String) -> AppProtocol {
//    for project in appStorage! {
//        if project.appName == app.appName {
//            if (app.feedback?.append(feedback)) == nil { // this is kind of if else that really work
//                app.feedback = [feedback]
//            }
//            print("feedback for \(app.appName) was added")
//        }
//    return app
//}

// func to add feedback to app
