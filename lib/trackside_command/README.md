# Trackside Command

Trackside Command is a unified interface to command stations for model train
layouts.

## Philosophy

Trackside Command provides a logical representation of all devices and actions
that are supported by command stations in use. Hardware-specifics are
abstracted away, for example accessory decoders are not the logical unit
relevant to control so instead the accessory output is chosen as the
appropriate abstraction to expose.

Terminology follows the DCC standard by default, unless command stations have
functionality that deviates and requires specific terminology.
