---
title: "On Refactoring Systems You Inherit"
date: 2026-06-10T09:00:00+01:00
description: "Most of the code you will ever touch was written by someone else, for reasons you will never fully know. Patience is a technical skill."
tags: ["legacy", "craft"]
draft: false
canonicalURL: ""
images: []
slug: "on-refactoring-systems-you-inherit"
---

## The inheritance

There is a particular feeling that arrives in the first week on a mature codebase. You open a file expecting a function and find a small civilization: conventions you do not recognise, names that meant something to someone, a comment from 2014 that simply reads `// do not remove`. The instinct is to recoil, to declare it a mess, to reach for the rewrite. Resist it. The mess is information.

Every line you find difficult was, at some point, a reasonable answer to a question you have not yet been asked. The work of modernisation begins not with judgement but with archaeology.

> Legacy code is not a failure of the people who came before. It is the sediment of every decision the business has survived.

## Reading before writing

We are trained to write and left to figure out reading on our own — yet on an inherited system you will read for weeks before you change a line that matters. Read the tests first; they are the only documentation that was forced to be true. Read the commit history of the file you fear most. Read the issues nobody closed.

Only once the shape of the thing is in your hands should you touch it. And when you do, change one thing at a time, and let the system tell you whether you understood it.

<div class="callout">
<span class="callout__label">A rule I keep</span>
<p>Never refactor and change behaviour in the same commit. One of them will be wrong, and you will want to know which.</p>
</div>

## Seams and strangler figs

The strangler fig grows around a host tree, drawing its own structure upward until the original trunk rots away inside it, no longer needed. It is the kindest metaphor we have for migration. You rarely get to rewrite. You get to grow a new system around the old one until, one quiet afternoon, the old one is no longer load-bearing — and deleting it is a formality.

Find the seams: the places where you can intercept a call, route a fraction of traffic, compare the new answer against the old. A seam is permission to change your mind later.

## Where the model helps

A language model is a fast, confident junior who has read everything and remembers nothing between sentences. On legacy work this is, surprisingly, a gift. It will summarise a thousand-line file faster than you can scroll it. It will draft the characterisation test you have been avoiding. It will propose five names for the concept you could not name.

What it will not do is hold the responsibility. The judgement of whether a change is safe remains yours, because only you will be there at 2am when it is not. Use the model to go faster through the parts you already understand — never to skip the understanding.

## Leaving it better than found

You will not finish. Inherited systems are not projects with end dates; they are gardens. The measure of your work is not that the code is now perfect but that the next person to open this file feels, for a moment, that someone was here who cared. Leave the seams visible. Leave the tests honest. Leave a comment that tells the truth.

That is the whole craft, really: to hand the thing on in slightly better condition than it reached you, and to resist the vanity of the rewrite for one more year.
