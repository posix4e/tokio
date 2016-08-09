FROM ubuntu:xenial
WORKDIR /work/
RUN apt-get update && apt-get install curl git perl bash file sudo build-essential vim libssl-dev protobuf-compiler -y
RUN curl -sf https://static.rust-lang.org/rustup.sh -o rustup.sh
RUN chmod +x rustup.sh
RUN ./rustup.sh
### Just for rust package cacheing!
COPY Cargo.toml /work/
RUN mkdir -p src; touch src/lib.rs
RUN cargo build --verbose 
RUN rm -rf src

# Actually move the source in place
COPY src/ /work/src/
RUN touch /work/src/*

RUN cargo build --verbose 

COPY test/ /work/test/
RUN cargo test --verbose 

ENTRYPOINT env PATH=$PATH:/work/bin/ /bin/bash
