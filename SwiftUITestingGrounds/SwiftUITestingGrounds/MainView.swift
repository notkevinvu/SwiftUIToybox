//
//  MainView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/9/24.
//

import SwiftUI

struct MainView: View {

    @EnvironmentObject var randomVm: RandomViewModel

    @State var searchText: String = ""
    @State var shouldShowFormView: Bool = false
    @Environment(\.isSearching) var isSearching

    @State var listViewType: ListViewType = .list
    enum ListViewType: CaseIterable {
        case list
        case map

        var display: String {
            switch self {
            case .list:
                "List"
            case .map:
                "Map"
            }
        }
    }

    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.blue)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.white)], for: .normal)
    }

    var body: some View {
        mainContent
    }

    @State var shouldShowProgressCell: Bool = false

    @ViewBuilder
    var mainContent: some View {
        VStack(spacing: 0) {
            topButtonSection

            List {
                if shouldShowProgressCell {
                    ProgressView("Loading something...")
                }

                ForEach(MainRoute.allCases, id: \.self) { route in
                    NavigationLink(route.title, value: route)
                }
            }
            .searchDictationBehavior(.automatic)
        }
        .navigationTitle("Main")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Show forms") {
                    shouldShowFormView = true
                }
            }
        }
        .sheet(isPresented: $shouldShowFormView) {
            FormView()
        }
        .searchable(text: $searchText)
    }

    @ViewBuilder
    var topButtonSection: some View {
        HStack(alignment: .center) {
            Picker("", selection: $listViewType) {
                ForEach(ListViewType.allCases, id: \.self) { listViewType in
                    Text(listViewType.display)
                        .foregroundStyle(.white)
                        .tag(listViewType)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                shouldShowProgressCell.toggle()
            } label: {
                HStack(alignment: .center) {
                    Image(systemName: "plus.circle.fill")
                    Text(isSearching ? "SEARCHING" : "HELLO HELLO HELLO")
                        .lineLimit(1)
                }
                .minimumScaleFactor(0.5)

            }
            .minimumScaleFactor(0.5)
            .buttonStyle(.borderedProminent)
            .tint(buttonBackgroundColor)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 38)
        .padding(.horizontal)
        .onChange(of: isSearching) { oldValue, newValue in
            print("IS searching: \(newValue)")
        }
    }
}

let buttonBackgroundColor: Color = Color(red: 69/255, green: 171/255, blue: 255/255, opacity: 1)

#Preview {
    NavigationStack {
        MainView()
            .routableDestination(for: MainRoute.self)
    }
    .environmentObject(RandomViewModel())
    .environment(MainRouter())
    .environment(MapViewModel())
    .environment(ImageCarouselViewModel())
    .preferredColorScheme(.dark)
}

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)  // << here !!
    }
}
