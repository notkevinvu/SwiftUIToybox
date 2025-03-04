//
//  PickerViewStuff.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 2/20/25.
//

import SwiftUI

struct PickerViewStuff: View {
    
    @State private var categories: [Category] = [
        .init(parentEventId: UUID(), name: "Food"),
        .init(parentEventId: UUID(), name: "Drinks"),
        .init(parentEventId: UUID(), name: "Transportation"),
        .init(parentEventId: UUID(), name: "Miscellaneous"),
        .init(parentEventId: UUID(), name: "Clothing"),
        .init(parentEventId: UUID(), name: "Home"),
    ]
    
    @State private var selectedCategory: Category = .init(parentEventId: UUID(), name: "Initial") {
        didSet {
            print("current category: \(selectedCategory.name)")
        }
    }
    @State private var isCategoryPickerAlertPresented = false
    
    var body: some View {
        ScrollView {
            HStack {
                Button {
                    isCategoryPickerAlertPresented.toggle()
                } label: {
                    Text("Choose category")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            
            categoryList
            
            LabeledContent {
                Picker("Selected category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.name)
                    }
                }
            } label: {
                Text("Categories")
                    .padding()
            }
            .background(.regularMaterial, in: .rect(cornerRadius: 12))
            
            Menu {
                Picker("Selected category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.name)
                    }
                }
            } label: {
                Text("Selected Category: \(selectedCategory.name)")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
        }
        .contentMargins(
            .all,
            .init(top: 16, leading: 16, bottom: 48, trailing: 16),
            for: .scrollContent
        )
        .task {
            if let firstCategory = categories.first {
                selectedCategory = firstCategory
            }
        }
        .sheet(isPresented: $isCategoryPickerAlertPresented) {
            categoryPickerAlertView
        }
    }
    
    @ViewBuilder
    private var categoryList: some View {
        ForEach(categories, id: \.id) { category in
            HStack {
                Text(category.name)
                    .font(.system(size: 16))
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    private var categoryPickerAlertView: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    isCategoryPickerAlertPresented = false
                }
                Spacer()
                Button("Save") {
                    print("Chose category: \(selectedCategory.name)")
                }
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Picker(selection: $selectedCategory) {
                ForEach(categories, id: \.id) { category in
                    Text(category.name)
                        .tag(category.id)
                }
            } label: {
                Text("Category picker")
            }
        }
        .padding()
    }
}

#Preview {
    PickerViewStuff()
}


