import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.DisplayMode;

import java.util.LinkedList;
import controlP5.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.net.*; 


String version = "0.0.1";

GraphicsDevice[] gs;

ControlP5 cp5;

Minim minim;

AudioSource in;

BeatDetect bdFreq, bdSound;

FFT fft;

LinkedList<Beat> beatHistory = new LinkedList();


Client myClient; 


Color newcol ;

void setup() {
  GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
  gs = ge.getScreenDevices();


  size(435, 435);
  frame.setTitle("Party LED "+version);
  frame.setIconImage( getToolkit().getImage("sketch.ico") );
  frame.setResizable(true);

  Minim minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize()*fftSize, in.sampleRate());
  bdFreq = new BeatDetect(in.bufferSize(), in.sampleRate());
  bdSound = new BeatDetect();
//bdFreq.detectMode(BeatDetect.SOUND_ENERGY);

  colorMode(HSB, 360, 100, 100);

  initControls();
  
   newcol = new Color();
   KickColor = new Color();
   
}

int mod(int a, int b){
  if(a>0)return a%b;
  a*=-1;
  return a%b;
}

float a=0;
int speed=1;
Color KickColor ;
int flow = 0;
int lastBeat=0;
float fac = 1;
float goalA;
boolean slowMode = false;

void draw() { 
   
  //minLevelSlider.setValue(maxLevel-meanLevel);
  lastBeat++;
  background(24,10,10);
  noStroke();
  beatDetect();

  drawBeatBoard();
  drawFrequencies( 10, 340);
    
  KickColor.r *= 0.9;
  KickColor.g *= 0.9;
  KickColor.b *= 0.9;
  
  
  if(lastBeat>600||slowMode){
    if(fac<8)
      fac+=0.01;
      text(fac,10,60);
    a+=0.001;
  }else
  {
    fac=2;
    a+=0.1;
  }
  
    
  if(flow>0)
  {
    a=(a*14+goalA)/15;
    text("flow",120,60);
    flow--;
  }
  
  a%=256;
  Color col = Wheel(int((a+meanMaxIndex*fac)%255));
  
  if(isHat() ) {if(flow==0){goalA =mod(int(a+40),256);flow=15;}}
  if(isKick()) {if((lastBeat>10&&!slowMode)||(slowMode&&lastBeat>20)){KickColor = Wheel(mod(int(a-50),255)); lastBeat=0;}}
  if(isSnare()){}
  if(isOnset())  {}
  
  
  int factor = int(getLevel()/meanLevel*1.5);
  if(lastBeat>100&&factor<1){factor*=1.1;}
  newcol.r = int(col.r*meanLevel/maxLevel);
  newcol.g = int(col.g*meanLevel/maxLevel);
  newcol.b = int(col.b*meanLevel/maxLevel);

  if(lastBeat>2000)lastBeat=2000;
  if((newcol.r =newcol.r + KickColor.r)>255)newcol.r=255;
  if((newcol.g =newcol.g + KickColor.g)>255)newcol.g=255;
  if((newcol.b =newcol.b + KickColor.b)>255)newcol.b=255;

  
  if(myClient!=null){
      myClient.write(int(newcol.r*brigthnessSlider.getValue()));
      myClient.write(int(newcol.g*brigthnessSlider.getValue()));
      myClient.write(int(newcol.b*brigthnessSlider.getValue()));
      myClient.write(int(newcol.r*brigthnessSlider.getValue()));
      myClient.write(int(newcol.g*brigthnessSlider.getValue()));
      myClient.write(int(newcol.b*brigthnessSlider.getValue()));
    }
    stroke(0,0,int(brigthnessSlider.getValue()*100));
    float[] colors = java.awt.Color.RGBtoHSB(newcol.r,newcol.g,newcol.b,null);
    fill(colors[0]*360,colors[1]*100,colors[2]*100);
    rect(10,380,40,40);
   
    colors = java.awt.Color.RGBtoHSB(col.r,col.g,col.b,null);
    fill(colors[0]*360,colors[1]*100,colors[2]*100);
    rect(52,380,40,40);
   
    Color goalCol = Wheel(int(goalA%255));;
    colors = java.awt.Color.RGBtoHSB(goalCol.r,goalCol.g,goalCol.b,null);
    fill(colors[0]*360,colors[1]*100,colors[2]*100);
    rect(94,380,40,40);
  
    colors = java.awt.Color.RGBtoHSB(KickColor.r,KickColor.g,KickColor.b,null);
    fill(colors[0]*360,colors[1]*100,colors[2]*100);
    rect(136,380,40,40);
}

boolean isHat()
{
  return getLevel()>minHatLevelSlider.getValue()?bdFreq.isHat():false;
}

boolean isSnare()
{
  return getLevel()>minSnareLevelSlider.getValue()?bdFreq.isSnare():false;
}

boolean isKick()
{
  return getLevel()>minKickLevelSlider.getValue()?bdFreq.isKick():false;
}

boolean isOnset()
{
  return getLevel()>minKickLevelSlider.getValue()?bdSound.isOnset():false;
}

float getLevel()
{
  if(in.mix.level()<0.0001)return 0;
  return in.mix.level();
}
