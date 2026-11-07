// Processing Java Mode: minimum path sum (right / down only).
int cnt = 3;
int[][] m = new int[cnt+1][cnt+1];
int[][] dp = new int[cnt+1][cnt+1];
boolean[][] path = new boolean[cnt+1][cnt+1];
int tick = 0;
boolean paused = false;

// Original recursive recurrence: includes both start and destination.
int matrixPath(int i, int j) {
  if (i == 1 && j == 1) return m[i][j];
  else if (i == 1) return matrixPath(1, j-1) + m[i][j];
  else if (j == 1) return matrixPath(i-1, 1) + m[i][j];
  else return min(matrixPath(i-1, j), matrixPath(i, j-1)) + m[i][j];
}

void calculate() {
  // Store each result once to avoid repeated recursive calculations.
  for (int i = 1; i <= cnt; i++) {
    for (int j = 1; j <= cnt; j++) {
      if (i == 1 && j == 1) dp[i][j] = m[i][j];
      else if (i == 1) dp[i][j] = dp[i][j-1] + m[i][j];
      else if (j == 1) dp[i][j] = dp[i-1][j] + m[i][j];
      else dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + m[i][j];
    }
  }
  for (boolean[] row : path) java.util.Arrays.fill(row, false);
  int i = cnt, j = cnt;
  while (true) {
    path[i][j] = true;
    if (i == 1 && j == 1) break;
    if (i == 1) j--;
    else if (j == 1) i--;
    else if (dp[i-1][j] <= dp[i][j-1]) i--;
    else j--;
  }
  if (dp[cnt][cnt] != matrixPath(cnt, cnt))
    throw new RuntimeException("Recursive and DP results differ");
}

void setup() {
  size(720, 520);
  surface.setLocation(650, 150);
  pixelDensity(1);
  frameRate(15);
  textFont(createFont("SansSerif", 16));
  randomSeed(42); // Reproducible random example, values 0 through 9.
  newMatrix();
}

void newMatrix() {
  for (int i = 1; i <= cnt; i++) {
    for (int j = 1; j <= cnt; j++) {
      m[i][j] = (int) random(10);
      print(nfp(m[i][j], 2) + " ");
    }
    println();
  }
  calculate();
  println("Minimum path sum: " + dp[cnt][cnt]);
  tick = 0;
}

void draw() {
  int step = min(tick / 20, cnt*cnt);
  int row = min(cnt, step/cnt + 1), col = step%cnt + 1;
  boolean done = step >= cnt*cnt;
  background(13, 22, 36);
  fill(62, 220, 187); textSize(12); text("DYNAMIC PROGRAMMING / MATRIX PATH", 28, 30);
  fill(231, 238, 247); textSize(28); text("Minimum path sum", 28, 68);
  fill(158, 175, 196); textSize(14); text("Start at (1,1). Move right or down. Include every visited cell.", 28, 96);
  text("MATRIX / VALUES", 40, 134); text("DP / MINIMUM SUM", 384, 134);
  for (int i = 1; i <= cnt; i++) {
    for (int j = 1; j <= cnt; j++) {
      int index = (i-1)*cnt+j-1;
      boolean active = !done && i == row && j == col;
      boolean chosen = done && path[i][j];
      int border = chosen ? color(62,220,187) : active ? color(255,199,94) : color(53,70,91);
      for (int board = 0; board < 2; board++) {
        int x = 40 + board*344 + (j-1)*92, y = 154+(i-1)*68;
        stroke(border); strokeWeight(active || chosen ? 2 : 1);
        fill(chosen ? color(22,73,68) : active ? color(72,57,34) : color(24,38,57));
        rect(x, y, 80, 56, 8);
        fill(chosen ? color(62,220,187) : color(232,238,247)); textSize(22); textAlign(CENTER);
        text(board == 0 ? str(m[i][j]) : index <= step ? str(dp[i][j]) : "-", x+40, y+36);
        textAlign(LEFT);
      }
    }
  }
  noStroke(); fill(24,38,57); rect(28, 378, 664, 92, 10);
  fill(done ? color(62,220,187) : color(255,199,94)); textSize(18);
  if (done) {
    text("Minimum path sum = " + dp[cnt][cnt], 46, 409);
    fill(224,234,245); textSize(14); text("The highlighted cells form one optimal path.", 46, 443);
  } else {
    text("Calculate DP["+row+"]["+col+"]", 46, 409);
    String formula;
    if (row == 1 && col == 1) formula = "Start: " + m[row][col];
    else if (row == 1) formula = dp[row][col-1] + " + " + m[row][col];
    else if (col == 1) formula = dp[row-1][col] + " + " + m[row][col];
    else formula = "min("+dp[row-1][col]+", "+dp[row][col-1]+") + "+m[row][col];
    fill(224,234,245); textSize(16); text(formula + " = " + dp[row][col], 46, 443);
  }
  fill(153,171,193); textSize(12); text("SPACE  Pause     R  Replay     N  New random matrix", 28, 501);
  if (!paused) tick++;
  if (tick >= cnt*cnt*20+45) tick = 0;
}

void keyPressed() {
  if (key == ' ') paused = !paused;
  if (key == 'r' || key == 'R') { tick = 0; paused = false; }
  if (key == 'n' || key == 'N') { newMatrix(); paused = false; }
}
