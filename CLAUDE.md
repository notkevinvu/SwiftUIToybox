# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI experimentation repository containing two separate Xcode projects:

- **SwiftUIToyBox** - A structured iOS app demonstrating clean architecture patterns with dependency injection, networking, and MVVM
- **SwiftUITestingGrounds** - A playground for testing various SwiftUI features, UI components, and interaction patterns

## Build Commands

Both projects are standard Xcode projects. Open in Xcode and build/run from there:
```bash
open SwiftUIToyBox/SwiftUIToybox.xcodeproj
open SwiftUITestingGrounds/SwiftUITestingGrounds.xcodeproj
```

## Architecture

### SwiftUIToyBox Architecture

Uses clean architecture with dependency injection via Swinject:

- **DIContainer** (`Core/DIContainer.swift`) - Singleton that registers and resolves all dependencies at app launch. Uses `.container` scope for shared instances (services, providers) and `.transient` scope for ViewModels
- **NetworkService** - Protocol-based networking layer with `RestNetworkServiceAdapter` implementation. Uses `EndpointPath` protocol for defining API endpoints
- **Provider Pattern** - Data providers (e.g., `PostProvider`) abstract data fetching from ViewModels
- **ViewState Enum** - ViewModels use an enum-based state machine pattern (`initial`, `loading`, `empty`, `success`, `error`) with computed properties for state checks

Key utility: `Binding.presence()` extension converts optional bindings to Bool bindings for presenting alerts/sheets without extra state variables.

### SwiftUITestingGrounds Architecture

- **Router** (`Router.swift`) - Observable class managing NavigationStack paths and TabView selection. Uses `@Bindable` for SwiftUI integration with `@Observable` macro
- **Environment-based DI** - ViewModels injected via `@Environment` and `@EnvironmentObject` from the app entry point
- **ViewModels** - Mix of `@Observable` (newer) and `ObservableObject` (older) patterns

### SwiftUI Patterns Used

- **Hero Animations** - `PreferenceKey` pattern (`HeroKey`) for coordinating source/destination anchors across view hierarchy
- **Custom View Modifiers** - Reusable modifiers in `Modifiers/` (e.g., `ToastViewModifier`)
- **Scroll Position Tracking** - `didFrameChange` modifier using `GeometryReader` and preference keys to detect item visibility in scroll views
- **Image Extensions** - `squareOriginalAspectRatioImage()` and `rectangularRoundedImage()` for consistent image styling

## External Dependencies

- **Swinject** - Dependency injection framework (SwiftUIToyBox only)

## Workflow Requirements

### PR Handling
- **Always include PR links**: When working with PRs, the final line(s) of any response MUST include link(s) to the PR(s) being handled
- **Feature/bugfix branches**: Always run `/full-pr-review` when working with feature or bugfix branches
- **Documentation-only changes**: Do not require full PR review workflow

### Parallel Agents
When the user requests parallel agents, immediately spawn multiple concurrent agents using the Task tool with multiple tool calls in a single message.

### Clarifying Questions
When asking clarifying questions, always use the AskUserQuestion tool to present options in the answer picker UI. Do not list questions as plain text.

### Feature Development
When using `/feature-dev`, leverage `/full-pr-review` for the PR review phase rather than basic review commands.

### Commit Strategy
Commit work in logical chunks for easier commit history digestion. Before moving to the PR review phase in `/feature-dev`, ensure all work is committed in logical, digestible chunks. Each commit should represent a coherent unit of change.

## Custom Slash Commands

Located in `.claude/commands/`:

| Command | Purpose |
|---------|---------|
| `/sync-main` | Switch to main branch and pull latest from remote |
| `/full-pr-review` | Complete PR workflow: create, review, fix, CI check, document |
| `/update-session` | Update `docs/SESSION_SUMMARY.md` with recent work and next steps |

### /full-pr-review Workflow
1. Create PR with descriptive title/summary
2. Run PR review and post findings as comment
3. Fix critical/major issues (always), minor issues (if quick or no major issues)
4. Second review cycle with fixes
5. Monitor CI and fix failures
6. Update related docs
7. Report summary with PR link(s) as final line

**Max 2 review-fix cycles** without additional prompting.
