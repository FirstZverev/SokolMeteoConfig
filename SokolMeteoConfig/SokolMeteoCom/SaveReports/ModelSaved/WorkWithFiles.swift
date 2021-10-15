//
//  WorkWithFiles.swift
//  SOKOL
//
//  Created by Володя Зверев on 16.04.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import Foundation

class WorkWithFiles: NSObject {
    
    static var urlFiles: [URL]?
    static var countFiles: [Int]?

    static func nameFile(index: Int) -> String? {
        return urlFiles?[index].lastPathComponent
    }

    static func sizeFile(index: Int) -> String? {
        let attr = try? FileManager.default.attributesOfItem(atPath: (urlFiles?[index].path)!)
        let size = attr?[FileAttributeKey.size] as! UInt64
            return Units(bytes: size).getReadableUnit()
    }
    static func countFile(isBlackBox: Bool, completion: @escaping () -> Void ) {
        countFiles?.removeAll()
        countFiles = Array()
        guard let sorted = urlFiles else { completion(); return}
        for url in sorted {
            let attr = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            if attr?.count == 0 {
                deleteFolder(url: url)
            } else {
                countFiles?.append(attr!.count)
            }
        }
        sortedFilesForFolder(isBackBox: isBlackBox) {
            completion()
        }

    }
    static func dateFile(index: Int) -> String? {
        let attr = try? FileManager.default.attributesOfItem(atPath: (urlFiles?[index].path)!)
        let today = attr?[FileAttributeKey.modificationDate] as? Date
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "HH:mm E, d MMM y"
        return formatter1.string(from: today!)
    }

    static func share(index: Int, completion: @escaping (_ filesToShare: [Any]) -> () ) {
        var filesToShare = [Any]()
        guard let url = urlFiles?[index] else {return}
        filesToShare.append(url)
        
        completion(filesToShare)
    }
    
    static func createFile(name: String, isBackBox: Bool, completion: @escaping (_ dataPath: URL) -> () ) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(isBackBox ? "blackbox" :"reports")
        if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)

            } catch {
                print(error.localizedDescription)
            }
        }
        let dataPathNext = dataPath.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: dataPathNext.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPathNext.path, withIntermediateDirectories: true, attributes: nil)

            } catch {
                print(error.localizedDescription)
            }
        }
        completion(dataPathNext)
    }
    static func deleteFolder(url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
    static func deleteFile(index: Int, isBackBox: Bool, name: String, completion: @escaping () -> Void ) {
        guard let url = urlFiles?[index] else {return}
        try? FileManager.default.removeItem(at: url)
        sortedFiles(isBackBox: isBackBox, nameFolder: name)
        completion()
    }
    
    public static func sortedFiles(isBackBox: Bool, nameFolder: String) {
//        urlFiles = FileManager.default.urls(for: .documentDirectory)?.filter{ $0.lastPathComponent.hasPrefix( isBackBox ? "Черный" : "Отчет") }
        urlFiles = FileManager.default.urls(for: .documentDirectory, name: nameFolder, isBackBox: isBackBox)?.filter{ $0.lastPathComponent.hasPrefix( isBackBox ? "Черный" : "Отчет")}
        let sortedName = urlFiles!.map { url in
            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
        }
        .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
        .map { $0.0 } // extract file names
        urlFiles?.removeAll()
        for name in sortedName {
            urlFiles?.append((FileManager.default.urls(for: .documentDirectory, name: nameFolder, isBackBox: isBackBox)?.filter{ $0.lastPathComponent == name }.first)!)
        }
    }
    public static func sortedFilesForFolder(isBackBox: Bool, completion: @escaping () -> Void ) {
//        urlFiles = FileManager.default.urls(for: .documentDirectory)?.filter{ $0.lastPathComponent.hasPrefix( isBackBox ? "Черный" : "Отчет") }

        urlFiles = FileManager.default.urlsForFolder(for: .documentDirectory, isBackBox: isBackBox)?.filter{ $0.hasDirectoryPath}
        
        let sortedName = urlFiles?.map { url in
            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
        }
        .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
        .map { $0.0 } // extract file names
        urlFiles?.removeAll()
        guard let sorted = sortedName else { completion(); return}
        for name in sorted {
            urlFiles?.append((FileManager.default.urlsForFolder(for: .documentDirectory, isBackBox: isBackBox)?.filter{ $0.lastPathComponent == name }.first)!)
        }
        completion()
    }
}
extension URL {
    var isHidden: Bool {
        get {
            return (try? resourceValues(forKeys: [.isHiddenKey]))?.isHidden == true
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.isHidden = newValue
            do {
                try setResourceValues(resourceValues)
            } catch {
                print("isHidden error:", error)
            }
        }
    }
}
extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, name: String, isBackBox: Bool, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0].appendingPathComponent(isBackBox ? "blackbox" : "reports", isDirectory: true).appendingPathComponent(name, isDirectory: false)
        print(documentsURL.path)
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
//            let fileURLs = try directory.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            return fileURLs
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }//        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
        return []
    }
    func urlsForFolder(for directory: FileManager.SearchPathDirectory, isBackBox: Bool, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0].appendingPathComponent(isBackBox ? "blackbox" : "reports", isDirectory: true)
//        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        print(documentsURL.path)
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])

        return fileURLs
    }
}
