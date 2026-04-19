# Canvas Timeline Implementation

## What Was Built

### 1. New Canvas-Style Timeline (`canvas_timeline.dart`)
Replaced the old discrete hour-slot timeline with a continuous canvas view similar to MS Teams calendar.

**Key Features:**
- **40-Minute Intervals**: Grid lines and time labels every 40 minutes instead of hourly blocks
- **Continuous Canvas**: Full 24-hour view (0:00 - 23:59) with smooth scrolling
- **Visual Time Grid**: Custom painter draws interval lines and time labels
- **Current Time Indicator**: Red line shows current time position
- **Pixel-Perfect Positioning**: 1.5 pixels per minute (2160px total height for 24 hours)

### 2. Drag-and-Drop from Task Pool
Tasks can be dragged from the task pool and dropped anywhere on the timeline.

**How It Works:**
1. Long-press a task in the task pool to start dragging
2. Hover over the timeline - see a semi-transparent preview box showing where the task will land
3. Preview box shows:
   - Task title
   - Duration (based on estimated minutes)
   - Download icon indicator
4. Drop the task - it creates a schedule item at that exact time
5. Task duration is calculated from `estimatedMinutes` (default 60 min)

### 3. Resizable Schedule Items
Schedule items on the canvas can be resized by dragging the bottom handle.

**How It Works:**
- Each scheduled item has a grey handle bar at the bottom
- Drag the handle down to extend duration
- Drag up to shorten duration
- Items maintain their start time while end time adjusts

### 4. Movable Schedule Items
Schedule items can be repositioned by dragging the item body.

**How It Works:**
- Click and drag the main body of a schedule item
- Item moves vertically along the timeline
- Duration is preserved during moves
- Release to update the schedule

### 5. Enhanced Layout
**Task Pool:**
- Increased height from 400px to 700px for better visibility
- More room to see and filter tasks

**Timeline:**
- Fills all available vertical space
- Internally scrollable to navigate full 24-hour day
- No more constrained to 17 hours (6am-11pm)

## Technical Details

### Positioning Calculation
```dart
pixelsPerMinute = 1.5
totalHeight = 24 * 60 * 1.5 = 2160px

// To get time from Y position:
minutes = yPosition / pixelsPerMinute
hour = minutes / 60
minute = minutes % 60

// To get Y position from time:
yPosition = (hour * 60 + minute) * pixelsPerMinute
```

### Key Components

**TimeGridPainter:**
- Custom painter for drawing 40-minute interval grid
- Draws horizontal lines at each interval
- Renders time labels (e.g., "9 AM", "9:40", "10:20", "11 AM")

**DragTarget:**
- Wraps entire canvas to accept Task objects
- `onWillAccept`: Validates the dragged data
- `onAccept`: Creates schedule item at drop position
- Uses `MouseRegion` to track hover position

**Schedule Item Widget:**
- Positioned absolutely based on start time
- Height calculated from duration
- `GestureDetector` for drag/resize interactions
- Visual feedback during interaction (opacity, cursor changes)

### File Structure
```
lib/features/today/
├── presentation/
│   ├── today_page.dart (updated to use CanvasTimeline)
│   └── widgets/
│       ├── canvas_timeline.dart (NEW)
│       ├── task_pool_panel.dart (updated with drag source)
│       └── hour_slot_timeline.dart (OLD - can be removed)
```

## Usage Instructions

### Drag Task to Timeline
1. Open Today page
2. Scroll task pool to find desired task
3. **Long-press** on task card (hold for ~0.5s)
4. **Drag** over to timeline on the left
5. **Hover** to see preview placement
6. **Release** to drop and schedule

### Resize Scheduled Item
1. Find a scheduled item on the timeline
2. Look for grey handle bar at bottom
3. **Click and drag** handle down to extend
4. **Drag up** to shorten
5. **Release** to save new duration

### Move Scheduled Item
1. Find a scheduled item on the timeline
2. **Click and hold** on the item body (not the handle)
3. **Drag up or down** to new time slot
4. **Release** to move

### Complete/Delete Schedule Item
- **Checkbox** (left side): Toggle completion status
- **Trash icon** (right side): Delete the schedule item

## Visual Design

### Color Scheme
- **Grid lines**: Light grey (`AppColors.border`)
- **Time labels**: Grey text (`AppColors.textSecondary`)
- **Current time**: Orange indicator (`AppColors.primary`)
- **Schedule items**: Teal border (`AppColors.accent`)
- **Completed items**: Green tint (`AppColors.success`)
- **Drop preview**: Semi-transparent orange (`AppColors.primary` at 20%)

### Typography
- **Time labels**: 11px, medium weight
- **Schedule item title**: 14px, semi-bold
- **Schedule item time**: 11px, regular

### Spacing
- **Time label offset**: 70px from left (leaves room for labels)
- **Schedule item padding**: 12px all sides
- **Interval height**: 60px (40 minutes * 1.5 px/min)
- **Resize handle**: 20px tall, bottom of item

## Known Limitations & Future Enhancements

### Current Limitations
1. Resize/move updates don't persist yet (database update code commented with "Will implement")
2. No collision detection between overlapping schedule items
3. Can't drag items across days
4. No undo/redo functionality

### Planned Enhancements
1. **Snap to Intervals**: Snap drop/resize to nearest 5 or 10-minute mark
2. **Conflict Detection**: Visual warning when items overlap
3. **Multi-Day Drag**: Drag tasks to future days
4. **Recurring Items**: Support for repeating schedule items
5. **Color Coding**: Different colors per task priority or domain
6. **Zoom Levels**: Toggle between compact (1px/min) and spacious (2px/min) views

## Comparison: Old vs New

| Feature | Old (Hour Slots) | New (Canvas) |
|---------|------------------|--------------|
| Time intervals | 1 hour blocks | 40 minute intervals |
| View range | 6 AM - 11 PM (17 hours) | 12 AM - 11:59 PM (24 hours) |
| Positioning | Discrete slots | Continuous, pixel-perfect |
| Drag-drop | Drop on hour slot only | Drop anywhere on timeline |
| Resize | Not supported | Drag handle to resize |
| Move | Not supported | Drag to reposition |
| Visual style | Discrete boxes | Flowing canvas |
| Task pool height | 400px | 700px |

## Performance Considerations

- **Custom painter** for grid (more efficient than many widgets)
- **Positioned widgets** for schedule items (better than Stack with Container)
- **Lazy rendering**: Only visible portion is rendered (SingleChildScrollView)
- **Minimal rebuilds**: State managed carefully to avoid unnecessary repaints

## Dependencies

No new dependencies added. Uses existing:
- `flutter_riverpod` for state management
- `lucide_icons_flutter` for icons
- Flutter's built-in `CustomPainter`, `DragTarget`, `Draggable`

---

**Status**: ✅ Core functionality implemented, pending database persistence for resize/move operations

