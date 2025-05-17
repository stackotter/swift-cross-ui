# Implementation details

## Overview

You don't need to interact with any of this directly unless you're doing
something very advanced. Many of these are only exposed as `public` so that
advanced users don't have to reimplement helpers that we've already
implemented, and others are exposed to enable unique use-cases such as embedding
SwiftCrossUI view graphs inside existing non-SwiftCrossUI apps.

<!-- TODO: Write technical deep dives into some of these implementation details -->

## Topics

- ``LayoutSystem``

- ``EitherView``
- ``EmptyView``
- ``OptionalView``
- ``HotReloadableView``

- ``ViewSize``
- ``ViewUpdateResult``

- ``AnyWidget``

- ``PublishedMarkerProtocol``
- ``DynamicProperty``

- <doc:View-graph>
- <doc:Scene-graph>
