/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package assignment;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author a
 */
public class Node {
    public int value;
    public List<Edge> egdeList;
    public int distance;
    public Node previousNode;

    public Node(int value) {
        this.value = value;
        this.egdeList = new ArrayList<>();
        this.distance = Integer.MAX_VALUE;
        this.previousNode = null;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public List<Edge> getEgdeList() {
        return egdeList;
    }

    public void setEgdeList(List<Edge> egdeList) {
        this.egdeList = egdeList;
    }

    @Override
    public String toString() {
        return "value of Node = " + value;
    }
    
   
    
    
    
}
