//! SDKWork Edu standalone HTTP gateway.
//!
//! Single application ingress for the app-api and backend-api surfaces.
//! Assembles the hosted router through `sdkwork-web-bootstrap` and serves it on
//! `SDKWORK_EDU_APPLICATION_PUBLIC_INGRESS_BIND`.
//!
//! Wiring lands in plan phase P3; this crate intentionally declares no runtime
//! dependencies until the assembly exists.

fn main() {
    // P3: assemble the API router, host it on the web framework, then serve.
}