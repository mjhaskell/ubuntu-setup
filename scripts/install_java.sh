echo_blue "Installing Java"

## see https://linuxiac.com/how-to-install-java-on-ubuntu-24-04-lts/
# JDK vs JRE
# JDK: Java development kit (comes with JRE plus other dev tools)
# JRE: Java runtime envirenment (just for Java execution)
#
# Can use update-alternatives to manage multiple versions (ubuntu does this with apt install)
# need to add JAVA_HOME to path
#   - should be set to output of `sudo update-alternatives --list java`
#   - was "/usr/lib/jvm/java-21-openjdk-amd64/bin/java" for me

sudo apt install default-jre
java -version

if ! grep -q 'JAVA_HOME' ~/.zshenv; then
  echo 'export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"' >> ~/.zshenv
fi

echo_green "Java installed"

