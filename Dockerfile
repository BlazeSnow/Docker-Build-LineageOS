FROM ubuntu:24.04

COPY platform-tools-latest-linux.zip /

RUN apt update && apt full-upgrade -y && apt autoclean -y && apt autoremove -y

RUN apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool lz4 libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev

RUN cd / && unzip platform-tools-latest-linux.zip

RUN PATH="$HOME/platform-tools:$PATH"

RUN apt install python-is-python3

RUN mkdir -p ~/bin && mkdir -p ~/android/lineage

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && chmod a+x ~/bin/repo

RUN PATH="$HOME/bin:$PATH"

RUN git config --global user.email "you@example.com" && git config --global user.name "Your Name"

RUN git lfs install

RUN git config --global trailer.changeid.key "Change-Id"

RUN export USE_CCACHE=1

RUN export CCACHE_EXEC=/usr/bin/ccache

RUN ccache -M 50G

RUN ccache -o compression=true

RUN cd ~/android/lineage && repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs --no-clone-bundle

RUN repo sync

RUN cd ~/android/lineage && source build/envsetup.sh && breakfast xmsirius

RUN cd ~/android/lineage/device/xiaomi/xmsirius && ./extract-files.sh

CMD [ "croot && brunch xmsirius" ]