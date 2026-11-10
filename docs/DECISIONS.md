# Decisions

Newest first. A decision listed here is settled; reopen one only with the
owner.

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
