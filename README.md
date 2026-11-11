# OSDes

The design prototype for a new operating system interface: one uniform
surface, in the spirit of Metro, that should run on desktops, laptops,
phones, and other screens.

"OSDes" is a working name.

## The vision

Windows 8 and its Metro interface were fast and tactile in a way that later
desktops lost. This project takes what made Metro good and builds a
complete system interface on those ideas, without copying it.

- **One uniform surface.** Every part of the interface is built from the
  same pieces, in the same colour, on the same grid, with the same type.
  Nothing looks like it came from somewhere else.
- **Apps are not windows.** Opening an app does not put a framed window on
  top of a desktop. The home screen rearranges to become the app: the
  headings and menus change to the app's own, its content fills the space,
  and everything else moves aside. Going back plays the same move in
  reverse.
- **Flexible, without overlapping windows.** An app is not forced to fill
  the screen. It can also sit on the home screen at a smaller size, as a
  block on the same grid as everything else, with the rest flowing around
  it. Nothing ever covers anything else.
- **Fast and tactile.** Every click or touch gets an immediate response.
  Motion is short, smooth, and never waits on anything else.
- **Flat and plain.** Solid colour, sharp rectangles, strong type. No
  blur, shadows, gradients, or rounded corners.
- **A distinct colour.** The whole interface is shades of one colour.
  The first one being tried is the Windows 2000 desktop blue, for its
  computer, digital feel.
- **More than a launcher.** Home is a space the user shapes, with their
  own monitoring and information widgets beside their apps.
- **Every screen.** The same design should work on a large monitor and on
  a phone, with touch, mouse, or keyboard.
- **Nothing hidden.** No action exists only behind an invisible gesture.
- **Its own system.** In the long run this is the interface of a complete
  system built directly on the Linux kernel, the way Android is, without
  depending on an existing desktop distribution.

## What exists today

This is an early prototype built in Qt Design Studio. It is an app window
that shows the interface. It does not yet manage other programs.

| Part | State |
|---|---|
| **Bar** — always visible along the bottom: Home, running apps, quick settings, clock | Built, with sample content |
| **Home** — three panels side by side: Now (widgets), Apps (pinned tiles), All apps | Built. Apps shows tiles; the other two are empty |
| **Tiles** — four sizes on one grid | Built |
| **Metro Start reference** — a classic Start screen kept for comparison, reachable from the bar | Built |
| **The OS colour** — Home and the bar as shades of one blue | Built; shades still being tuned |
| **Apps as contexts** — a sample Files app opens by rearranging the home, with no window | Built, with mock data |
| **App sizes** — an app can sit on Home in a small size, with tiles flowing around it | Built, for Files |
| **More apps** — Music and Photos, and every app described by data in one list | Next |
| **Widgets in the Now panel** | Planned |

The live task board is in [`docs/STATUS.md`](docs/STATUS.md).

## Where it is going

| # | Milestone |
|---|---|
| 1 | Desktop home: bar, panels, tiles, colour, and the first app opening as a rearrangement of home, in full and small sizes |
| 2 | Motion and interaction |
| 3 | One layout for every screen size and input type |
| 4 | Live tiles: widgets fed with real data |
| 5 | System surfaces: status, notifications, quick settings, lock screen, app list |
| 6 | A real shell that runs on Linux and hosts other programs |
| 7 | Its own system image, and first phone hardware |

The full plan and principles are in [`docs/PLAN.md`](docs/PLAN.md). The
reasons behind each choice are in [`docs/DECISIONS.md`](docs/DECISIONS.md).

## Run it

1. Install [Qt Design Studio](https://www.qt.io/product/ui-design-tools)
   (the project uses Qt 6.8).
2. Open `OS.qmlproject`.
3. Press Run (Ctrl+R).

## How it is built

The project is run by one person working with AI agents, following
[agent-protocol](https://github.com/starscream000/agent-protocol): a
master chat plans and reviews, worker agents each build one task on its own
branch, and nothing reaches the main branch without a reviewed pull
request. Task briefs are in [`tasks/`](tasks/) and the workers' reports in
[`reports/`](reports/).

## Design assets

The design follows Metro's principles but uses its own assets. No icons,
images, logos, or fonts from Microsoft or anyone else are included.
