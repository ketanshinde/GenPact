//
//  DBManager.swift
//  GenPact
//
//  Created by ketan shinde on 16/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {
    
    let entityName = "Movies"
    static let instance = DatabaseManager()

    func managedContext() -> NSManagedObjectContext {
        APP_DELEGATE.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return APP_DELEGATE.persistentContainer.viewContext
    }
    
    func createData(movie: Movie) {
        
        let context = managedContext()
        let movieEntity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        
        let movieManagedObj = NSManagedObject(entity: movieEntity, insertInto: context)
        
        movieManagedObj.setValue(movie.voteCount, forKeyPath: "vote_count")
        movieManagedObj.setValue(movie.posterPath, forKey: "poster_path")
        movieManagedObj.setValue(movie.id, forKey: "id")
        
        movieManagedObj.setValue(movie.originalLanguage, forKeyPath: "original_language")
        movieManagedObj.setValue(movie.title, forKey: "title")
        movieManagedObj.setValue(movie.overview, forKey: "overview")
        
        movieManagedObj.setValue(movie.releaseDate, forKeyPath: "release_date")
        movieManagedObj.setValue(movie.isFav, forKey: "isFav")
        
        do {
            try context.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData(completion: @escaping ([Movie]?, Error?) -> ()) {
        
        let context = managedContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let result = try context.fetch(fetchRequest)
            convertToMovieList(moArray: result as! [NSManagedObject]) { (coreMovies, error) in
                if error != nil {
                    completion(nil, error)
                } else {
                    completion(coreMovies, nil)
                }
            }
        } catch {
            print("FAILED: \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    func fetchData(movie: Movie, completion: @escaping (Bool?) -> ()) {
        
        let context = managedContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %ld", movie.id!)
        
        do {
            let test = try context.fetch(fetchRequest)
            if test.count > 0 {
                completion(true)
            } else {
                completion(false)
            }
        }
        catch {
            print(error)
            print("FETCH : \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func deleteData(movie: Movie, completion: @escaping (Bool?, Error?) -> ()) {
        
        let context = managedContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %ld", movie.id!)
        
        do {
            let test = try context.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            context.delete(objectToDelete)
            do {
                try context.save()
                completion(true, nil)
            }
            catch {
                print("DELETE: \(error.localizedDescription)")
                completion(false, error)
            }
        }
        catch {
            print(error)
            print("FETCH TO DELETE: \(error.localizedDescription)")
            completion(false, error)
        }
    }
    
    func convertToMovieList(moArray: [NSManagedObject], completion: @escaping ([Movie]?, Error?) -> ()){
        
        var jsonArray: [Movie] = []
        let myGroup = DispatchGroup()
        var catchError: Error?
        
        for item in moArray {
            myGroup.enter()

            var dict: [String: Any] = [:]
            
            for attribute in item.entity.attributesByName {
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys

                do {
                    let getMovie = try decoder.decode(Movie.self, from: data)
                    jsonArray.append(getMovie)
                    myGroup.leave()
                }
                catch {
                    print("DECODER: \(error.localizedDescription)")
                    catchError = error
                    myGroup.leave()
                }
            }
            catch {
                print("JSONSerializer ERROR: \(error.localizedDescription)")
                catchError = error
                myGroup.leave()
            }
            
            myGroup.notify(queue: .main) {
                if catchError != nil {
                    completion(nil, catchError)
                } else {
                    completion(jsonArray, nil)
                }
            }
        }
    }
}
