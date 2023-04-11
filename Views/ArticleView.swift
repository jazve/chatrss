import SwiftUI
import RichText
import Introspect

struct ArticleView: View {
    @ObservedObject var viewModel: ArticleViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // 显示发布日期
                    Text("发布于: \(viewModel.currentArticle?.publishDate ?? Date(), formatter: dateFormatter)")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    // 显示文章标题
                    Text(viewModel.currentArticle?.title ?? "")
                        .font(.title)
                        .fontWeight(.bold)

                    // 显示作者信息
                    Text("作者: \(viewModel.currentArticle?.author ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // 渲染 HTML 内容
                    RichText(html: viewModel.currentArticle?.content ?? "")
                        .lineHeight(170)
                        .colorScheme(.auto)
                        .imageRadius(10)
                        .linkColor(light: Color.blue, dark: Color.blue)
                        .colorPreference(forceColor: .onlyLinks)
                        .linkOpenType(.SFSafariView())
                        .customCSS("img { max-width: 100%; height: auto; }")
                        .frame(maxWidth: 700, alignment: .center)
                }
                .frame(maxWidth: 800, alignment: .center)
                .padding(.vertical, 25)
                .padding(.horizontal, 25)
                
            }
            .background(Color(.systemBackground).ignoresSafeArea())
            .edgesIgnoringSafeArea(.bottom)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 100 {
                            // 右滑返回上一篇文章
                            viewModel.previousArticle()
                        } else if value.translation.width < -100 {
                            // 左滑切换到下一篇文章
                            viewModel.nextArticle()
                        }
                    }
            )
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    // 显示返回按钮
                    Image(systemName: "chevron.backward")
                        .imageScale(.large)
                        .frame(width: 44, height: 44)
                },
                trailing: EmptyView()
            )
        }
        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
    }
    
    // 日期格式化器
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
