//
//  ParentChildRouterExample.swift
//  SwiftUITestingGrounds
//
//  Created by Claude on 11/20/25.
//
//  This file demonstrates a parent-child router architecture pattern for SwiftUI
//  navigation. This pattern provides:
//  - Centralized navigation management
//  - Modular feature-based routing
//  - Type-safe navigation between features
//  - Dependency injection for child routers
//  - Cross-module navigation support
//

import SwiftUI

// MARK: - Route Protocol

/// Base protocol for all route types. Each feature module defines its own routes
/// conforming to this protocol.
protocol RouteProtocol: Hashable, Identifiable {
    var id: String { get }
}

extension RouteProtocol {
    var id: String { String(describing: self) }
}

// MARK: - Router Protocol

/// Base protocol for all routers. Defines common navigation operations.
protocol RouterProtocol: AnyObject {
    associatedtype Route: RouteProtocol
    var path: [Route] { get set }

    func navigate(to route: Route)
    func pop()
    func popToRoot()
}

extension RouterProtocol {
    func navigate(to route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}

// MARK: - App-Level Routes

/// Top-level routes for the entire application.
/// These represent the main sections/tabs of the app.
enum AppRoute: RouteProtocol {
    case home
    case profile
    case settings
    case onboarding

    var title: String {
        switch self {
        case .home: return "Home"
        case .profile: return "Profile"
        case .settings: return "Settings"
        case .onboarding: return "Onboarding"
        }
    }
}

// MARK: - Feature-Specific Routes

/// Routes for the Home feature module
enum HomeRoute: RouteProtocol {
    case feed
    case postDetail(id: String)
    case userProfile(userId: String)
    case comments(postId: String)
    case createPost

    var title: String {
        switch self {
        case .feed: return "Feed"
        case .postDetail: return "Post Detail"
        case .userProfile: return "User Profile"
        case .comments: return "Comments"
        case .createPost: return "Create Post"
        }
    }
}

/// Routes for the Profile feature module
enum ProfileRoute: RouteProtocol {
    case overview
    case editProfile
    case followers
    case following
    case savedPosts
    case activityHistory

    var title: String {
        switch self {
        case .overview: return "Profile"
        case .editProfile: return "Edit Profile"
        case .followers: return "Followers"
        case .following: return "Following"
        case .savedPosts: return "Saved Posts"
        case .activityHistory: return "Activity"
        }
    }
}

/// Routes for the Settings feature module
enum SettingsRoute: RouteProtocol {
    case main
    case account
    case notifications
    case privacy
    case appearance
    case about

    var title: String {
        switch self {
        case .main: return "Settings"
        case .account: return "Account"
        case .notifications: return "Notifications"
        case .privacy: return "Privacy"
        case .appearance: return "Appearance"
        case .about: return "About"
        }
    }
}

// MARK: - Parent Router (App Router)

/// The root router that sits at the core of the app.
/// It manages top-level navigation and coordinates child routers.
@Observable
final class AppRouter {

    // MARK: - App-Level State

    /// Current selected tab
    var selectedTab: AppRoute = .home

    /// Navigation path for modal presentations at app level
    var appPath: [AppRoute] = []

    /// Sheet presentation state
    var presentedSheet: AppRoute?

    /// Full screen cover state
    var presentedFullScreenCover: AppRoute?

    // MARK: - Child Routers

    /// Child routers are lazy-loaded and cached
    private(set) lazy var homeRouter: HomeRouter = {
        HomeRouter(parentRouter: self)
    }()

    private(set) lazy var profileRouter: ProfileRouter = {
        ProfileRouter(parentRouter: self)
    }()

    private(set) lazy var settingsRouter: SettingsRouter = {
        SettingsRouter(parentRouter: self)
    }()

    // MARK: - Navigation Methods

    /// Switch to a different tab
    func switchTab(to tab: AppRoute) {
        selectedTab = tab
    }

    /// Present a sheet at the app level
    func presentSheet(_ route: AppRoute) {
        presentedSheet = route
    }

    /// Dismiss the current sheet
    func dismissSheet() {
        presentedSheet = nil
    }

    /// Present a full screen cover
    func presentFullScreenCover(_ route: AppRoute) {
        presentedFullScreenCover = route
    }

    /// Dismiss full screen cover
    func dismissFullScreenCover() {
        presentedFullScreenCover = nil
    }

    /// Navigate to a specific route within a feature from anywhere in the app
    /// This enables cross-module navigation
    func navigateToHome(route: HomeRoute) {
        selectedTab = .home
        homeRouter.navigate(to: route)
    }

    func navigateToProfile(route: ProfileRoute) {
        selectedTab = .profile
        profileRouter.navigate(to: route)
    }

    func navigateToSettings(route: SettingsRoute) {
        selectedTab = .settings
        settingsRouter.navigate(to: route)
    }

    /// Reset all navigation state
    func resetAllNavigation() {
        selectedTab = .home
        appPath.removeAll()
        presentedSheet = nil
        presentedFullScreenCover = nil
        homeRouter.popToRoot()
        profileRouter.popToRoot()
        settingsRouter.popToRoot()
    }

    /// Get the appropriate child router for a tab
    func router(for tab: AppRoute) -> any RouterProtocol {
        switch tab {
        case .home: return homeRouter
        case .profile: return profileRouter
        case .settings: return settingsRouter
        case .onboarding: return homeRouter // fallback
        }
    }
}

// MARK: - Child Routers

/// Router for the Home feature module
@Observable
final class HomeRouter: RouterProtocol {
    typealias Route = HomeRoute

    var path: [HomeRoute] = []

    /// Reference to parent for cross-module navigation
    private weak var parentRouter: AppRouter?

    init(parentRouter: AppRouter? = nil) {
        self.parentRouter = parentRouter
    }

    // MARK: - Home-Specific Navigation

    func showPostDetail(id: String) {
        navigate(to: .postDetail(id: id))
    }

    func showUserProfile(userId: String) {
        navigate(to: .userProfile(userId: userId))
    }

    func showComments(for postId: String) {
        navigate(to: .comments(postId: postId))
    }

    func showCreatePost() {
        navigate(to: .createPost)
    }

    // MARK: - Cross-Module Navigation

    /// Navigate to the user's own profile (switches to Profile tab)
    func navigateToOwnProfile() {
        parentRouter?.navigateToProfile(route: .overview)
    }

    /// Navigate to settings
    func navigateToSettings() {
        parentRouter?.navigateToSettings(route: .main)
    }
}

/// Router for the Profile feature module
@Observable
final class ProfileRouter: RouterProtocol {
    typealias Route = ProfileRoute

    var path: [ProfileRoute] = []

    private weak var parentRouter: AppRouter?

    init(parentRouter: AppRouter? = nil) {
        self.parentRouter = parentRouter
    }

    // MARK: - Profile-Specific Navigation

    func showEditProfile() {
        navigate(to: .editProfile)
    }

    func showFollowers() {
        navigate(to: .followers)
    }

    func showFollowing() {
        navigate(to: .following)
    }

    func showSavedPosts() {
        navigate(to: .savedPosts)
    }

    func showActivityHistory() {
        navigate(to: .activityHistory)
    }

    // MARK: - Cross-Module Navigation

    /// Navigate to a specific user's profile in the Home feed
    func navigateToUserInFeed(userId: String) {
        parentRouter?.navigateToHome(route: .userProfile(userId: userId))
    }

    /// Navigate to account settings
    func navigateToAccountSettings() {
        parentRouter?.navigateToSettings(route: .account)
    }
}

/// Router for the Settings feature module
@Observable
final class SettingsRouter: RouterProtocol {
    typealias Route = SettingsRoute

    var path: [SettingsRoute] = []

    private weak var parentRouter: AppRouter?

    init(parentRouter: AppRouter? = nil) {
        self.parentRouter = parentRouter
    }

    // MARK: - Settings-Specific Navigation

    func showAccount() {
        navigate(to: .account)
    }

    func showNotifications() {
        navigate(to: .notifications)
    }

    func showPrivacy() {
        navigate(to: .privacy)
    }

    func showAppearance() {
        navigate(to: .appearance)
    }

    func showAbout() {
        navigate(to: .about)
    }

    // MARK: - Cross-Module Navigation

    /// Navigate back to profile
    func navigateToProfile() {
        parentRouter?.navigateToProfile(route: .overview)
    }

    /// Sign out and reset all state
    func signOut() {
        parentRouter?.resetAllNavigation()
        // Additional sign out logic here
    }
}

// MARK: - Example Views

/// Root view that sets up the router and tab navigation
struct ParentChildRouterExampleView: View {
    @State private var appRouter = AppRouter()

    var body: some View {
        TabView(selection: Binding(
            get: { appRouter.selectedTab },
            set: { appRouter.switchTab(to: $0) }
        )) {
            // Home Tab
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(AppRoute.home)

            // Profile Tab
            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(AppRoute.profile)

            // Settings Tab
            SettingsTabView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(AppRoute.settings)
        }
        .environment(appRouter)
        .environment(appRouter.homeRouter)
        .environment(appRouter.profileRouter)
        .environment(appRouter.settingsRouter)
        .sheet(item: Binding(
            get: { appRouter.presentedSheet },
            set: { _ in appRouter.dismissSheet() }
        )) { route in
            sheetContent(for: route)
        }
    }

    @ViewBuilder
    private func sheetContent(for route: AppRoute) -> some View {
        switch route {
        case .onboarding:
            OnboardingSheetView()
        default:
            EmptyView()
        }
    }
}

// MARK: - Home Tab Views

struct HomeTabView: View {
    @Environment(HomeRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            HomeFeedView()
                .navigationDestination(for: HomeRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .feed:
            HomeFeedView()
        case .postDetail(let id):
            PostDetailView(postId: id)
        case .userProfile(let userId):
            UserProfileView(userId: userId)
        case .comments(let postId):
            CommentsView(postId: postId)
        case .createPost:
            CreatePostView()
        }
    }
}

struct HomeFeedView: View {
    @Environment(HomeRouter.self) private var router
    @Environment(AppRouter.self) private var appRouter

    var body: some View {
        List {
            Section("Posts") {
                ForEach(1...5, id: \.self) { index in
                    Button("Post \(index)") {
                        router.showPostDetail(id: "post-\(index)")
                    }
                }
            }

            Section("Actions") {
                Button("Create New Post") {
                    router.showCreatePost()
                }

                Button("View My Profile") {
                    router.navigateToOwnProfile()
                }

                Button("Go to Settings") {
                    router.navigateToSettings()
                }
            }
        }
        .navigationTitle("Feed")
    }
}

struct PostDetailView: View {
    @Environment(HomeRouter.self) private var router
    let postId: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Post: \(postId)")
                .font(.title)

            Button("View Comments") {
                router.showComments(for: postId)
            }
            .buttonStyle(.borderedProminent)

            Button("View Author Profile") {
                router.showUserProfile(userId: "author-123")
            }
            .buttonStyle(.bordered)
        }
        .navigationTitle("Post Detail")
    }
}

struct UserProfileView: View {
    let userId: String

    var body: some View {
        VStack {
            Text("User Profile")
                .font(.title)
            Text("User ID: \(userId)")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("User")
    }
}

struct CommentsView: View {
    let postId: String

    var body: some View {
        List {
            ForEach(1...10, id: \.self) { index in
                Text("Comment \(index) on \(postId)")
            }
        }
        .navigationTitle("Comments")
    }
}

struct CreatePostView: View {
    @Environment(HomeRouter.self) private var router

    var body: some View {
        VStack(spacing: 20) {
            Text("Create New Post")
                .font(.title)

            Button("Save & Go Back") {
                router.pop()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("New Post")
    }
}

// MARK: - Profile Tab Views

struct ProfileTabView: View {
    @Environment(ProfileRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            ProfileOverviewView()
                .navigationDestination(for: ProfileRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: ProfileRoute) -> some View {
        switch route {
        case .overview:
            ProfileOverviewView()
        case .editProfile:
            EditProfileView()
        case .followers:
            FollowersView()
        case .following:
            FollowingView()
        case .savedPosts:
            SavedPostsView()
        case .activityHistory:
            ActivityHistoryView()
        }
    }
}

struct ProfileOverviewView: View {
    @Environment(ProfileRouter.self) private var router

    var body: some View {
        List {
            Section("Profile") {
                Button("Edit Profile") {
                    router.showEditProfile()
                }

                Button("Followers") {
                    router.showFollowers()
                }

                Button("Following") {
                    router.showFollowing()
                }
            }

            Section("Content") {
                Button("Saved Posts") {
                    router.showSavedPosts()
                }

                Button("Activity History") {
                    router.showActivityHistory()
                }
            }

            Section("Cross-Module") {
                Button("Account Settings") {
                    router.navigateToAccountSettings()
                }
            }
        }
        .navigationTitle("Profile")
    }
}

struct EditProfileView: View {
    @Environment(ProfileRouter.self) private var router

    var body: some View {
        VStack {
            Text("Edit Profile")
                .font(.title)

            Button("Save Changes") {
                router.pop()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Edit")
    }
}

struct FollowersView: View {
    @Environment(ProfileRouter.self) private var router

    var body: some View {
        List {
            ForEach(1...20, id: \.self) { index in
                Button("Follower \(index)") {
                    router.navigateToUserInFeed(userId: "follower-\(index)")
                }
            }
        }
        .navigationTitle("Followers")
    }
}

struct FollowingView: View {
    var body: some View {
        List {
            ForEach(1...15, id: \.self) { index in
                Text("Following \(index)")
            }
        }
        .navigationTitle("Following")
    }
}

struct SavedPostsView: View {
    @Environment(HomeRouter.self) private var homeRouter
    @Environment(AppRouter.self) private var appRouter

    var body: some View {
        List {
            ForEach(1...10, id: \.self) { index in
                Button("Saved Post \(index)") {
                    // Navigate to post detail in Home tab
                    appRouter.navigateToHome(route: .postDetail(id: "saved-\(index)"))
                }
            }
        }
        .navigationTitle("Saved Posts")
    }
}

struct ActivityHistoryView: View {
    var body: some View {
        List {
            ForEach(1...25, id: \.self) { index in
                Text("Activity \(index)")
            }
        }
        .navigationTitle("Activity")
    }
}

// MARK: - Settings Tab Views

struct SettingsTabView: View {
    @Environment(SettingsRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            SettingsMainView()
                .navigationDestination(for: SettingsRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: SettingsRoute) -> some View {
        switch route {
        case .main:
            SettingsMainView()
        case .account:
            AccountSettingsView()
        case .notifications:
            NotificationSettingsView()
        case .privacy:
            PrivacySettingsView()
        case .appearance:
            AppearanceSettingsView()
        case .about:
            AboutView()
        }
    }
}

struct SettingsMainView: View {
    @Environment(SettingsRouter.self) private var router

    var body: some View {
        List {
            Section("General") {
                Button("Account") {
                    router.showAccount()
                }

                Button("Notifications") {
                    router.showNotifications()
                }

                Button("Privacy") {
                    router.showPrivacy()
                }

                Button("Appearance") {
                    router.showAppearance()
                }
            }

            Section("Info") {
                Button("About") {
                    router.showAbout()
                }
            }

            Section("Actions") {
                Button("Back to Profile") {
                    router.navigateToProfile()
                }

                Button("Sign Out", role: .destructive) {
                    router.signOut()
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct AccountSettingsView: View {
    var body: some View {
        List {
            Text("Email: user@example.com")
            Text("Username: @user")
            Text("Phone: +1 234 567 8900")
        }
        .navigationTitle("Account")
    }
}

struct NotificationSettingsView: View {
    @State private var pushEnabled = true
    @State private var emailEnabled = false

    var body: some View {
        Form {
            Toggle("Push Notifications", isOn: $pushEnabled)
            Toggle("Email Notifications", isOn: $emailEnabled)
        }
        .navigationTitle("Notifications")
    }
}

struct PrivacySettingsView: View {
    var body: some View {
        List {
            Text("Privacy Policy")
            Text("Data Usage")
            Text("Blocked Users")
        }
        .navigationTitle("Privacy")
    }
}

struct AppearanceSettingsView: View {
    var body: some View {
        List {
            Text("Theme")
            Text("Font Size")
            Text("App Icon")
        }
        .navigationTitle("Appearance")
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Parent-Child Router Example")
                .font(.title)
            Text("Version 1.0.0")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("About")
    }
}

struct OnboardingSheetView: View {
    @Environment(AppRouter.self) private var appRouter

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome!")
                .font(.largeTitle)

            Text("This is an onboarding flow")

            Button("Get Started") {
                appRouter.dismissSheet()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    ParentChildRouterExampleView()
}
