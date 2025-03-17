FROM ubuntu:24.04

# 设置环境变量
ENV PATH="/platform-tools:/root/bin:$PATH"
ENV USE_CCACHE=1
ENV CCACHE_EXEC=/usr/bin/ccache

# 更新系统并安装依赖
COPY platform-tools-latest-linux.zip /
RUN apt update && apt full-upgrade -y && apt autoclean -y && apt autoremove -y && \
    apt install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick \
    lib32readline-dev lib32z1-dev libelf-dev liblz4-tool lz4 libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush \
    rsync schedtool squashfs-tools xsltproc zip zlib1g-dev python-is-python3 unzip && \
    unzip /platform-tools-latest-linux.zip -d / && \
    mkdir -p /root/bin && mkdir -p /root/android/lineage && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > /root/bin/repo && chmod a+x /root/bin/repo && \
    git config --global user.email "you@example.com" && git config --global user.name "Your Name" && \
    git lfs install && \
    git config --global trailer.changeid.key "Change-Id" && \
    ccache -M 50G && ccache -o compression=true

# 设置工作目录
WORKDIR /root/android/lineage

# 初始化 repo
RUN repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs --no-clone-bundle

# 提示用户同步代码
CMD ["/bin/bash", "-c", "echo 'Run repo sync manually after starting the container!' && /bin/bash"]
