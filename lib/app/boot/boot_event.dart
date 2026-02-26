sealed class BootEvent {
  const BootEvent();
}

class BootStarted extends BootEvent {
  const BootStarted();
}

class BootRetried extends BootEvent {
  const BootRetried();
}
