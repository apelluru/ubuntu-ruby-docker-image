# This image just contains Ruby installation using rvm (ruby version manager)
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive TZ=Europe/Berlin LANG=C.UTF-8

#Install required packages (based on cu)
RUN apt-get update && \
    apt-get -y install apt-utils tzdata wget curl jq libxml2 gnupg2 && \
    apt-get clean

# install ruby version manager - ruby dependencies
RUN apt-get update && \
    apt-get -y install g++ gcc autoconf automake bison libc6-dev \
            libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool \
            libyaml-dev make pkg-config sqlite3 zlib1g-dev libgmp-dev \
            libreadline-dev libssl-dev && \
    apt-get clean
    
# install ruby
RUN echo progress-bar >> ~/.curlrc
RUN apt-get -y install ca-certificates
RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - \
    && curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -

RUN curl -sSL https://get.rvm.io | bash -s stable --ruby --with-gems="bundler yaml json"

RUN /bin/bash -l -c "echo 'source /etc/profile.d/rvm.sh' >> ~/.bashrc"
RUN /bin/bash -l -c "echo 'source /usr/local/rvm/scripts/rvm' >> ~/.bashrc"
RUN /bin/bash -l -c "rvm rubygems current"
RUN /bin/bash -l -c "rvm info"
RUN echo "gem: --no-document" > ~/.gemrc

# env variables for bash
ENV PATH="/usr/local/rvm/gems/ruby-3.0.0/bin:/usr/local/rvm/gems/ruby-3.0.0@global/bin:/usr/local/rvm/rubies/ruby-3.0.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/rvm/bin:/root/bin:${PATH}"
ENV GEM_HOME="/usr/local/rvm/gems/ruby-3.0.0"
ENV GEM_PATH="/usr/local/rvm/gems/ruby-3.0.0:/usr/local/rvm/gems/ruby-3.0.0@global"
ENV MY_RUBY_HOME="/usr/local/rvm/rubies/ruby-3.0.0"
ENV IRBRC="/usr/local/rvm/rubies/ruby-3.0.0/.irbrc"

# Optional but it will udpate the latest gems
RUN gem update --system

# installation verification 
RUN ruby -v

HEALTHCHECK CMD ruby -v

ENTRYPOINT ["ruby"]
