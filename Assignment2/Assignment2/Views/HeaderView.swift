//
//  HeaderView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import SwiftUI

struct HeaderView: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let angle: Double
    let backColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(backColor)
                .rotationEffect(Angle(degrees: angle))
            VStack {
                Text(title)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .bold()
                Text(subtitle)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .padding(.top, 30)
        }
        .frame(width: UIScreen.main.bounds.width * 3,
               height: 300)
        .offset(y: -100)
    }
}

#Preview {
    HeaderView(title: "Todo List", subtitle: "SwiftUI is awesome", angle: 15, backColor: .blue)
}
