package main

import (
	"log"
	"net"
	"net/http"

	"github.com/golang/glog"
	"google.golang.org/grpc"
)

func main() {
	glog.Error("Prepare to repel boarders")
	glog.Flush()

	s := grpc.NewServer()

	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	http.HandleFunc("/grpc", func(w http.ResponseWriter, r *http.Request) {
		s.ServeHTTP(w, r)
	})

	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
