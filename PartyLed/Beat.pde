class Beat
{ 
  Boolean hat, snare, kick, onset;

  float level;

  Beat(Boolean h, Boolean s, Boolean k, Boolean o, float l)
  {
    hat = h;
    snare = s;
    kick = k;
    onset = o;
    level = l;
  }
}

void beatDetect()
{
  bdSound.setSensitivity(int(beatDelaySlider.getValue()));
  bdFreq.setSensitivity(int(beatDelaySlider.getValue()));
  bdSound.detect(in.mix);
  bdFreq.detect(in.mix);
}
 
float maxLevel=1;
float meanLevel=0;
float maxmeanLevel=0;
float goalMaxLevel=0;

void drawBeatBoard()
{

  fill(200, 100, 20);
  rect(10, 70, 344, 122);

  fill(120, 100, isHat() ? 100 : 20);
  rect(355, 70, 40, 40);
  fill(220, 100, isSnare() ? 100 : 20);
  rect(355, 111, 40, 40);
  fill(320, 100, isKick() ? 100 : 20);
  rect(355, 152, 40, 40);
  fill(0);

  textSize(32);
  textAlign(CENTER, CENTER);
  text("H", 375, 88);
  text("S", 375, 129);
  text("K", 375, 170);
  textAlign(LEFT, BOTTOM);
  drawBeatHistory(beatHistory, 10, 170);
}

void drawBeatHistory(LinkedList<Beat> history, int x, int y)
{
  goalMaxLevel=meanLevel=0;
  history.add(new Beat(isHat(), isSnare(), isKick(), isOnset(), getLevel()));
  for (int i=0; i < history.size(); i++) {
    Beat b = history.get(i);
    meanLevel+=b.level;
    if(b.level>goalMaxLevel)goalMaxLevel=b.level;
  }
  if(maxLevel<goalMaxLevel)maxLevel+=(goalMaxLevel-maxLevel)/2;
  meanLevel/=history.size();
  
  for (int i=0; i < history.size(); i++) {
    Beat b = history.get(i);

    if (b.hat)
      stroke(120, 100, 100);
    else if (b.snare)
      stroke(220, 100, 100);
    else if (b.kick)
      stroke(320, 100, 100);
    else if (b.onset)
      stroke(0, 0, 100);
    else
      stroke(200, 100, 50);


    float d = 95*(b.level/maxLevel);
    line(x+i, y-d, x+i, y);

    if (b.hat)
      stroke(120, 100, 30);
    else if (b.snare)
      stroke(220, 100, 30);
    else if (b.kick)
      stroke(320, 100, 30);
    else if (b.onset)
      stroke(0, 0, 30);
    else
      stroke(200, 100, 30);

    float e =20*b.level/maxLevel;
    line(x+i, y+e, x+i, y);
  }
  if (history.size()>= 343)
    history.removeFirst();
  stroke(50, 0, 100);
  float m = (meanLevel/maxLevel*95);
  line(x, y-m, x+343, y-m);
  
  // Draw Kick line
  stroke(320, 80, 60);
  float n = (minKickLevelSlider.getValue()/maxLevel*95);
  if(n>98){stroke(50, 20, 60-n%98);n=98;}
  line(x, y-n, x+343, y-n);
  
  // Draw Snare line  
  stroke(220, 80, 60);
  n = (minSnareLevelSlider.getValue()/maxLevel*95);
   if(n>98){stroke(50, 20, 60-n%98);n=98;}
  line(x, y-n, x+343, y-n);

  // Draw Hat line
  stroke(120, 80, 60);
  n = (minHatLevelSlider.getValue()/maxLevel*95);
   if(n>98){stroke(50, 20, 60-n%98);n=98;}
  line(x, y-n, x+343, y-n);
  
  stroke(0);
  maxLevel*=0.99;
}
