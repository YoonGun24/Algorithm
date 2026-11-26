import java.util.ArrayDeque;

ArrayDeque<Integer> queue = new ArrayDeque<Integer>();
ArrayList<Integer> order = new ArrayList<Integer>();
boolean[] seen = new boolean[6];
int[] parent = new int[6];
int current = -1;

void advance() {
  if (queue.isEmpty()) {
    finished = true;
    status = "Queue empty. All reachable vertices visited.";
    return;
  }
  current = queue.removeFirst();
  order.add(current);

  for (int next : graph[current]) {
    if (!seen[next]) {
      seen[next] = true;
      parent[next] = current;
      queue.addLast(next);
    }
  }
  status = "Visit " + label(current)
    + " and enqueue unseen neighbors.";
}

void start() {
  java.util.Arrays.fill(seen, false);
  java.util.Arrays.fill(parent, -1);
  queue.clear();
  order.clear();
  seen[0] = true;
  queue.addLast(0);
  current = -1;
  finished = false;
  status = "Enqueue A, the starting vertex.";
}

int[][] edges = {
  {0, 1}, {0, 2}, {1, 2}, {1, 3},
  {2, 4}, {3, 4}, {3, 5}, {4, 5}
};

int[][] graph = {
  {1, 2}, {0, 2, 3}, {0, 1, 4},
  {1, 4, 5}, {2, 3, 5}, {3, 4}
};

void drawGraph() {
  for (int[] edge : edges) {
    int u = edge[0], v = edge[1];
    boolean tree = parent[u] == v || parent[v] == u;
    connection(u, v, tree ? teal : neutral, tree ? 3 : 1.5);
  }
  for (int i = 0; i < graph.length; i++) {
    if (!finished && i == current) vertex(i, amber, #594324);
    else if (order.contains(i)) vertex(i, teal, #163C36);
    else if (seen[i]) vertex(i, amber, #3C3227);
    else vertex(i, neutral, panel);
  }
}

void drawDetails() {
  badges("Queue (front first)", queue, 405, amber);
  badges("Visit order", order, 436, teal);
}

float[][] positions = {
  {77, 233}, {193, 164}, {211, 308},
  {430, 164}, {408, 308}, {548, 233}
};

color ink = #DBE9F5, muted = #9FB3CA, panel = #142334;
color teal = #30E0AD, amber = #FFD078, neutral = #435A73;
boolean paused, finished;
int nextStep;
String status;

void setup() {
  size(630, 484);
  textFont(createFont("SansSerif", 19, true));
  replay();
}

void replay() {
  start();
  nextStep = millis() + 1450;
}

void draw() {
  if (!paused && !finished && millis() >= nextStep) {
    advance();
    nextStep = millis() + 1350;
  }
  background(#0D1723);
  textAlign(LEFT, TOP);
  fill(teal);
  textSize(14);
  text("GRAPH ALGORITHMS", 30, 20);
  fill(ink);
  textSize(32);
  text("Breadth-first search", 30, 42);
  fill(muted);
  textSize(16);
  text("Visit the graph one layer at a time.", 30, 86);

  noStroke();
  fill(panel);
  rect(26, 117, 578, 230, 12);
  drawGraph();

  textAlign(LEFT, CENTER);
  fill(finished ? teal : ink);
  textSize(18);
  text(status, 30, 365);
  drawDetails();

  textAlign(LEFT, CENTER);
  fill(muted);
  textSize(13);
  text("SPACE  Pause  /  resume       RIGHT  Step       R  Replay", 30, 465);
}

void badges(String title, Iterable<Integer> values, int y, color accent) {
  textAlign(LEFT, CENTER);
  fill(muted);
  textSize(16);
  text(title, 30, y);
  int x = 177;
  for (int vertex : values) {
    fill(panel);
    stroke(accent);
    strokeWeight(1);
    rect(x, y - 12, 29, 24, 5);
    fill(accent);
    noStroke();
    textAlign(CENTER, CENTER);
    text(label(vertex), x + 14.5, y - 1);
    x += 35;
  }
  if (x == 177) text("—", x, y);
}

void vertex(int i, color accent, color surface) {
  float x = positions[i][0], y = positions[i][1];
  stroke(accent);
  strokeWeight(2);
  fill(surface);
  circle(x, y, 43);
  fill(ink);
  textAlign(CENTER, CENTER);
  textSize(21);
  text(label(i), x, y - 2);
}

void connection(int u, int v, color accent, float weight) {
  stroke(accent);
  strokeWeight(weight);
  line(positions[u][0], positions[u][1], positions[v][0], positions[v][1]);
}

String label(int v) {
  return str((char) ('A' + v));
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
    nextStep = millis() + 1350;
  } else if (key == CODED && keyCode == RIGHT && !finished) {
    paused = true;
    advance();
  } else if (key == 'r' || key == 'R') {
    paused = false;
    replay();
  }
}
