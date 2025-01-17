// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend-emit-module -emit-module-path %t/FakeDistributedActorSystems.swiftmodule -module-name FakeDistributedActorSystems -disable-availability-checking %S/Inputs/FakeDistributedActorSystems.swift
// RUN: %target-swift-frontend -typecheck -verify -disable-availability-checking -I %t 2>&1 %s
// REQUIRES: concurrency
// REQUIRES: distributed

import Distributed
import FakeDistributedActorSystems

@available(SwiftStdlib 5.5, *)
typealias DefaultDistributedActorSystem = FakeActorSystem

// ==== ----------------------------------------------------------------------------------------------------------------

distributed actor OK0 { }

distributed actor OK1 {
  var x: Int = 1
  // ok, since all fields are initialized, the constructor can be synthesized
}

distributed actor OK2 {
  var x: Int

  init(x: Int, system: FakeActorSystem) { // ok
    self.x = x
  }
}

// NOTE: keep in mind this is only through typechecking, so no explicit
// actorSystem is being assigned here.
distributed actor OK3 {
  init() {}
}

distributed actor OK4 {
  init(x: String) {
  }
}

distributed actor OK5 {
  var x: Int = 1

  init(system: FakeActorSystem, too many: FakeActorSystem) {
  }
}

distributed actor OK6 {
  var x: Int

  init(y: Int, system: FakeActorSystem) {
    self.x = y
  }
}

distributed actor OKMulti {

  convenience init(y: Int, system: FakeActorSystem) { // ok
    self.init(actorSystem: system)
  }

}

distributed actor OKMultiDefaultValues {

  convenience init(y: Int, system: FakeActorSystem, x: Int = 1234) { // ok
    self.init(actorSystem: system)
  }

}

