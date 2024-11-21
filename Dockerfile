# ##########
# # COMMON #
# ##########

# The common image gives us all of the system packages upon which the stack
# depends. We want to rebuild this as infrequently as possible, so as many
# things as possible have been nailed down by checksums.
FROM ruby:2.7.8 AS common

# Create a non-root user; it's best practice not to run a container with the root user
RUN useradd --create-home --shell /bin/bash codeandsupply

# Require no interaction
ENV DEBIAN_FRONTEND noninteractive

# Keep the downloads together
WORKDIR /tmp

# A dependency of apt-fast-mirror, aria2c is a file transfer client that can fetch multiple files in parallel.
ADD --checksum=sha256:8e7021c6d5e8f8240c9cc19482e0c8589540836747744724d86bf8af5a21f0e8 \
    --chmod=644 \
    --link \
    https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0.tar.gz aria2-1.37.0.tar.gz
# Compile aria2c from source and install to /usr/local
RUN tar xvzf aria2-1.37.0.tar.gz && \
    cd aria2-1.37.0 && \
    ./configure --prefix=/usr/local && \
    make && make install

# From the apt-fast repo at https://github.com/ilikenwf/apt-fast:
#
# apt-fast is a shell script wrapper for apt-get and aptitude that can drastically improve apt
# download times by downloading packages in parallel, with multiple connections per package.
#
# Commit cc0289c is current as of Sept 2024
ADD --checksum=sha256:c15aceb5e27d188f9090a173f62cc8a918238af62340d310f07c9b259dded581 \
    --chmod=755 \
    --link \
    https://raw.githubusercontent.com/ilikenwf/apt-fast/cc0289c/apt-fast /usr/local/sbin/apt-fast
ADD --checksum=sha256:e545093738b6023cc4c811a0d253a3ddc99b45025d7cf6426133fe3d3c151fdc \
    --chmod=644 \
    --link \
    https://raw.githubusercontent.com/ilikenwf/apt-fast/cc0289c/apt-fast.conf /etc/apt-fast.conf

# From the apt-fast-mirrors repo at https://github.com/stfl/apt-fast-mirrors, with local
# modifications; this script will benchmark and pick the fastest mirror for this run
COPY --chmod=755 --link docker/af-mirrors.py af-mirrors.py

# NodeJS is used for any frontend stuff
ADD --checksum=sha256:dd3bc508520fcdfdc8c4360902eac90cba411a7e59189a80fb61fcbea8f4199c \
    --chmod=755 \
    --link \
    https://deb.nodesource.com/setup_20.x setup_20.x

# Lets us control gem tool behaviors
COPY --chmod=644 --link docker/gemrc /etc/gemrc

# This runs apt-update while installing node, so no need to re-run it afterwards
RUN ./setup_20.x

# Install everything the images need
RUN apt-fast install --yes \
        aria2 \
        build-essential \
        jq \
        libpq-dev \
        lsb-release \
        netselect-apt \
        nodejs

# Yarn is used for frontend stuff just like Node
RUN npm install --global --force yarn@1.22.22

WORKDIR /codeandsupply.co

# #####################
# # LOCAL DEVELOPMENT #
# #####################

# The local development image does the bare minimum to get a container running with all
# necessary dependencies to run the service. It's meant to be run using docker-compose.
# This will attach volumes to common cache paths so you don't need to rerun the steps
# in between rebuilding the image.
#
# This image also doesn't use the custom user because you're running it locally anyway.
FROM common AS development

# For the main server
EXPOSE 3000:3000

# For the debugging server
EXPOSE 1049:1049

# Idles while you wait to connect to it
CMD ["tail", "-f", "/dev/null"]
