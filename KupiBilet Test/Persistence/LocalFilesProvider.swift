//
//  LocalFilesProvider.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Foundation
import Zip

// MARK: - LocalFilesProvider
final class LocalFilesProvider {
    // MARK: Properties
    enum CustomErrors: Error {
        case cannotDecodeString
        case cannotSaveData(Error)
        case cannotUnzipFile(Error)
        case cannotReadFile
    }
    
    var filesDirectory: URL {
        let directoryURLs = self.fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        let documentsDirectory = directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
        return documentsDirectory
    }
    
    // MARK: Private properties
    private let fileManager: FileManager
    private let decoder: JSONDecoder
    
    // MARK: Initialization
    init() {
        self.fileManager = FileManager.default
        self.decoder = JSONDecoder()
    }
    
    // MARK: Methods
    func getArchiveURL() -> URL {
        var filesDirectory = self.filesDirectory
        filesDirectory.appendPathComponent("base64archive")
        filesDirectory.appendPathExtension("zip")
        return filesDirectory
    }
    
    func getEncodedFileURL() -> URL {
        var filesDirectory = self.filesDirectory
        filesDirectory.appendPathComponent("disconnect_teploset")
        filesDirectory.appendPathExtension("json")
        return filesDirectory
    }
    
    func isFileExists(
        atURL url: URL
    ) -> Bool {
        let path = url.path
        return self.fileManager.fileExists(atPath: path)
    }
    
    func readFile<T:Decodable>(
        atURL url: URL,
        ofType type: T.Type
    ) -> [T]? {
        guard self.isFileExists(atURL: url) else {
            assertionFailure(
                "Cannot find file at: \(url)."
            )
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            assertionFailure(
                "Cannot obtain data from file at: \(url)."
            )
            return nil
        }
        
        guard let objects = try? self.decoder.decode([T].self, from: data) else {
            assertionFailure("Cannot convert \(data) to \(String(describing: T.self))")
            return nil
        }
        return objects
    }
    
    func saveArchiveIfNeeded(
        usingBase64EncodedString encodedString: String,
        then handler: @escaping (VoidResult) -> Void
    ) {
        let archiveURL = self.getArchiveURL()
        guard !self.isFileExists(
            atURL: archiveURL
        ) else {
            // If file already exists, simply bail out.
            handler(.success)
            return
        }
        self.decodeAndSaveArchive(
            usingBase64EncodedString: encodedString
        ) { (result) in
            switch result {
            case .success:
                self.unzipArchive(
                    atURL: archiveURL
                ) { (result) in
                    switch result {
                    case .success:
                        handler(.success)
                    case .failure(let unzipingError):
                        handler(.failure(unzipingError))
                    }
                }
            case .failure(let savingError):
                handler(.failure(savingError))
            }
        }
    }
    
    // MARK: Private methods
    private func decodeAndSaveArchive(
        usingBase64EncodedString encodedString: String,
        then handler: @escaping (VoidResult) -> Void
    ) {
        guard let dataToZip = Data(base64Encoded: encodedString) else {
            let error = CustomErrors.cannotDecodeString
            handler(.failure(error))
            return
        }
        let archiveURL = self.getArchiveURL()
        do {
            try dataToZip.write(
                to: archiveURL
            )
            handler(.success)
        } catch {
            print("cannot save data at: \(archiveURL)")
            let error = CustomErrors.cannotSaveData(error)
            handler(.failure(error))
        }
    }
    
    private func unzipArchive(
        atURL url: URL,
        then handler: @escaping (VoidResult) -> Void
    ) {
        let documentsDirectory = self.filesDirectory
        
        do {
            try Zip.unzipFile(
                url,
                destination: documentsDirectory,
                overwrite: false,
                password: nil
            )
            handler(.success)
        } catch {
            let error = CustomErrors.cannotUnzipFile(error)
            handler(.failure(error))
        }
    }
}
