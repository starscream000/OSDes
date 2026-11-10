# Decisions

Newest first. A decision listed here is settled; reopen one only with the
owner.

## 2026-11-11 — The Metro Start screen is kept as a reference

Why: the owner wants the screen from task 001 kept, not deleted, so our own
home can be compared against it. It stays reachable from the bar.
Instead of: replacing it with the new home.

## 2026-11-11 — Widgets and app tiles share one grid

Why: a widget and an app tile use the same sizes and the same grid, so
either can sit anywhere later.
Instead of: a separate widget area with its own sizes.

## 2026-11-11 — Home is three panels: Now, Apps, All apps

Why: "Now" is the owner's space for monitoring and information widgets,
"Apps" holds pinned tiles, and "All apps" is the full list. Panels sit side
by side and the edge of the next one is always visible, so nothing is
hidden behind a gesture.
Instead of: a single Start page of tiles.

## 2026-11-11 — A thin bar is always visible

Why: it holds the Home button, running apps, status, and quick settings.
It keeps the Metro feel while fixing its biggest weakness: nothing told you
what was running or how to get back. The same bar works on a phone and a
monitor.
Instead of: Windows 8's hidden edge gestures, or Windows 10's full taskbar
with ordinary framed windows.

## 2026-11-11 — First iteration is the desktop home screen

Why: the owner wants the basic Metro-style desktop home designed first, so
the look can be judged before anything else is built.
Instead of: starting with the layout that adapts to every screen size.

## 2026-11-11 — Every task goes through a branch and a pull request

Why: the main branch must stay clean. The owner merges, or orders the
master chat to merge a specific pull request.
Instead of: letting small tasks go straight to the main branch.

## 2026-11-11 — Work is coordinated with agent-protocol

Why: one master chat plans and reviews, worker agents each do one task, and
everything they need is written in this repository.
Instead of: giving each agent its instructions by hand in chat.

## 2026-11-11 — The prototype is built in Qt Design Studio with QML

Why: the prototype is real interface code that can grow into the shell, and
it can be edited both visually and by code agents.
Instead of: a drawing tool, whose output would be thrown away.
