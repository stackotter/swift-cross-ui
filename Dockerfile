FROM swift:latest

WORKDIR /build

RUN echo "#!/bin/bash" > /build/setup.sh

RUN echo "git init" >> /build/setup.sh

RUN echo "git remote add origin https://github.com/stackotter/swift-cross-ui.git" >> /build/setup.sh

RUN echo "git fetch" >> /build/setup.sh

RUN echo "git checkout -t origin/main" >> /build/setup.sh

RUN echo "swift build -v" >> /build/setup.sh

RUN chmod +x /build/setup.sh

RUN apt update && apt install -y libgtk-3-dev clang

CMD ["sh", "setup.sh"]