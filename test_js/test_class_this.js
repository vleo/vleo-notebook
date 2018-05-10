class C {
  constructor() {
    var self = this
    this.x = 123
    this.g = this.g.bind(this)
    this.hb = hv => s => hv(s)
  }

  f() {
    console.log("inside f, this ===> ",this)
    if (typeof this !== 'undefined') {
      this.y = 321
    }
  }

  g() {
    console.log("inside f, this ===> ",this)
    if (typeof this !== 'undefined') {
      this.y = 321
    }
  }

  h(self) {
    console.log("inside f, self ===> ",self)
    if (typeof self !== 'undefined') {
      self.y = 321
    }
  }

  prn() {
    console.log('this.x=',this.x, ' this.y=',this.y)
  }
}

function execMe(f){
  f()
}

function execMe2(s,f){
  f(s)
}
 
c = new(C)
c1 = new(C)
c2 = new(C)
c3 = new(C)
c4 = new(C)

console.log("=====f=====")
c.f()

c.prn()

console.log("======ff====")
execMe(c1.f)

c1.prn()

console.log("======g====")
c2.g()

c2.prn()

console.log("=====gg=====")
execMe(c3.g)
c3.prn()

console.log("=====hh====")

execMe2(c4,c4.h)
c4.prn()
