# Strategy Experience Feature - Implementation Guide

## Overview

The **Strategy Experience** section has been successfully integrated into the Trek Detail page. This feature displays comprehensive trekking strategies including itineraries, waypoints, altitude data, and packing guides in a premium, user-friendly format.

## Architecture

### File Structure

```
lib/features/trek_detail/
├── domain/models/
│   ├── trek_detail_model.dart (existing)
│   └── strategy_model.dart (NEW) - Strategy, StrategyDetail, StrategyItinerary, StrategyWaypoint, StrategyPacking
│
├── data/repository/
│   ├── trek_detail_mock_repository.dart (existing)
│   └── strategy_remote_repository.dart (NEW) - Remote API integration with mappers
│
├── presentation/widgets/
│   ├── tab_strategy.dart (NEW) - Main orchestrator widget
│   └── strategy_sections/ (NEW)
│       ├── strategy_hero.dart - Premium hero card with key metrics
│       ├── strategy_snapshot.dart - Grid cards with destination info
│       ├── strategy_about.dart - Rich content card with description
│       ├── strategy_highlights.dart - Premium chips for highlights
│       ├── strategy_timeline.dart - Expandable itinerary timeline
│       ├── strategy_route.dart - Horizontal waypoint progression
│       ├── strategy_altitude.dart - Altitude visualization chart
│       ├── strategy_packing_guide.dart - Packing items with categories
│       └── strategy_facts.dart - Quick statistics dashboard
│
└── bloc/
    └── trek_detail_state.dart (MODIFIED) - Added TrekDetailTab.strategy enum
```

### API Endpoints

New endpoints added to `lib/core/constants/api_const.dart`:

```dart
static String getStrategies(String destinationId) 
  => "/api/v1/public/destinations/$destinationId/strategies";
static String getStrategyDetail(String strategyId) 
  => "/api/v1/public/strategies/$strategyId/detail";
static String getStrategyItineraries(String strategyId) 
  => "/api/v1/public/strategies/$strategyId/itineraries";
static String getStrategyWaypoints(String strategyId) 
  => "/api/v1/public/strategies/$strategyId/waypoints";
static String getStrategyPackings(String strategyId) 
  => "/api/v1/public/strategies/$strategyId/packings";
```

## Data Flow

1. **Fetch Strategies List** → Randomly selects one strategy
2. **Fetch Strategy Detail** → Gets name, route type, difficulty, prices, etc.
3. **Parallel Fetch** (Itineraries, Waypoints, Packings)
4. **Render Sections** with data-bound UI components

## UI Sections

### Section 1: Trek Strategy Hero
Premium hero card displaying strategy overview with:
- Strategy name
- Route type, days, distance badges
- Highest point & max altitude metrics
- Gradient background with decorative elements

### Section 2: Trek Snapshot
6-item grid showing:
- Highest Point, Lowest Point, Start Point, End Point
- Access City, Acclimatization Days
Each with color-coded icons

### Section 3: About This Route
Expandable content card with:
- Full trek description
- Difficulty adjustment details
- Clean typography and spacing

### Section 4: Highlights
Premium chip-style display of trek highlights with checkmark icons

### Section 5: Journey Timeline
Expandable day cards showing:
- Route progression (Start → End)
- Duration, temperature, altitude gain
- Full trek details and description when expanded
- Smooth animations on expand/collapse

### Section 6: Route Map Story
Horizontal scrollable waypoint cards with:
- Order badge, name, altitude
- Type indicator
- Optional images
- Visual arrow indicating progression

### Section 7: Altitude Journey
Interactive altitude visualization showing:
- Line chart with area fill
- Grid background
- Legend with Max/Min/Total Climb statistics
- Responsive and smooth rendering

### Section 8: Packing Guide
Organized packing lists by profile with:
- Item count badge
- Equipment chips with checkmark icons
- Color-coded categories

### Section 9: Expedition Facts
6-item dashboard grid displaying:
- Total Days, Total Distance, Max Altitude
- Route Type, Difficulty, Acclimatization Days
- Color-coded icons and values

## Usage

The Strategy tab is automatically integrated into the Trek Detail page. It appears first in the tab list and:

1. **Loads automatically** when the page initializes
2. **Selects a random strategy** if multiple are available
3. **Fetches all related data** in parallel for performance
4. **Displays loading skeletons** while data is being fetched
5. **Shows error state** with retry option if fetch fails

### To Use in Code

```dart
import 'package:flutter/material.dart';
import 'features/trek_detail/bloc/trek_detail_bloc.dart';

// The strategy tab is already integrated
// Access via: TrekDetailTab.strategy
```

## Design System Integration

All components follow the existing project's design system:

- **Colors**: AppColors theme
- **Typography**: Google Fonts (Syne, DM Sans)
- **Spacing**: AppRadius constants
- **Shadows**: AppShadows utilities
- **Gradients**: AppGradients presets

## Performance Considerations

1. **Parallel Data Fetching** - All 4 endpoints (detail, itineraries, waypoints, packings) are fetched concurrently
2. **Lazy Rendering** - Sections only render if data is available
3. **Shimmer Loading States** - Smooth loading experience with animated placeholders
4. **Memoization** - State management prevents unnecessary rebuilds

## Styling Details

### Color Palette Used
- **Primary**: saffron, electricTeal
- **Secondary**: coral, deepGlacier
- **Accents**: glacierBlue, slateGray
- **Backgrounds**: glacierWhite, cardWhite

### Typography Hierarchy
- **Headings**: Syne, 16px,  W800
- **Subheadings**: Syne, 12-14px, W700
- **Body**: DM Sans, 11-13px, W600
- **Captions**: DM Sans, 9-10px, W600

### Spacing Standards
- Full width padding: 16px
- Section gaps: 24px
- Component gaps: 12-14px

## Error Handling

- **Network Error**: Shows icon, message, and retry button
- **Missing Data**: Sections don't render if data is not available
- **Empty Lists**: Graceful handling with conditional rendering

## Future Enhancements

The implementation is flexible for future additions:

1. **Strategy Selector** - UI to choose from multiple strategies
2. **Interactive Map** - Integrate strategy route into a map view
3. **Difficulty Filter** - Allow filtering strategies by difficulty
4. **Bookmarking** - Save favorite strategies
5. **Sharing** - Share strategy with friends
6. **Real-time Updates** - WebSocket for live strategy data
7. **User Reviews** - Reviews specific to each strategy

## Key Files Modified

### trek_detail_state.dart
Added `strategy` to `TrekDetailTab` enum:
```dart
enum TrekDetailTab {
  strategy,  // NEW
  overview,
  routeMap,
  itinerary,
  hotels,
  reviews,
  safety,
}
```

### trek_detail_page.dart
Updated `_TabBody` to handle strategy tab:
```dart
case TrekDetailTab.strategy:
  return TabStrategy(detail: state.detail);
```

## Testing

To test the feature:

1. Navigate to any Trek Detail page
2. The Strategy tab should appear as the first tab
3. Verify loading states appear briefly
4. Verify all 9 sections render correctly
5. Test expandable cards (About section, Timeline days)
6. Test horizontal scrolling (Route Map Story)

## Notes

- Mock data is NOT used for this feature; all data comes from the API
- The implementation is production-ready
- Follows all existing project patterns and conventions
- Fully responsive on different screen sizes
- Animated transitions and smooth interactions throughout

