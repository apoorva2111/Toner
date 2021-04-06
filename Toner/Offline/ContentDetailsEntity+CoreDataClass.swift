//
//  ContentDetailsEntity+CoreDataClass.swift
//  
//
//  Created by User on 28/10/20.
//
//

import Foundation
import CoreData
import UIKit

@objc(ContentDetailsEntity)
public class ContentDetailsEntity: NSManagedObject {
    
    class var context : NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    public class func saveData(with data: ContentDetailsEntityModel){
        
        let contentdData = NSEntityDescription.insertNewObject(forEntityName: EntityNames.ContentDetailsEntity, into: context) as! ContentDetailsEntity
        contentdData.songID = data.songID
        contentdData.songImage = data.songImage
        contentdData.songName = data.songName
        contentdData.songPath = data.songPath
        contentdData.artistImage = data.artistImage
        contentdData.artistName = data.artistName
        contentdData.fileSize = data.fileSize
        contentdData.fileType = data.fileType
        contentdData.songDuration = data.songDuration
        context.saveContext()
    }
    
    public class func delete(songId: String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityNames.ContentDetailsEntity)
        do{
            if let result = try context.fetch(fetchRequest) as? [ContentDetailsEntity] {
                for object in result {
                    if object.songID == songId {
                        context.delete(object)
                        //Delete Files
                    }
                }
            }
            
            context.saveContext()
        }
        catch{
            print("Error in Data fetching")
        }
        
    }
    
    public class func fetchData() -> [ContentDetailsEntityModel]{
        var contentDetailsData = [ContentDetailsEntityModel]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityNames.ContentDetailsEntity)
        do{
            let contentData = try context.fetch(fetchRequest) as! [ContentDetailsEntity]
            let _ = contentData.map {
                
                let contentData = ContentDetailsEntityModel(artistImage: $0.artistImage ?? "", artistName: $0.artistName ?? "", fileSize: $0.fileSize ?? "0", fileType: $0.fileType ?? "mp3", songDuration: $0.songDuration ?? "0", songID: $0.songID ?? "", songImage: $0.songImage ?? "", songName: $0.songName ?? "", songPath: $0.songPath ?? "")
                contentDetailsData.append(contentData)
            }
        }catch{
            print("Error in Data fetching")
        }
        return contentDetailsData
    }
    
    public class func fetchData(songId: String) -> ContentDetailsEntityModel{
        var currentDownloadData = ContentDetailsEntityModel()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityNames.ContentDetailsEntity)
        do{
            let contentData = try context.fetch(fetchRequest) as! [ContentDetailsEntity]
            
            let _ = contentData.first { (currentContent) -> Bool in
                if currentContent.songID == songId{
                    let contentData = ContentDetailsEntityModel(artistImage: currentContent.artistImage ?? "", artistName: currentContent.artistName ?? "", fileSize: currentContent.fileSize ?? "0", fileType: currentContent.fileType ?? "mp3", songDuration: currentContent.songDuration ?? "0", songID: currentContent.songID ?? "", songImage: currentContent.songImage ?? "", songName: currentContent.songName ?? "", songPath: currentContent.songPath ?? "")
                    currentDownloadData = contentData
                    return true
                }
                return false
            }
            return currentDownloadData
        }catch{
            print("Error in Data fetching")
        }
        return currentDownloadData
    }
    
    public class func update(data: ContentDetailsEntityModel){
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityNames.ContentDetailsEntity)
        do{
            if let result = try context.fetch(fetchRequest) as? [ContentDetailsEntity] {
                for object in result {
                    if object.songID == data.songID {
                        object.songID = data.songID
                        object.songImage = data.songImage
                        object.songName = data.songName
                        object.songPath = data.songPath
                        object.artistImage = data.artistImage
                        object.artistName = data.artistName
                        object.fileSize = data.fileSize
                        object.fileType = data.fileType
                        object.songDuration = data.songDuration
                    }
                }
            }
            
            context.saveContext()
        }
        catch{
            print("Error in Data fetching")
        }
        
    }
    
    fileprivate func deleteFiles(){
        
    }
    
}


public struct ContentDetailsEntityModel{
    var artistImage: String = ""
    var artistName: String = ""
    var fileSize: String = ""
    var fileType: String = ""
    var songDuration: String = ""
    var songID: String = ""
    var songImage: String = ""
    var songName: String = ""
    var songPath: String = ""
}
