/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package assignment;
import java.util.*;
import myTools.MyTools;
/**
 *
 * @author a
 */
public class Graphs {
    
   public List<Node> nodes;
   public List<Edge> edges;
   
    public Graphs() {
        this.nodes = new ArrayList<>();
        this.edges = new ArrayList<>();
    }
   
    public void addNode() {
        int n = Integer.parseInt(MyTools.readStr("Enter the number of Node you want to add", ".*"));
        for (int i = 1; i <= n; i++) {
            System.out.println("--------------------------------------------------------------------");
            int value = Integer.parseInt(MyTools.readStr("Enter value for node: ", ".*"));
            Node newNode = new Node(value);
            nodes.add(newNode);

        }

    }
    
    public boolean checkExistNode(int value){
        for(Node node : nodes){
            if(node.value == value){
                return true;
            }
        }
        return false;
    }
    
    public void addEdge() {
        int n = Integer.parseInt(MyTools.readStr("Enter the number of edge you want to add", ".*"));
        for (int i = 1; i <= n; i++) {
            int src;
            int des;
            int weight;
            System.out.println("----------------------------------------------------------------");
            do {
                src = Integer.parseInt(MyTools.readStr("Enter value of Start Node: ", ".*"));
                if (this.checkExistNode(src) == false) {
                    System.out.println("Node doesn't exist, pls enter again: ");
                }
            } while (this.checkExistNode(src) == false);

            do {
                des = Integer.parseInt(MyTools.readStr("Enter value of End Node: ", ".*"));
                if (this.checkExistNode(des) == false) {
                    System.out.println("Node doesn't exist, pls enter again: ");
                }
            } while (this.checkExistNode(des) == false);

            weight = Integer.parseInt(MyTools.readStr("Enter weigth of Edge", ".*"));

            Edge newEdge = new Edge(src, des, weight);
            edges.add(newEdge);
            for (Node node : nodes) {
                if (node.value == src) {
                    node.getEgdeList().add(newEdge);
                }
            }
        }
    }
    
    public void printGraph(){
        for(Node node : nodes){
            System.out.println(node.toString());
            System.out.println("Edge of Node: ");
            for(Edge edge : node.getEgdeList()){
                System.out.println(edge.toString());
            }
            System.out.println("--------------------------------------------------");
        }
    }
    public void generateRandomGraph() {
        int numNodes = Integer.parseInt(MyTools.readStr("Enter Max number of Node you want to have: ", ".*"));
        int maxWeight = Integer.parseInt(MyTools.readStr("Enter Max weight of Edge you want to have: ", ".*"));
        int minEdge = Integer.parseInt(MyTools.readStr("Enter Min number of Edge you want to have: ", ".*"));
        int maxEdge;
        do{
            maxEdge = Integer.parseInt(MyTools.readStr("Enter Max number of Edge you want to have: (less than " + numNodes * (numNodes - 1) + " )", ".*"));
            if(maxEdge >= numNodes * (numNodes - 1)){
                System.out.println("The number of Max Edge is too big, pls insert again");
            }
        }while(maxEdge >= numNodes * (numNodes - 1));
        
        List<String> usedEdge = new ArrayList<>();
        Random random = new Random();
        
       
        int numOfEdge;
        
        for(int i = 1; i <= numNodes; i ++){
            Node newNode = new Node(i);
            nodes.add(newNode);
        }
        
        do{
            numOfEdge = random.nextInt(maxEdge);
        }while(numOfEdge < minEdge);
        
        while(edges.size() < numOfEdge){
            int src = random.nextInt(numNodes) + 1;
            int des = random.nextInt(numNodes) + 1;
            int weight = random.nextInt(maxWeight) + 1;
            if(src != des && !usedEdge.contains(src + "-" + des)){
                Edge newEdge = new Edge(src, des, weight);
                edges.add(newEdge);
                usedEdge.add(src + "-" + des);
                for(Node node : nodes){
                    if(node.value == src){
                        node.getEgdeList().add(newEdge);
                    }
                }
            }
        }
        System.out.println("---------------------------------------------------");
        System.out.println("The Graph has been generated");
        System.out.println("Number of Nodes: " + nodes.size());
        System.out.println("Number of Edges:" + edges.size());
        System.out.println("---------------------------------------------------");

    }

// FLOYD ALGORITHM
   public void floydWarshall() {
    int V = nodes.size();
    int[][] dist = new int[V][V];

    // Initialize the distance matrix with initial values based on the edges
    for (int i = 0; i < V; i++) {
        for (int j = 0; j < V; j++) {
            if (i == j) {
                dist[i][j] = 0; // Distance from a node to itself is 0
            } else {
                dist[i][j] = Integer.MAX_VALUE; // Initialize all other distances to infinity
            }
        }
    }

    // Populate the distance matrix with the initial edge weights
    for (Node node : nodes) {
        int src = node.value - 1; // Adjust the source index
        for (Edge edge : node.getEgdeList()) {
            int dest = edge.des - 1; // Adjust the destination index
            dist[src][dest] = edge.getWeight();
        }
    }

    // Apply the Floyd-Warshall algorithm
    for (int k = 0; k < V; k++) {
        for (int i = 0; i < V; i++) {
            for (int j = 0; j < V; j++) {
                if (dist[i][k] != Integer.MAX_VALUE && dist[k][j] != Integer.MAX_VALUE && dist[i][j] > dist[i][k] + dist[k][j]) {
                    dist[i][j] = dist[i][k] + dist[k][j];
                }
            }
        }
    }

    // Print the shortest path distances between all pairs of nodes
    System.out.println("Shortest Path Distances (Floyd-Warshall Algorithm):");
    System.out.print("   ");
    for (int i = 0; i < V; i++) {
        System.out.printf("[%d]\t", i + 1);
    }
    System.out.println();
    for (int i = 0; i < V; i++) {
        System.out.printf("[%d] ", i + 1);
        for (int j = 0; j < V; j++) {
            if (dist[i][j] == Integer.MAX_VALUE) {
                System.out.print("INF\t");
            } else {
                System.out.printf("%d\t", dist[i][j]);
            }
        }
        System.out.println();
    }
}

// DIJKSTRA ALGORITHM
    // Helper method to get a Node by its value
    private Node getNodeByValue(int value) {
        for (Node node : nodes) {
            if (node.value == value) {
                return node;
            }
        }
        return null;
    }
    public Node findNodeByValue(int value) {
        for (Node node : nodes) {
            if (node.value == value) {
                return node;
            }
        }
        return null; 
    }
    
    public void dijkstra() {
        int sourceValue = Integer.parseInt(MyTools.readStr("Enter source Node's value", ".*"));
        Node sourceNode = findNodeByValue(sourceValue);
        
        Set<Node> visitedNodes = new HashSet<>();

        
        PriorityQueue<Node> priorityQueue = new PriorityQueue<>(Comparator.comparingInt(node -> node.distance));
        sourceNode.distance = 0;
        priorityQueue.add(sourceNode);

        while (!priorityQueue.isEmpty()) {
            Node currentNode = priorityQueue.poll();
            visitedNodes.add(currentNode);

            for (Edge edge : currentNode.getEgdeList()) {
                Node neighborNode = findNodeByValue(edge.des);
                if (!visitedNodes.contains(neighborNode)) {
                    int newDistance = currentNode.distance + edge.weight;
                    if (newDistance < neighborNode.distance) {
                        neighborNode.distance = newDistance;
                        neighborNode.previousNode = currentNode;
                        priorityQueue.add(neighborNode);
                    }
                }
            }
        }
    }

    public void printShortestPath() {
        int destinationValue = Integer.parseInt(MyTools.readStr("Enter destination Node's value", ".*"));
        Node destinationNode = findNodeByValue(destinationValue);
        if (destinationNode.distance == Integer.MAX_VALUE) {
            System.out.println("There is no path to the destination.");
        } else {
            System.out.println("Shortest path to destination:");
            Stack<Node> path = new Stack<>();
            Node currentNode = destinationNode;
            while (currentNode != null) {
                path.push(currentNode);
                currentNode = currentNode.previousNode;
            }
            while (!path.isEmpty()) {
                Node node = path.pop();
                System.out.print(node.value + " -> ");
            }
            System.out.println("Distance: " + destinationNode.distance);
        }
    }

// KRUSAL ALGORITHM
    public List<Edge> Krusal() {
        Comparator<Edge> cmp = new Comparator<Edge>() {
            @Override
            public int compare(Edge o1, Edge o2) {
                return o1.weight - o2.weight;
            }
        };
        Collections.sort(edges, cmp);
        int V = nodes.size();
        List<Edge> result = new ArrayList<>();
        int[] parent = new int[V];

        for (int i = 0; i < V; i++) {
            parent[i] = i;
        }

        int edgeCount = 0;

        for (Edge edge : edges) {
            if (edgeCount >= V - 1) {
                break;
            }
            int rootSrc = find(parent, edge.src);
            int rootDest = find(parent, edge.des);

            if (rootSrc != rootDest) {
                result.add(edge);
                union(parent, rootSrc, rootDest);
                edgeCount++;
            }
        }

        return result;
    }
    private int find(int[] parent, int node) {
        if (parent[node] != node) {
            parent[node] = find(parent, parent[node]);
        }
        return parent[node];
    }
    private void union(int[] parent, int src, int dest) {
        int rootSrc = find(parent, src);
        int rootDest = find(parent, dest);
        parent[rootSrc] = rootDest;
    }
    
}
   

