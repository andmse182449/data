/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package assignment;

import java.util.List;

/**
 *
 * @author a
 */
public class Assignment {

    /**
     * @param args the command line arguments
     */
     public static void main(String[] args) {
        Graphs graph = new Graphs();
        graph.generateRandomGraph();
        graph.printGraph();
        graph.floydWarshall();
//        graph.dijkstra();
//        graph.printShortestPath();
    }
    
}
