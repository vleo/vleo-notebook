#!/bin/sh
groovyc GroovyTest.groovy
java -cp ".:$GROOVY_HOME/lib/groovy-2.5.2.jar" ru.lml2.ui.GroovyTest
