FROM java

ENV SONAR_HOME /opt/sonarqube
ENV SONAR_VERSION 7.7

# Http port
EXPOSE 9000

RUN groupadd -r sonarqube \
    && useradd -r -g sonarqube sonarqube

RUN cd /opt \
    && wget -q -O sonarqube.zip https://binaries.sonarsource.com/CommercialDistribution/sonarqube-developer/sonarqube-developer-${SONAR_VERSION}.zip \
    && unzip sonarqube.zip \
    && chown -R sonarqube:sonarqube sonarqube-${SONAR_VERSION} \
    && rm sonarqube.zip \
    && mv /opt/sonarqube-${SONAR_VERSION} ${SONAR_HOME} \
    && rm -rf ${SONAR_HOME}/bin

COPY sonar.properties ${SONAR_HOME}/conf/sonar.properties

WORKDIR ${SONAR_HOME}
USER sonarqube
ENTRYPOINT java -jar lib/sonar-application-${SONAR_VERSION}.jar \
                -Dsonar.log.console=true \
                -Dsonar.web.javaAdditionalOpts=-Djava.security.egd=file:/dev/./urandom
