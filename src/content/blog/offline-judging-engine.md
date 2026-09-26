---
title: "Building an Offline Judging Engine"
date: 2026-07-02
teaser: "Architecture walkthrough of the sandboxed execution and ICPC-style scoring behind the coding assessment platform."
---

## The Constraint That Shaped Everything

The constraint that shaped everything: the platform has to keep running a full exam even if the internet does not exist for the next two hours. That rules out any architecture where grading calls out to a cloud sandbox.

## Running Entirely on the Local Machine

So the judging engine runs entirely on the local exam machine — a lightweight local control plane that syncs problem sets and roster data from the cloud before the exam starts, then judges every submission locally against ICPC-style test cases, and syncs results back once connectivity returns.

## Sandboxing Is the Hard Part

Sandboxing submitted code on a machine you don't fully control is the hard part: resource limits (CPU time, memory, process count), no network namespace, and a filesystem view that can't see anything outside the submission's own scratch directory. Getting this right mattered more than making the scoring algorithm clever.
