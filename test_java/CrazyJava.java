public class CrazyJava
{
  static int a = 111;
  static int b = 111;
  static int c = 222;
  static int d = 222;
  static long A = 111L;
  static long B = 111L;
  static long C = 222L;
  static long D = 222L;
  static Integer aa = 111;
  static Integer bb = 111;
  static Integer cc = 222;
  static Integer dd = 222;
  static Long AA = 111L;
  static Long BB = 111L;
  static Long CC = 222L;
  static Long DD = 222L;

  public static void main(String[] args) 
  {
    System.out.println(a==b);
    System.out.println(c==d);
    System.out.println(A==B);
    System.out.println(C==D);
    System.out.println(aa==bb);
    System.out.println(cc==dd);
    System.out.println(AA==BB);
    System.out.println(CC==DD);
  }
}

