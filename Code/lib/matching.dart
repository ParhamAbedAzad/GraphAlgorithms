bool bpm(List<List<int>> graph, int u, List<bool> seen, List<int> matched,
    int n, int m) { //dfs to check if we can we can find a matching for u
  for (int v = 0; v < m; v++) {
    if (graph[u][v] == 1 && !seen[v]) {
      seen[v] = true;
      if (matched[v] < 0 || bpm(graph, matched[v], seen, matched, n, m)) {
        matched[v] = u;
        return true;
      }
    }
  }
  return false;
}
// get maximum matching
List<List<int>> maximumMatching(List<List<int>> graph, int n, int m) {
  List<List<int>> madeGraph = graph.sublist(0, n); //make a graph from the adjacency graph that was made in showmatching page
  for (int i = 0; i < madeGraph.length; i++) {
    madeGraph[i] = madeGraph[i].sublist(n);
  }
  List<int> matched = List<int>.filled(m, -1); // keep track of matched vertexes
  for (int u = 0; u < n; u++) {
    List<bool> seen = List<bool>.filled(m, false);
    bpm(madeGraph, u, seen, matched, n, m);
  }
  List result = List<List<int>>();
  for (int i = 0; i < n + m; i++) {
    result.add(List.filled(n + m, 0));
  }
  for (int i = 0; i < matched.length; i++) {
    if (matched[i] == -1) continue;
    result[matched[i]][i + n] = 1;
    result[i + n][matched[i]] = 1;
  }
  return result;
}