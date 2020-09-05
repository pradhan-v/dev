export APPS_HOME=~/applications
export CUSTOM_PATH=~/X/shellscripts

#export JAVA_HOME=$APPS_HOME/jdk-13.0.1
export JAVA_HOME=$APPS_HOME/jdk1.8.0_231
export GRADLE_HOME=$APPS_HOME/gradle-6.0.1

export ELASTICSEARCH_HOME=$APPS_HOME/elasticsearch-7.5.1
export KIBANA_HOME=$APPS_HOME/kibana-7.5.1-linux-x86_64

# export AWS_CLI=$APPS_HOME/aws-cli

#export ANDROID_HOME=$APPS_HOME/android-sdk/
#export ANDROID_PATHS=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools

export PATH=$PATH:$CUSTOM_PATH:$JAVA_HOME/bin:$GRADLE_HOME/bin:$ELASTICSEARCH_HOME/bin:$KIBANA_HOME/bin

