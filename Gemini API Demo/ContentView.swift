//
//  ContentView.swift
//  Gemini API Demo
//
//  Created by Juhi Chitkara on 1/17/25.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    @State var userPrompt = ""
    @State var response: LocalizedStringKey = "What would you like to upcycle today?"
    @State var isLoading = false
    
    var body: some View {
        VStack {
            Image(.upcRemovebgPreview)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding()
            ZStack {
                ScrollView {
                    Text(response)
                        .font(.title)
                        .lineLimit(nil)
                        
                }
                .frame(maxHeight: 300)
                
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                        .scaleEffect(4)
                }
            }
            
            Spacer()
            
            TextField("I want to upcycle...", text: $userPrompt, axis: .vertical)
                .lineLimit(5)
                .font(.title)
                .padding()
                .background(Color.indigo.opacity(0.2), in: Capsule())
                .disableAutocorrection(true)
                .onSubmit {
                    generateResponse()
                }
        }
        .padding()
    }
    
    func generateResponse(){
        isLoading = true
        response = ""
        
        Task{
            do {
                let result = try await model.generateContent("How can I upcycle "+userPrompt)
                isLoading = false
                response = LocalizedStringKey(result.text ?? "No response found")
                userPrompt = ""
            } catch {
                response = "Something went wrong\n\(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    ContentView()
}

