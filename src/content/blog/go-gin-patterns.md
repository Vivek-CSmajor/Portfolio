---
title: "Go + Gin Patterns I Keep Reaching For"
date: 2026-08-14
teaser: "Middleware, error handling, and project layout conventions that held up once things got messy at work."
---

## Middleware, Not Global Registration

Most Gin codebases start clean and then rot the moment two routes need the same auth check and a third needs a slightly different one. The pattern that's held up for me is keeping every cross-cutting concern — auth, logging, request-id propagation — as its own middleware, composed explicitly per route group rather than registered globally and special-cased later.

## Errors Belong to One Place

Error handling follows the same idea: handlers return a typed error, and a single middleware at the top of the chain maps that error to an HTTP status and response body. Handlers never write error responses themselves. That one rule has removed almost all the inconsistent error JSON I used to ship.

## Project Layout

A `handler` package per resource, a `service` package that holds the actual logic and is what gets unit tested, and `main.go` doing nothing but wiring. Gin stays at the edge; nothing below the handler layer imports `gin` at all.
