# Plan

## Goal

A Metro-inspired interface for a complete operating system: fast, tactile,
flat, and built around a home screen of tiles. It should work on desktops,
laptops, phones, and other screens, and be more than a launcher: a space
the user shapes with their own monitoring and information widgets.

"Finished" for this repository means a prototype good enough to live in
daily, which then becomes the shell of a real system.

## Principles

1. **Content before decoration.** Flat colour, sharp rectangles, strong
   type. No blur, shadows, or rounded corners.
2. **Fast and tactile.** Every touch or click gets an immediate response,
   and motion stays smooth whatever else is happening.
3. **One layout for every screen.** The same tile grid reflows from phone
   to large monitor.
4. **Every input is complete.** Touch, mouse, and keyboard can each do
   everything.
5. **Discoverable.** No action exists only behind an invisible gesture.
6. **Widgets are guests.** A tile's content comes from outside the shell
   through a fixed contract, so a broken widget cannot freeze the shell.

## Milestones

| # | Milestone | State |
|---|---|---|
| 1 | Desktop home screen, static | active |
| 2 | Motion and interaction on the home screen | later |
| 3 | One layout for every screen size and input type | later |
| 4 | Live tiles: the widget contract and a first tile with real data | later |
| 5 | System surfaces: status, notifications, quick settings, lock screen, app list | later |
| 6 | Real shell: runs on Linux and manages other programs' windows | later |
| 7 | Own system image and first phone hardware | later |

Milestones after the active one are an outline. Each gets planned in detail
when it becomes active.

## Active milestone: 1. Desktop home screen, static

**Delivers:** the home screen as it looks on a 1920×1080 desktop: a
titled page of tiles in groups, in four sizes, that scrolls sideways. Tiles
show a label and a placeholder mark and react to hover and press. Nothing
launches yet and no tile shows live data.

**Why this first:** it puts the look on screen so it can be judged, and it
creates the theme and tile components everything later is built from.

**Tasks:**

| Task | Title |
|---|---|
| 001 | Home screen with a static tile grid |

More tasks for this milestone are added after 001 is reviewed.
