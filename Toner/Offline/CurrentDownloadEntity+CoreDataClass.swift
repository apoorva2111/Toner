//
//  CurrentDownloadEntity+CoreDataClass.swift
//  
//
//  Created by User on 28/10/20.
//
//

import Foundation
import CoreData
import UIKit

@objc(CurrentDownloadEntity)
public class CurrentDownloadEntity: NSManagedObject {
    
    class var context : NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    public class func saveData(data: CurrentDownloadEntityModel){
        let contentdData = NSEntityDescription.insertNewObject(forEntityName: EntityNames.CurrentDownloadEntity, into: context) as! CurrentDownloadEntity
        contentdData.songID = data.contentDetails.songID
        contentdData.songImage = data.contentDetails.songImage
        contentdData.songName = data.contentDetails.songName
        contentdData.songPath = data.contentDetails.songPath
        contentdData.artistImage = data.contentDetails.artistImage
        contentdData.artistName = data.contentDetails.artistName
        contentdData.fileSize = data.contentDetails.fileSize
        contentdData.fileType = data.contentDetails.fileType
        contentdData.songDuration = data.contentDetails.songDuration
        contentdData.downloadStatus = data.downloadStatus
        context.saveContext()
    }
    
    public class func delete(songId: String, isDownloadCompleted: Bool = false){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityNames.CurrentDownloadEntity)
        do{
            if let result = try context.fetch(fetchRequest) as? [CurrentDownloadEntity] {
                for object in result {
                    if object.songID == songId {
                        context.delete(object)
                        if !isDownloadCompleted{
                            ContentDetailsEntity.delete(songId: songId)
                        }
                    }
                }
            }
            
            context.saveContext()
        }
        catch{
            print("Error in Data fetching")
        }
        
    }
    
    public class func fetchData() -> [CurrentDownloadEntityModel]{
        var contentDetailsData = [CurrentDownloadEntityModel]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityNames.CurrentDownloadEntity)
        do{
            let contentData = try context.fetch(fetchRequest) as! [CurrentDownloadEntity]
            let _ = contentData.map {
                
                let contentData = ContentDetailsEntityModel(artistImage: $0.artistImage ?? "", artistName: $0.artistName ?? "", fileSize: $0.fileSize ?? "0", fileType: $0.fileType ?? "mp3", songDuration: $0.songDuration ?? "0", songID: $0.songID ?? "", songImage: $0.songImage ?? "", songName: $0.songName ?? "", songPath: $0.songPath ?? "")
                let data = CurrentDownloadEntityModel(contentDetails: contentData, downloadStatus: $0.downloadStatus ?? "")
                contentDetailsData.append(data)
            }
        }catch{
            print("Error in Data fetching")
        }
        return contentDetailsData
    }
    
    public class func fetchData(songId: String) -> CurrentDownloadEntityModel{
        var currentDownloadData = CurrentDownloadEntityModel()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityNames.CurrentDownloadEntity)
        do{
            let contentData = try context.fetch(fetchRequest) as! [CurrentDownloadEntity]
            
            let _ = contentData.first { (currentContent) -> Bool in
                if currentContent.songID == songId{
                    let contentData = ContentDetailsEntityModel(artistImage: currentContent.artistImage ?? "", artistName: currentContent.artistName ?? "", fileSize: currentContent.fileSize ?? "0", fileType: currentContent.fileType ?? "mp3", songDuration: currentContent.songDuration ?? "0", songID: currentContent.songID ?? "", songImage: currentContent.songImage ?? "", songName: currentContent.songName ?? "", songPath: currentContent.songPath ?? "")
                    let data = CurrentDownloadEntityModel(contentDetails: contentData, downloadStatus: currentContent.downloadStatus ?? "")
                    currentDownloadData = data
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
    
    public class func update(data: CurrentDownloadEntityModel){
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityNames.CurrentDownloadEntity)
        do{
            if let result = try context.fetch(fetchRequest) as? [CurrentDownloadEntity] {
                for object in result {
                    if object.songID == data.contentDetails.songID {
                        object.songID = data.contentDetails.songID
                        object.songImage = data.contentDetails.songImage
                        object.songName = data.contentDetails.songName
                        object.songPath = data.contentDetails.songPath
                        object.artistImage = data.contentDetails.artistImage
                        object.artistName = data.contentDetails.artistName
                        object.fileSize = data.contentDetails.fileSize
                        object.fileType = data.contentDetails.fileType
                        object.songDuration = data.contentDetails.songDuration
                        object.downloadStatus = data.downloadStatus
                        object.downloadStatus = data.downloadStatus
                    }
                }
            }
            
            context.saveContext()
        }
        catch{
            print("Error in Data fetching")
        }

    }

    
}


public struct CurrentDownloadEntityModel{
    var contentDetails: ContentDetailsEntityModel = ContentDetailsEntityModel()
    var downloadStatus: String = ""
}
