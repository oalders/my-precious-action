FROM perldocker/perl-tester:5.32

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /tmp/
RUN curl -L https://github.com/houseabsolute/precious/releases/download/v0.0.5/precious-v0.0.5-x86_64-unknown-linux-gnu.tar.gz -o precious.tar.gz && \
tar zxfv precious.tar.gz && \
mv precious /usr/local/bin

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
apt-get install -y --no-install-recommends nodejs && \
npm install -g bats

COPY package.json /tmp/
COPY yarn.lock /tmp/

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

ENV PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:${PATH}"

RUN "$HOME/.yarn/bin/yarn" install

RUN npm install -g prettier

ENTRYPOINT ["/usr/local/bin/precious"]

CMD ["--help"]
