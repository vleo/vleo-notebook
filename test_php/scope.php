<?php
class Foo {
  private $className = 'Bar';
 
  public function make() {
#    return new $this->className();
    return new $this->className;
  }
 
  public function callClassName() {
   $this->className();
  }

  public function className() {
    echo "foo\n";
  }

};

class Bar {
  public function hello() {
    echo "bar\n";
  }
};

$foo = new Foo();
$bar = $foo->make();

echo "expecting 'bar': ";
$bar->hello();

echo "expecting 'foo': ";
$foo->callClassName();
?>
