import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("关于我们")
                .font(.largeTitle)
                .padding()
            
            Text("这是一个简单的关于页面，您可以在这里添加有关您的应用程序的信息。123")
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
    }
}


