abstract class MyBaseClass extends Script {
    String name
    public void greet() { println "Hello, $name!" }
}

import groovy.transform.BaseScript

@BaseScript MyBaseClass baseScript
setName 'Judith'
greet()

