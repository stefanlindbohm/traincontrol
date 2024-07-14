# Traincontrol

Traincontrol is a fully web-based control software for model railroads meant to
run on a UNIX machine physically connected to model railway control boxes.

### Project status

This is a hobby project in all its glory with hardcoded values for the author's
setup. Act accordingly.

### Features

- Connects to Intellibox-compatible control boxes using the P50X protocol.
  - Code is meant to be adaptable for other control protocols, but the author
    doesn't currently have access to any other hardware so expansion is not
    likely for the time being.
- Locomotives controllable through the web interface.

Wishlist of features that may or may not happen:

- Realistic simulation of train acceleration/breaking based on the physics of
  real-world trains.
- Control interface using throttle + brake levers as an option to the current
  "cruise control" style handle.
- Train dispatcher interface for controlling turnouts and signals, using an
  interface style based on lines + stations that mimic real world dispatch
  displays.
- Sensor support for presence feedback from the rails.
- Train automation.

### Technical requirements

This project is built to be easily deployed to any UNIX machine with minimal
setup. A Raspberry Pi or similar is the intended optimal host.

- The project should run with Ruby and Bundler as the only dependencies (DB is
  SQLite, coordination is done in-process, etc).
- The exposed web service is intended to be accessible only through a LAN, and
  performance characteristics need to be good enough only for the amount of
  people that reasonably have physical access to one model railroad layout.
