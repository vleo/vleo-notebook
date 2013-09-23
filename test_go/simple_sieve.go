package main
import (
        "fmt"
        "os"
        "math"
        "strconv"
        )

func main(){
        // figures out which number is the bound
        n,err := strconv.ParseFloat(os.Args[1],64)
        if err != nil {
                fmt.Printf("Error converting parameter to int\n")
                return
        }
        sqrt := int(math.Sqrt(n))

        // creates the starting array
        a:=make([]int,int(n)/2)
        a[0]=2;

        for i:=1;i<len(a);i++ {
                a[i]=2*i+1
        }

        //sieves
        for i:=1;i<sqrt; i++{
                m := a[i]
                if m == 0 {
                        continue
                }
                for j:=i*(m+1);j<len(a);j+=m {
                        a[j]=0
                }
        }
        //counts the number of primes
        count := 0
        for i:=0;i<len(a);i++{
                if a[i]!=0 {
                        count++
                }
        }
        fmt.Printf("number of primes %d\n",count)
}
