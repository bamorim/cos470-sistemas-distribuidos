extern crate nix;
use nix::sys::signal;
use std::io;

fn read_int(msg: &str) -> i32 {
  loop {
    let mut s = String::new();
    println!("{}",msg);
    io::stdin().read_line(&mut s).unwrap();

    match s.trim_right().parse::<i32>() {
      Ok(i) => return i,
      Err(_) => println!("Invalid Number"),
    }
  }
}

fn main() {
  let pid = read_int("Enter the PID: ");
  loop {
    let sig = read_int("Enter the signal to send: ");
    signal::kill(pid,sig);
  }
}
