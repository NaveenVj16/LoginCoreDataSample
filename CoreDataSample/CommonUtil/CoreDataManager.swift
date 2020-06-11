//
//  UserdetailsManager.swift
//  FooFetch
//
//  Created by Jonathan Rasmusson Work Pro on 2020-03-16.
//  Copyright © 2020 Rasmusson Software Consulting. All rights reserved.
//

import CoreData


internal struct CoreDataManager {

    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataSample")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }

        return container
    }()

    @discardableResult
    func createUserdetails(name: String,email: String, password:String) -> Userdetails? {
        let context = persistentContainer.viewContext
        
        let userdetails = NSEntityDescription.insertNewObject(forEntityName: "Userdetails", into: context) as! Userdetails // NSManagedObject

        userdetails.name = name
        userdetails.email = email
        userdetails.password = password

        do {
            try context.save()
            return userdetails
        } catch let createError {
            print("Failed to create: \(createError)")
        }

        return nil
    }

    func fetchUserdetailss() -> [Userdetails]? {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Userdetails>(entityName: "Userdetails")

        do {
            let details = try context.fetch(fetchRequest)
            return details
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
        }

        return nil
    }
    
    func createFetchRequest() -> NSFetchRequest<Userdetails> {
        return NSFetchRequest<Userdetails>(entityName: "Userdetails")
    }

    func fetchUserDetails(withEmail email: String) -> Userdetails? {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Userdetails>(entityName: "Userdetails")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let gamess = try context.fetch(fetchRequest)
            return gamess.first
        } catch let fetchError {
            print("Failed to fetch: \(fetchError)")
        }

        return nil
    }

    func updateUserdetails(userdetails: Userdetails) {
        let context = persistentContainer.viewContext

        do {
            try context.save()
        } catch let createError {
            print("Failed to update: \(createError)")
        }
    }

    func deleteUserdetails(userdetails: Userdetails) {
        let context = persistentContainer.viewContext
        context.delete(userdetails)

        do {
            try context.save()
        } catch let saveError {
            print("Failed to delete: \(saveError)")
        }
    }

    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}


