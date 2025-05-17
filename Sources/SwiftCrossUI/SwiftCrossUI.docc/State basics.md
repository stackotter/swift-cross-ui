# State basics

## Overview

These concepts form the foundation of SwiftCrossUI's reactivity.

Use the ``State`` property wrapper to store state within your apps, scenes,
and views. State generally trickles down through your view hierarchies. Variables
without the ``State`` annotation aren't reactive.

For situations where you need data to trickle back up again, use ``Binding``
(think mutable references to state).

## Topics

- ``State``
- ``Binding``
- ``ObservableObject``
- ``Published``
- ``Publisher``
- ``Cancellable``
