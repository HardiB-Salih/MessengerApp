//
//  StorageManager.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/10/24.
//

import Foundation
import FirebaseStorage

let StorageManager = _StorageManager()
final class _StorageManager {
    
    private let storage = Storage.storage().reference()
    public enum StorageError: Error {
        case failedToUpload
        case failedToGetDownloadURL
        
    }
    
    /*
     /images/hardi-gmail-com_profile_picture.png
     */
    public typealias UploadPictureCompletion = (Result<String, Error>)
    /// Upload picture to firebase storage and return completion wirh url sting to download.
    public func uploadProfilePicture(with data: Data,
                                     fileName: String,
                                     completion: @escaping ResultCompletion<String> ) {
        let imageReference = storage.child("images/\(fileName)")
        
        imageReference.putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                print("Failed to upload data to Firebase for picture:", error!)
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            imageReference.downloadURL(completion: { url, error in
                guard let downloadURL = url, error == nil else {
                    print("Failed to get download URL:", error!)
                    completion(.failure(StorageError.failedToGetDownloadURL))
                    return
                }
                
                let urlString = downloadURL.absoluteString
                print("download url returned : \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    
    public func downloadUrl(for path: String, completion: @escaping ResultCompletion<URL>) {
        let imageReference = storage.child(path)
        imageReference.downloadURL(completion: { url, error in
            guard let downloadURL = url, error == nil else {
                print("Failed to get download URL:", error!)
                completion(.failure(StorageError.failedToGetDownloadURL))
                return
            }
            completion(.success(downloadURL))
        })
    }
}
