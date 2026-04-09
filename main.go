package main

import (
	"log"
	"net"

	"github.com/golang/glog"
	"google.golang.org/grpc"
)

func main() {
	glog.Info("Starting server...")
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
