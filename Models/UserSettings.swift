struct UserSettings: Codable {
    var username: String
    var email: String
    var nightMode: Bool
    var fontSize: Int
    var notificationEnabled: Bool
    
    // 初始化默认设置
    init() {
        self.username = "Guest"
        self.email = "example@example.com"
        self.nightMode = false
        self.fontSize = 14
        self.notificationEnabled = true
    }
}

