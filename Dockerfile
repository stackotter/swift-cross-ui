FROM swift:latest

WORKDIR /build

COPY . .

RUN apt update && apt install -y libgtk-3-dev clang

CMD ["swift", "build", "-v"]