//
//  FormView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/11/24.
//

import SwiftUI

struct FormView: View {
    
    @State var name: String = ""
    @State var description: String = ""
    @State var notes: String = "Line1\nLine2"
    
    @State var shouldShowSecondFormView: Bool = false
    
    var body: some View {
        formFields
            .sheet(isPresented: $shouldShowSecondFormView) {
                TestMapView()
                    .padding()
            }
    }
    
    @ViewBuilder
    var formFields: some View {
        Form {
            Group {
                Section {
                    TextField("Required", text: $name)
                } header: {
                    HStack(alignment: .center) {
                        Text("Event name")
                        
                        Image("asteriskCustom")
                            .foregroundStyle(.red)
                            
                    }
                }
                
                
                Section {
                    TextField("Optional", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("Description")
                }
                
                Section {
                    TextField("Optional", text: $notes, axis: .vertical)
                        .lineLimit(2...2)
                        .disabled(true)
                } header: {
                    HStack {
                        Text("Notes")
                        Spacer()
                        
                        Menu("Test title") {
                            Button("Show map") {
                                shouldShowSecondFormView = true
                            }
                        }
                    }
                }
                
                Section {
                    Menu {
                        Button("Test") {
                            print("Hello")
                        }
                    } label: {
                        Text("[28.20524, -80.12568]")
                            .lineLimit(2, reservesSpace: true)
                            .contentShape(.rect)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundStyle(.primary)
                } header: {
                    Text("Button Test")
                }
            }
            .textCase(.none)
            .listRowInsets(.none)
        }
    }
}

#Preview {
    FormView()
}
