FROM swift:latest

WORKDIR /host

RUN apt update && apt install -y libgtk-3-dev clang
