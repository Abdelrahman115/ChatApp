//
//  StorageManager.swift
//  ChatApp
//
//  Created by Abdelrahman on 11/08/2023.
//


import Foundation
import FirebaseStorage




final class StorageManager{
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
}


// MARK: - Account management
extension StorageManager{
    
    public enum StroageErrors:Error{
        case failedToUpload
        case failedToGetDownloadURL
    }
    //inserts images to storage database and returns completion with url string to download
    public func uploadProfilePicture(with data:Data,fileName:String,completion:@escaping(Result<String,Error>) -> Void){
        storage.child("images/\(fileName)").putData(data) {[weak self] metadata, error in
            guard let self = self else {return}
            guard error == nil else {
                print("Failed to upload picture")
                completion(.failure(StroageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                //guard let self = self else {return}
                guard let url = url else{
                    print("Failed To get download url")
                    completion(.failure(StroageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                //print(urlString)
                completion(.success(urlString))
            }
        }
    }
    
    
    
   
    
}
