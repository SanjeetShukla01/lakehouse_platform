# Base Image
FROM eclipse-temurin:17-jre-jammy

# Arguments
ARG spark_uid=185
ARG DELTA_SPARK_VERSION="3.1.0"
ARG DELTALAKE_VERSION="0.16.4"
ARG JUPYTERLAB_VERSION="4.0.7"
ARG PANDAS_VERSION="2.2.2"
ARG ROAPI_VERSION="0.11.1"
ARG NBuser=NBuser
ARG GROUP=NBuser
ARG WORKDIR=/opt/spark/work-dir

# User and Group setup
RUN groupadd --system --gid=${spark_uid} spark && \
    useradd --system --uid=${spark_uid} --gid=spark spark

# System dependencies and Spark installation
RUN set -ex; \
    apt-get update; \
    apt-get install -y gnupg2 wget bash tini libc6 libpam-modules krb5-user libnss3 procps net-tools gosu libnss-wrapper python3 python3-pip vim curl tree; \
    mkdir -p /opt/spark; \
    mkdir /opt/spark/python; \
    mkdir -p /opt/spark/examples; \
    mkdir -p /opt/spark/work-dir; \
    chmod g+w /opt/spark/work-dir; \
    touch /opt/spark/RELEASE; \
    chown -R spark:spark /opt/spark; \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su; \
    rm -rf /var/lib/apt/lists/*

# Download and install Apache Spark
ENV SPARK_TGZ_URL=https://archive.apache.org/dist/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz \
    SPARK_TGZ_ASC_URL=https://archive.apache.org/dist/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz.asc \
    GPG_KEY=FD3E84942E5E6106235A1D25BD356A9F8740E4FF

RUN set -ex; \
    export SPARK_TMP="$(mktemp -d)"; \
    cd $SPARK_TMP; \
    wget -nv -O spark.tgz "$SPARK_TGZ_URL"; \
    wget -nv -O spark.tgz.asc "$SPARK_TGZ_ASC_URL"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-key "$GPG_KEY" || \
    gpg --batch --keyserver hkps://keyserver.ubuntu.com --recv-keys "$GPG_KEY"; \
    gpg --batch --verify spark.tgz.asc spark.tgz; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME" spark.tgz.asc; \
    \
    tar -xf spark.tgz --strip-components=1; \
    chown -R spark:spark .; \
    mv jars /opt/spark/; \
    mv bin /opt/spark/; \
    mv sbin /opt/spark/; \
    mv kubernetes/dockerfiles/spark/decom.sh /opt/; \
    mv examples /opt/spark/; \
    mv kubernetes/tests /opt/spark/; \
    mv data /opt/spark/; \
    mv python/pyspark /opt/spark/python/pyspark/; \
    mv python/lib /opt/spark/python/lib/; \
    mv R /opt/spark/; \
    chmod a+x /opt/decom.sh; \
    cd ..; \
    rm -rf "$SPARK_TMP"

# Install Python packages
RUN pip install --quiet --no-cache-dir delta-spark==${DELTA_SPARK_VERSION} \
    deltalake==${DELTALAKE_VERSION} jupyterlab==${JUPYTERLAB_VERSION} \
    pandas==${PANDAS_VERSION} roapi==${ROAPI_VERSION}

# Environment variables
ENV SPARK_HOME /opt/spark
ENV DELTA_PACKAGE_VERSION=delta-spark_2.12:${DELTA_SPARK_VERSION}

# Copy entrypoint script
COPY entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh

# User setup and work directory
RUN groupadd -r ${GROUP} && useradd -r -m -g ${GROUP} ${NBuser}
COPY --chown=${NBuser} startup.sh "${WORKDIR}"
COPY --chown=${NBuser} quickstart.ipynb "${WORKDIR}"
COPY --chown=${NBuser} rs/ "${WORKDIR}/rs"
RUN chown -R ${NBuser}:${GROUP} /home/${NBuser}/ && \
    chown -R ${NBuser}:${GROUP} ${WORKDIR}

# Rust installation
USER ${NBuser}
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Work directory
WORKDIR ${WORKDIR}

# Entry point
ENTRYPOINT ["/opt/entrypoint.sh"]

