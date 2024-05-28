//
//  AddView.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 13/05/24.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    @State var textFieldString: String = ""
    
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false

    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Item description ", text: $textFieldString)
                    .frame(height: 55)
                    .padding(.horizontal)
                    .background(Color(.systemGray6))
                .cornerRadius(10)
                Button(action: saveItems, label: {
                    Text("Save")
                        .foregroundStyle(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                })
            }
            .padding(14)
        }
        .navigationTitle("Add an Item")
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
    func saveItems() {
        if textIsValid() {
            listViewModel.addItem(title: textFieldString)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func textIsValid() -> Bool {
        if textFieldString.count < 3 {
            alertTitle = "Invalid word count. Must be 3 and above"
            showAlert.toggle()
            return false
        }
        return true
    }
}

#Preview {
    NavigationStack {
        AddView()
    }
    .environmentObject(ListViewModel())
}
