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
7. **One surface.** Opening an app rearranges what is already on screen;
   it does not put a window on top. Home and apps are built from the same
   parts.
8. **Flexible without overlap.** An app can fill the screen or sit on
   Home at a smaller size. It is always a region on the grid, never a
   floating window covering something else.

## Milestones

| # | Milestone | State |
|---|---|---|
| 1 | Desktop home screen, static: bar, panels, tiles | active |
| 2 | Motion and interaction on the home screen | later |
| 3 | One layout for every screen size and input type | later |
| 4 | Live tiles: the widget contract and a first tile with real data | later |
| 5 | System surfaces: status, notifications, quick settings, lock screen, app list | later |
| 6 | Real shell: runs on Linux and manages other programs' windows | later |
| 7 | Own system image and first phone hardware | later |

Milestones after the active one are an outline. Each gets planned in detail
when it becomes active.

## Active milestone: 1. Desktop home screen, static

**Delivers:** our own home as it looks on a 1920×1080 desktop: an
always-visible bar and a home of three panels (Now, Apps, All apps), built
from flat tiles in four sizes. The Metro Start screen from task 001 is kept
beside it as a reference. Nothing launches yet and nothing shows live data.

**Why this first:** it puts the look on screen so it can be judged, and it
creates the theme, tile, bar, and panel components everything later is
built from.

**Tasks:**

| Task | Title |
|---|---|
| 001 | Home screen with a static tile grid (now the reference screen) |
| 002 | Our home: the bar and three panels |
| 003 | Give the OS its own colour |
| 004 | Opening an app rearranges the home (Files prototype) |
| 005 | An app can sit on Home in a small size (Files prototype) |
| 006 | More apps, from one list (Music and Photos) |
| — | A Settings app, with the first new control: a switch (not briefed yet) |
| — | First placeholder widgets in the Now panel (not briefed yet) |
