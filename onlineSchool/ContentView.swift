//
//  ContentView.swift
//  onlineSchool
//
//  Created by waitwalker on 2021/1/19.
//

/// 教程https://github.com/Jinxiansen/SwiftUI/blob/master/README_CN.md
/// 版权属于原作者

import SwiftUI

let github = "https://github.com/"


struct ContentView: View {
    var body: some View {
        /// 纵向容器布局
        VStack(alignment: .center, spacing: 15, content: {
            /// Text 用来展示一行或多行的文本内存,效果等同于UILabel,但更加优秀
            /// 如果要创建Text,只需要通过Text("SwiftUI)即可创建;采用链式语法,也可以为文本添加多项属性,如字体,颜色,阴影,间距等
            Text("Hello, world!")
                .bold()
                .font(.system(size: 22))
                .fontWeight(.medium)
                .italic()
                .shadow(color: .orange, radius: 1, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2.0)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            
            Text(github)
                .underline(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: /*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
            
            HStack(content: {
                Text("1")
                Text("2")
                Text("3")
            })
            
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
