extern crate nix;
use std::convert::AsRef;
use nix::sys::signal;
use std::thread;
use std::time::Duration;
use std::fmt::format;
use std::env;

extern fn handle_signals(s:i32) {
  println!("Signal received: {}", s);
}

fn main() {
  let sig_action = signal::SigAction::new(signal::SigHandler::Handler(handle_signals),
                                          signal::SaFlag::empty(),
                                          signal::SigSet::empty()
                                          );
  unsafe {
    // Intercept all signals except SIGKILL and SIGSTOP
    for s in 1..9 {
      handle(s,&sig_action);
    }
    for s in 10..19 {
      handle(s,&sig_action);
    }
    for s in 20..31 {
      handle(s,&sig_action);
    }
  }

  // Block waiting
  match env::args().nth(1) {
    Some(x) => match x.as_ref() {
      "block" => thread::park(),
      "busy" => loop {},
      _ => println!("Invalid block type"),
    },
    _ => println!("Need the block type argument"),
  }

}

unsafe fn handle(s:i32, a: &signal::SigAction) {
  let msg = format!("Could add signal handler {}", s);
  signal::sigaction(s, a)
    .expect(&msg);
}
