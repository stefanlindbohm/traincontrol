# Trackside Simulate

Trackside Simulate is a runtime for overlaying a model train layout with a
simulation that represents prototypical or otherwise chosen objects and their
behaviors. It is up to the user to configure the simulation to represent
desired functionality.

## Philosophy

The design philosophy of Trackside Simulate is that of a game engine, meaning
the simulation consists of simulated objects with attached behavior that are
updated in ticks.

Built-in objects exist to represent physical elements of the model train
layout, such as locomotives and accessories. These objects are, in addition to
being simulated objects with behaviors themselves, built to interact with the
physical elements they represent.
