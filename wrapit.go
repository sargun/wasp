package main

import (
  "fmt"
  "net"
  "os"
  "os/exec"
)
func main() {
  ln, _ := net.ListenTCP("tcp", &net.TCPAddr{net.ParseIP("127.0.0.1"), 0, ""})
  fmt.Println("Listening on: ", ln.Addr()) 
  file, _ := ln.File()
  exe := exec.Command("escript", "echo_server.erl")
  exe.Stdout = os.Stdout
  exe.Stderr = os.Stderr
  exe.ExtraFiles = []*os.File{file}
  exe.Run()
}
