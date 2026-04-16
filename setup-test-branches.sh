#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

echo "=== Setting up test branches for arc-test-component-b ==="
echo "Working in: $REPO_DIR"
echo ""

git fetch origin

# ============================================================
# release-4.13: Go 1.19, single module, grpc v1.64.0
# Expected: fork/patch path with v1.67.x-sec.1 (Go 1.21 fork)
#   Wait - ci-operator says 1.19, so max_go=1.19, fork for 1.19 = v1.64.x-sec.1
# ============================================================
echo "=== Setting up release-4.13 (Go 1.19, single module) ==="
git checkout -B release-4.13 origin/release-4.13

cat > .ci-operator.yaml << 'EOF'
build_root:
  image_stream_tag:
    tag: golang-1.19
EOF

cat > go.mod << 'EOF'
module github.com/openshift-sustaining/arc-test-component-b

go 1.19

require (
	github.com/golang/glog v1.2.0
	google.golang.org/grpc v1.64.0
)
EOF

rm -f go.sum

cat > README.md << 'EOF'
# arc-test-component-b

## Known Vulnerabilities

- CVE-2026-33186 In Modules: `.`

## Branch Info

| Property | Value |
|---|---|
| Go Version | 1.19 |
| grpc | v1.64.0 (vulnerable) |
| Module Structure | Single module |
| Expected ARC Behavior | Fork/patch (`v1.64.x-sec.1` for Go 1.19) |
EOF

git add -A
git commit -m "setup: configure release-4.13 for Go 1.19 patch testing"
echo "release-4.13 ready"
echo ""

# ============================================================
# release-4.12: Go 1.19, single module, add grpc
# Expected: fork/patch path with v1.64.x-sec.1
# ============================================================
echo "=== Setting up release-4.12 (Go 1.19, single module, add grpc) ==="
git checkout -B release-4.12 origin/release-4.12

cat > .ci-operator.yaml << 'EOF'
build_root:
  image_stream_tag:
    tag: golang-1.19
EOF

cat > go.mod << 'EOF'
module github.com/openshift-sustaining/arc-test-component-b

go 1.19

require (
	github.com/golang/glog v1.2.0
	google.golang.org/grpc v1.64.0
)
EOF

rm -f go.sum

cat > main.go << 'EOF'
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
EOF

cat > README.md << 'EOF'
# arc-test-component-b

## Known Vulnerabilities

- CVE-2026-33186 In Modules: `.`

## Branch Info

| Property | Value |
|---|---|
| Go Version | 1.19 |
| grpc | v1.64.0 (vulnerable) |
| Module Structure | Single module |
| Expected ARC Behavior | Fork/patch (`v1.64.x-sec.1` for Go 1.19) |
EOF

git add -A
git commit -m "setup: configure release-4.12 for Go 1.19 patch testing"
echo "release-4.12 ready"
echo ""

# ============================================================
# release-4.15: Go 1.20, single module
# Expected: fork/patch path with v1.64.x-sec.1 (Go 1.20)
# ============================================================
echo "=== Setting up release-4.15 (Go 1.20, single module) ==="
git checkout -B release-4.15 origin/release-4.15

cat > .ci-operator.yaml << 'EOF'
build_root:
  image_stream_tag:
    tag: golang-1.20
EOF

cat > go.mod << 'EOF'
module github.com/openshift-sustaining/arc-test-component-b

go 1.20

require (
	github.com/golang/glog v1.2.0
	google.golang.org/grpc v1.64.0
)
EOF

rm -f go.sum

cat > README.md << 'EOF'
# arc-test-component-b

## Known Vulnerabilities

- CVE-2026-33186 In Modules: `.`

## Branch Info

| Property | Value |
|---|---|
| Go Version | 1.20 |
| grpc | v1.64.0 (vulnerable) |
| Module Structure | Single module |
| Expected ARC Behavior | Fork/patch (`v1.64.x-sec.1` for Go 1.20) |
EOF

git add -A
git commit -m "setup: configure release-4.15 for Go 1.20 patch testing"
echo "release-4.15 ready"
echo ""

# ============================================================
# release-4.19: Go 1.23, single module (NEW - from release-4.21)
# Expected: fork/patch path with v1.75.x-sec.1 (Go 1.23)
# ============================================================
echo "=== Setting up release-4.19 (Go 1.23, single module - NEW) ==="
git checkout -B release-4.19 origin/release-4.21

cat > .ci-operator.yaml << 'EOF'
build_root:
  image_stream_tag:
    tag: golang-1.23
EOF

cat > go.mod << 'EOF'
module github.com/openshift-sustaining/arc-test-component-b

go 1.23

require (
	github.com/golang/glog v1.2.0
	google.golang.org/grpc v1.64.0
)
EOF

rm -f go.sum

cat > README.md << 'EOF'
# arc-test-component-b

## Known Vulnerabilities

- CVE-2026-33186 In Modules: `.`

## Branch Info

| Property | Value |
|---|---|
| Go Version | 1.23 |
| grpc | v1.64.0 (vulnerable) |
| Module Structure | Single module |
| Expected ARC Behavior | Fork/patch (`v1.75.x-sec.1` for Go 1.23) |
EOF

git add -A
git commit -m "setup: configure release-4.19 for Go 1.23 patch testing"
echo "release-4.19 ready"
echo ""

# ============================================================
# release-4.18: Go 1.22, multi-module (NEW - from release-4.20)
# Expected: fork/patch in sub-a only, root and sub-b skipped
# ============================================================
echo "=== Setting up release-4.18 (Go 1.22, multi-module - NEW) ==="
git checkout -B release-4.18 origin/release-4.20

cat > .ci-operator.yaml << 'EOF'
build_root:
  image_stream_tag:
    tag: golang-1.22
EOF

cat > go.mod << 'EOF'
module github.com/openshift-sustaining/arc-test-component-b

go 1.22

require github.com/golang/glog v1.2.0

require github.com/google/go-cmp v0.7.0 // indirect
EOF

cat > sub-a/go.mod << 'EOF'
module github.com/openshift-sustaining/arc-test-component-b/sub-a

go 1.22

require (
	github.com/golang/glog v1.2.0
	google.golang.org/grpc v1.64.0
)
EOF

cat > sub-b/go.mod << 'EOF'
module github.com/openshift-sustaining/arc-test-component-b/sub-b

go 1.22

require github.com/golang/glog v1.2.0

require github.com/google/go-cmp v0.7.0 // indirect
EOF

rm -f go.sum sub-a/go.sum sub-b/go.sum

cat > README.md << 'EOF'
# arc-test-component-b

## Known Vulnerabilities

- CVE-2026-33186 In Modules: `sub-a`
- CVE-2024-45339 In Modules: `.`, `sub-a`, `sub-b`

## Branch Info

| Property | Value |
|---|---|
| Go Version | 1.22 |
| grpc | v1.64.0 in `sub-a` (vulnerable) |
| Module Structure | Multi-module (`.`, `sub-a`, `sub-b`) |
| Expected ARC Behavior | Fork/patch (`v1.71.x-sec.1` for Go 1.22) only in `sub-a` |
EOF

git add -A
git commit -m "setup: configure release-4.18 for Go 1.22 multi-module patch testing"
echo "release-4.18 ready"
echo ""

# ============================================================
# release-4.21: Go 1.24, single module - NO CHANGES NEEDED
# Expected: direct bump to v1.79.3
# ============================================================
echo "=== release-4.21 (Go 1.24, single module) - already ready ==="
echo ""

# ============================================================
# release-4.20: Multi-module - NO CHANGES NEEDED
# Already tested
# ============================================================
echo "=== release-4.20 (multi-module) - already ready ==="
echo ""

# ============================================================
# Push all branches
# ============================================================
echo "=== Pushing all branches ==="
echo "Run the following commands to push:"
echo ""
echo "  git push origin release-4.12 --force"
echo "  git push origin release-4.13 --force"
echo "  git push origin release-4.15 --force"
echo "  git push origin release-4.18 --force"
echo "  git push origin release-4.19 --force"
echo ""
echo "Or push all at once:"
echo "  git push origin release-4.12 release-4.13 release-4.15 release-4.18 release-4.19 --force"
echo ""
echo "=== Setup complete! ==="
echo ""
echo "Branch summary:"
echo "  release-4.12  Go 1.19  single   patch v1.64.x-sec.1"
echo "  release-4.13  Go 1.19  single   patch v1.64.x-sec.1"
echo "  release-4.15  Go 1.20  single   patch v1.64.x-sec.1"
echo "  release-4.18  Go 1.22  multi    patch v1.71.x-sec.1 (sub-a only)"
echo "  release-4.19  Go 1.23  single   patch v1.75.x-sec.1"
echo "  release-4.20  Go 1.24  multi    direct bump (already done)"
echo "  release-4.21  Go 1.24  single   direct bump"
