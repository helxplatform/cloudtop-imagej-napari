# This docker build file creates a single docker image that contains both the CloudTop virtual Desktop
FROM heliumdatastage/cloudtop:latest

### Make the /usr/local/bin/renci directory
RUN mkdir -p /usr/local/renci/bin

### lets install ImageJ
RUN set -x \
  && cd /usr/local/renci/bin \
  && curl -SLo ij152-linux64-java8.zip http://wsr.imagej.net/distros/linux/ij152-linux64-java8.zip \
  && unzip ij152-linux64-java8.zip \
  && rm -f ij152-linux64-java8.zip \
  && alias imagej="/usr/bin/java -Xmx512m -cp /usr/local/renci/bin/ImageJ/ij.jar ij.ImageJ"

### Add Napari
RUN set -x \
   && apt update \
   && apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget libbz2-dev libxcb1 libqt5gui5\
   && pwd \
   && curl -O https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz \
   && tar -xf Python-3.7.3.tar.xz \
   && pwd \
   && cd Python-3.7.3 \
   && pwd \
   && ls -l ./configure \
   && ./configure \
   && make -j 4 \
   && make install \
   && python3 --version \
   && apt install -y python3-pip \
   && pip3 --version

RUN set -x \
   && apt install -y git \
   && cd /usr/local/renci \
   && git clone https://github.com/napari/napari.git \
   && cd napari \
   && pwd \
   && pip3 install -e .

# The files in ./src/common/xfce/Desktop/ are the file that add the Desktop Icons. We store them in
# /headless/Desktop because that is where 50-desktop-init.sh expectts to find them. It's arbitrary
# as long as the script knows where to find them.
COPY ./src/common/xfce/Desktop/* /headless/Desktop/

# Copy in the init file.  This file copies the Desktop files from above into the users Desktop directory.
# Note that while these files are added to the static image, the S6 system runs everything in the cont-init.d
# directory at the time the container starts.  It's analagous to how linux/unix systems work
COPY root/etc/cont-init.d/50-desktop-init.sh /etc/cont-init.d/50-desktop-init.sh

# The required CloudTop entrypoint.  init starts the S6 system which reads the run direcories and
# starts the monitored services
ENTRYPOINT [ "/init" ]
