//
//  MainView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/9/24.
//

import SwiftUI

struct MainView: View {
    
    @Environment(Router.self) var router
    let routerDestinations = Router.Destination.allCases
    
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
        navStackBaseView
    }
    
    @State var shouldShowProgressCell: Bool = false
    
    @ViewBuilder
    var navStackBaseView: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.navPath) {
            
            topButtonSection
            
            List {
                if shouldShowProgressCell {
                    ProgressView("Loading something...")
                }
                
                ForEach(routerDestinations, id: \.self) { destination in
                    NavigationLink(destination.title, value: destination)
                }
            }
            .searchDictationBehavior(.automatic)
            
            .navigationDestination(for: Router.Destination.self) { destination in
                router.determineView(for: destination)
                    .navigationTitle(destination.title)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Show forms") {
                        shouldShowFormView = true
                    }
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

// MARK: -- Tab
struct TestTabView: View {
    
    @Environment(Router.self) var router
    
    @State var tabBarOffset: CGFloat = 0
    
    var body: some View {
        tabView
    }
    
    @ViewBuilder
    var tabView: some View {
        @Bindable var router = router
        
        TabView(selection: $router.selectedTab) {
            Group {
                MainView()
                    .tabItem {
                        Label("Main", systemImage: "person")
                    }
                    .tag(Router.TabDestination.main)
                    .toolbarBackground(.clear, for: .bottomBar)
                
                TestMapView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .tag(Router.TabDestination.map)
                    .toolbarBackground(.clear, for: .bottomBar)
                
                PhotoPickerView()
                    .tabItem {
                        Label("Photos", systemImage: "photo")
                    }
                    .tag(Router.TabDestination.photoPicker)
                    .toolbarBackground(.clear, for: .bottomBar)
                
                ProgressView("Showing videos...")
                    .tabItem {
                        Label("Videos", systemImage: "video")
                    }
                    .tag(Router.TabDestination.videos)
                    .toolbarBackground(.clear, for: .bottomBar)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        print("bottom button")
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.white, .blue)
                    }
                }
            }
            
        }
        .onChange(of: router.selectedTab) { oldValue, newValue in
            switch newValue {
                case .videos:
                    router.selectedTab = oldValue
                    router.videoTabPresented = true
                default: return
            }
        }
        .sheet(isPresented: $router.videoTabPresented) {
            RandomView()
        }
        
    }
}

#Preview {
    MainView()
//    TestTabView()
        .environmentObject(RandomViewModel())
        .environment(Router())
        .environment(MapViewModel())
        .preferredColorScheme(.dark)
}

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)  // << here !!
    }
}
