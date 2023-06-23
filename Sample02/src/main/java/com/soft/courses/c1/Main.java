package com.soft.courses.c1;

import static java.lang.Thread.*;

public class Main {
  public static void main(String [] args){
    while (true){
      System.out.println("Hi, java");
      try {
        sleep(1000);
      } catch (InterruptedException e) {
        throw new RuntimeException(e);
      }
    }

  
  }
}
