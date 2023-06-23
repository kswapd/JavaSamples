/**
 * 
 */
package com.soft.daysofcode.javacharacter.datastructures;

/**
 * @author Kanahaiya Gupta
 *
 */
public class JavaGenerics {
	// Write your code here
	public <T> void printArray(T[] in) {

		for (T t : in) {
			System.out.println(t);
		}
	}
}
