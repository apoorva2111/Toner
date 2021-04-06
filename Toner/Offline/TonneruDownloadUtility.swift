//
//  TonneruDownloadUtility.swift
//  Toner
//
//  Created by User on 28/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation
import CoreData


public enum DownloadDirectory{
    static let audios =  DocumentDirectory?.appendingPathComponent("audios")
    static let images = DocumentDirectory?.appendingPathComponent("images")
}

public enum DownloadStatus{
    static let download = "downloading"
    static let downloading = "downloading"
    static let downloaded = "downloaded"
    static let pending = "pending"
}

public enum EntityNames{
    static let ContentDetailsEntity = "ContentDetailsEntity"
    static let CurrentDownloadEntity = "CurrentDownloadEntity"
}

extension NSManagedObjectContext{
    func saveContext(){
        do{
            try save()
        }
        catch{
            print("Not save")
        }
    }
}

public let HomeDirectory = URL(fileURLWithPath: NSHomeDirectory())
public let DocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
