import SwiftUI

extension UserDefaults {
    @objc dynamic var username: String {
        get { return string(forKey: "username") ?? "" }
        set { set(newValue, forKey: "username") }
    }
    
    @objc dynamic var email: String {
        get { return string(forKey: "email") ?? "" }
        set { set(newValue, forKey: "email") }
    }
    
    @objc dynamic var nightMode: Bool {
        get { return bool(forKey: "nightMode") }
        set { set(newValue, forKey: "nightMode") }
    }
    
    @objc dynamic var fontSize: Int {
        get { return integer(forKey: "fontSize") }
        set { set(newValue, forKey: "fontSize") }
    }
    
    @objc dynamic var notificationEnabled: Bool {
        get { return bool(forKey: "notificationEnabled") }
        set { set(newValue, forKey: "notificationEnabled") }
    }
}


struct SettingsView: View {
    // 用户设置页面
    
    @AppStorage("username") private var username: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("nightMode") private var nightMode: Bool = false
    @AppStorage("fontSize") private var fontSize: Int = 14
    @AppStorage("notificationEnabled") private var notificationEnabled: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    // 假设您已经定义了字体大小选项的数组
    let fontSizes = [12, 14, 16, 18, 20, 22, 24]
    
    var body: some View {
        NavigationView {
            Form {
//                // 用户信息设置
//                Section(header: Text("用户信息")) {
//                    TextField("用户名", text: $username)
//                    TextField("邮箱", text: $email)
//                }
                
                // 阅读偏好设置
                Section(header: Text("阅读偏好")) {
                    Toggle("夜间模式", isOn: $nightMode)
                    Picker("字体大小", selection: $fontSize) {
                        ForEach(fontSizes, id: \.self) { size in
                            Text("\(size)")
                        }
                    }
                }
                
                // 推送通知设置
                Section(header: Text("推送通知")) {
                    Toggle("开启推送通知", isOn: $notificationEnabled)
                }
                
                // 关于页面入口
                Section {
                    NavigationLink(destination: AboutView()) {
                        Text("关于")
                    }
                }
            }
            .navigationBarTitle("设置")
            //.navigationBarItems(trailing: Button("关闭") {
                // 在这里添加保存设置的逻辑
                
                //presentationMode.wrappedValue.dismiss()
            //})
        }
    }
}

