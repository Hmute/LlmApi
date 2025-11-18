import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Text("About This App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("COMP 4977 — Assignment 2")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Divider()
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Team Members:")
                    .font(.title3)
                    .bold()
                
                Text("• Heraldo Abreu")
                Text("• Amal Allaham")
                Text("• Mitchell MacDonald")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AboutView()
}
