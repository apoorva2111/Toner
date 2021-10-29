//
//  TonneruDownloadManager.swift
//  Toner
//
//  Created by User on 24/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation
import Alamofire
import UserNotifications

class TonneruDownloadManager: NSObject{
    
    private override init(){}
    public static let shared    = TonneruDownloadManager()
    public var delegate: TonneruDownloadManagerDelegate?

    fileprivate var downloadManager: DownloadManager?

    fileprivate func download(data: ContentDetailsEntityModel, videoUrl: String){
        
        guard let downloadURL = URL(string: videoUrl) else{
            print("Not a downloadable url")
            return
        }
        
        ContentDetailsEntity.saveData(with: data)
        downloadImage(data: data)
        downloadImage(data: data, isArtist: true)
        downloadVideo(data: data, url: downloadURL)
        
        
    }
    
    
    
    fileprivate func downloadVideo(data: ContentDetailsEntityModel, url: URL){
        
        
        if var currentDownloadElement = CurrentDownloadEntity.fetchData().filter({ (currentDownloadData) -> Bool in
            return currentDownloadData.contentDetails.songID == data.songID
        }).first{
            currentDownloadElement.downloadStatus = DownloadStatus.downloading
            CurrentDownloadEntity.update(data: currentDownloadElement)
        }
        
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = DownloadDirectory.audios!
            let fileExtension = url.lastPathComponent
            let filePath = NSString(string: (fileExtension))
            let fileURL = documentsURL.appendingPathComponent(filePath as String)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        
        downloadManager = Alamofire.download(url, to: destination)
            .downloadProgress(closure: { (progress) in
                print("Progress: \(progress.fractionCompleted)")
                
                if CurrentDownloadEntity.fetchData().count > 0{
                    if (CurrentDownloadEntity.fetchData()[0].contentDetails.songID != data.songID){
                        self.downloadManager?.cancel()
                        self.downloadManager?.suspend()
                        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                            sessionDataTask.forEach { $0.cancel() }
                            uploadData.forEach { $0.cancel() }
                            downloadData.forEach { $0.cancel() }
                        }
                    }else{
                        self.delegate!.tonneruDownloadManager(progress: Float(progress.fractionCompleted), content: CurrentDownloadEntity.fetchData()[0])
                        if progress.fractionCompleted == 1.0{
                            let _ = CurrentDownloadEntity.fetchData()[0]
                            CurrentDownloadEntity.delete(songId: data.songID, isDownloadCompleted: true)
                            self.downloadCompleteNotification(data: data, message: "\(data.songName) has been downloaded successfully")
                        }
                    }
                    
                }else{
                    self.downloadManager?.cancel()
                    self.downloadManager?.suspend()
                    Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                        sessionDataTask.forEach { $0.cancel() }
                        uploadData.forEach { $0.cancel() }
                        downloadData.forEach { $0.cancel() }
                    }
                }
            })
            .response { (defaultDownloadResponse) in
                
                if defaultDownloadResponse.response?.statusCode == 200 {
                    CurrentDownloadEntity.delete(songId: data.songID, isDownloadCompleted: true)
                    var currentData = ContentDetailsEntity.fetchData(songId: data.songID)
                    currentData.songPath = defaultDownloadResponse.destinationURL?.lastPathComponent ?? ""
                    ContentDetailsEntity.update(data: currentData)
                    self.checkForNextDownload()
                    
                }
        }
        
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - data: Content Details Data
    ///   - isPoster: Indicator for Poster or Banner. Default value false,
    ///   - isParent: <#isParent description#>
    fileprivate func downloadImage(data: ContentDetailsEntityModel, isArtist: Bool = false){
        
        guard var url = URL(string: data.songImage) else{
            print("Not a downloadable URL")
            return
        }
        if isArtist{
            guard let url1 = URL(string: data.artistImage) else{
                print("Not a downloadable URL")
                return
            }
            url = url1
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = DownloadDirectory.images!
            let fileName = ((data.songID) + url.lastPathComponent)
            let filePath = NSString(string: fileName)
            let fileURL = documentsURL.appendingPathComponent(filePath as String)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        
        
        Alamofire.download(url, to: destination)
            .response { (defaultDownloadResponse) in
                
                if defaultDownloadResponse.response?.statusCode == 200 {
                    var contentDetailsData = ContentDetailsEntity.fetchData(songId: data.songID)
                    if isArtist{
                        contentDetailsData.artistImage = defaultDownloadResponse.destinationURL?.lastPathComponent ?? ""
                    }else{
                        contentDetailsData.songImage = defaultDownloadResponse.destinationURL?.lastPathComponent ?? ""
                    }
                    ContentDetailsEntity.update(data: contentDetailsData)
                }
        }
    }

    
    func addDownloadTask(data: ContentDetailsEntityModel){
        guard URL(string: data.songPath) != nil else{
            print("Not a downloadable url")
            return
        }
        
        print("FileSize is :\(ByteCountFormatter.string(fromByteCount: Int64(data.fileSize) ?? 0, countStyle: .file))")
        
        
        let downloadStatus = CurrentDownloadEntity.fetchData().count > 0 ? DownloadStatus.pending : DownloadStatus.downloading
        
        
        CurrentDownloadEntity.saveData(data: CurrentDownloadEntityModel(contentDetails: data, downloadStatus: downloadStatus))
        
        if downloadStatus == DownloadStatus.downloading{
            checkForNextDownload()
        }
    }
    
    func download(data: ContentDetailsEntityModel){
        guard URL(string: data.songPath) != nil else{
            print("Not a downloadable url")
            return
        }
        print("FileSize is :\(ByteCountFormatter.string(fromByteCount: Int64(data.fileSize) ?? 0, countStyle: .file))")
        ContentDetailsEntity.saveData(with: data)
    }

    func cancelDownload(){
        print("Download cancell called")
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
        self.downloadManager?.cancel()
        self.downloadManager?.suspend()
        checkForNextDownload()
    }
    
 
    
    fileprivate func checkForNextDownload(){
        
        if CurrentDownloadEntity.fetchData().count > 0{
            let currentDownloadData = CurrentDownloadEntity.fetchData()[0]
            
            download(data: currentDownloadData.contentDetails, videoUrl: currentDownloadData.contentDetails.songPath)
        }else{
            
        }
    }
    
    fileprivate func downloadCompleteNotification(data: ContentDetailsEntityModel, message: String) {
        let content = UNMutableNotificationContent()
        content.title = data.songName
        content.body = message
        content.sound = UNNotificationSound.default
        content.threadIdentifier = data.artistName
        if #available(iOS 12.0, *) {
            content.summaryArgument  = data.artistName
        } else {
            // Fallback on earlier versions
        }
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 2.0, repeats: false)
        let request = UNNotificationRequest(identifier:"downloadsuccess\(data.songID)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription as Any)
            }
        }
    }
}

protocol TonneruDownloadManagerDelegate{
//    func muviDownloadManager(downloadManager: DownloadManager, progress: Progress, content: CurrentDownloadEntityModel)
    func tonneruDownloadManager(progress: Float, content: CurrentDownloadEntityModel)
}

//extension MuviDownloadManagerDelegate{
//    func muviDownloadManager(progress: Float, content: CurrentDownloadEntityModel){}
//}

typealias DownloadManager = Alamofire.Request

extension TonneruDownloadManager: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if notification.request.identifier.starts(with: "downloadsuccess"){
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

