import Foundation

class UserService {
    private let fileName = "rss"
    
    func loadRssFile() -> String? {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            // 如果文件不存在，可以在这里创建一个新文件或返回默认值
            return nil
        }
        
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            return content
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    func saveRssFile(content: String) {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing file: \(error)")
        }
    }
}

