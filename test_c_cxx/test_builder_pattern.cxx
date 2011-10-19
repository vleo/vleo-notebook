/*
 * builder.cpp
  * Note : code idea taken from wiki
   */
#include <string>
#include <iostream>

using namespace std;

// "Product"
class CPizza {
public:
    void m_setDough(const string& dough) {
        m_strDough = dough;
    }
    void m_setSauce(const string& sauce) {
        m_strSauce = sauce;
    }
    void m_setTopping(const string& topping) {
        m_strTopping = topping;
    }
    void m_open() const {
        cout << "Pizza with " << m_strDough << " dough, " << m_strSauce << " sauce and " << m_strTopping << " topping. Mmm." << endl;
    }
private:
    string m_strDough;
    string m_strSauce;
    string m_strTopping;
};

// "Abstract Builder"
class CPizzaBuilder {
public:
    CPizzaBuilder() { cout << "construct CPizzeBuilder" << endl ; }

    CPizza* getPizza() {
        return m_pizza;
    }
    void createNewPizzaProduct() {
        m_pizza = new CPizza;
    }
    virtual void m_buildDough() = 0;
    virtual void m_buildSauce() = 0;
    virtual void m_buildTopping() = 0;
protected:
    CPizza* m_pizza;
};

class CHawaiianPizzaBuilder : public CPizzaBuilder {
public:
    virtual void m_buildDough() {
        m_pizza->m_setDough("cross");
    }
    virtual void m_buildSauce() {
        m_pizza->m_setSauce("mild");
    }
    virtual void m_buildTopping() {
        m_pizza->m_setTopping("ham+pineapple");
    }
};

class SpicyPizzaBuilder : public CPizzaBuilder {
public:
    virtual void m_buildDough() {
        m_pizza->m_setDough("pan baked");
    }
    virtual void m_buildSauce() {
        m_pizza->m_setSauce("hot");
    }
    virtual void m_buildTopping() {
        m_pizza->m_setTopping("pepperoni+salami");
    }
};

class CCook {
public:
    void setPizzaBuilder(CPizzaBuilder* pb) {
        m_pizzaBuilder = pb;
    }
    CPizza* getPizza() {
        return m_pizzaBuilder->getPizza();
    }
    void constructPizza() {
        m_pizzaBuilder->createNewPizzaProduct();
        m_pizzaBuilder->m_buildDough();
        m_pizzaBuilder->m_buildSauce();
        m_pizzaBuilder->m_buildTopping();
    }
private:
    CPizzaBuilder* m_pizzaBuilder;
};

int main() {
    CCook cook;
    CPizzaBuilder* hawaiianPizzaBuilder = new CHawaiianPizzaBuilder;
    CPizzaBuilder* spicyPizzaBuilder   = new SpicyPizzaBuilder;

    cook.setPizzaBuilder(hawaiianPizzaBuilder);
    cook.constructPizza();

    CPizza* hawaiian = cook.getPizza();
    hawaiian->m_open();

    cook.setPizzaBuilder(spicyPizzaBuilder);
    cook.constructPizza();

    CPizza* spicy = cook.getPizza();
    spicy->m_open();

    delete hawaiianPizzaBuilder;
    delete spicyPizzaBuilder;
    delete hawaiian;
    delete spicy;

    return 0;
}
