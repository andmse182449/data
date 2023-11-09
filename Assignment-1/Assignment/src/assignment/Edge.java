/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package assignment;

/**
 *
 * @author a
 */
public class Edge {
    public int src;
    public int des;
    public int weight;
    public boolean visited;
    
    public Edge(int src, int des, int weight) {
        this.src = src;
        this.des = des;
        this.weight = weight;
        this.visited = false;
    }

    public int getSrc() {
        return src;
    }

    public void setSrc(int src) {
        this.src = src;
    }

    public int getDes() {
        return des;
    }

    public void setDes(int des) {
        this.des = des;
    }

    public int getWeight() {
        return weight;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }

    @Override
    public String toString() {
        return src + " -------> " + des + ", weight = " + weight;
    }
    
    
}
