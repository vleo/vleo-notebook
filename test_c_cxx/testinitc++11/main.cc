# regression in 4.7
class base
{
    protected:
        base()
        {}
};

class derived : public base
{
    public:
        derived()
            : base{} // <-- Note the c++11 curly brace syntax
                     // using uniform initialization. Change the
                     // braces to () and it works.
        {}
};

int main()
{
    derived d1;

    return 0;
}
