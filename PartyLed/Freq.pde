class fftBuffer implements AudioBuffer{
  int size=0;
  int elems=0;
  float bufferList[];
  
  fftBuffer(int size){
    bufferList = new float[size*fftSize];
    this.size=size;
  }
  AudioBuffer add(AudioBuffer in){
    float temp[] = new float[size*fftSize];
    arrayCopy(bufferList, size, temp, 0, size*(fftSize-1));
    arrayCopy(in.toArray(),0,temp,size*(fftSize-1),size);
    bufferList=temp;
    return this;
  }  
  int size(){return bufferList.length;}
  float get(int i){
    return bufferList[i];
  }
  float[] toArray(){
  return bufferList;
  }
  float level(){
    float level=0;
    for(int i = 0; i<bufferList.length;i++)
    {
      level+=bufferList[i];
    }
    level/=bufferList.length;
    return level;
  }
}

fftBuffer buffer ;

int fftSize = 4;

float meanFreq=0;
float maxFreq=0;
float midFreq=0;
float freqSum=0;

int maxIndex = 0;
float meanMaxIndex = 0;

void drawFrequencies(int x, int y){
  if(buffer==null)buffer=new fftBuffer(in.mix.size());
  int linesize = int(lineSizeSlider.getValue());
  
  stroke(100);
  fill(200, 100, 20);
  rect(10, 230, 343, 142);
  fft.forward(buffer.add(in.mix));
  int i;
  fill(0,30,100);
  freqSum=0;
  maxIndex = 0;
  maxFreq = 0;
  for(i = 0; i < fft.specSize(); i++)
  {
    float freq =  fft.getBand(i);
    if(freq>=maxFreq){maxFreq=freq;maxIndex=i;}
    freqSum += freq;
    if(x+i*linesize+linesize>350)break;
  }
  meanFreq=freqSum/i;
  noStroke();
  for(i = 0; i < fft.specSize(); i++)
  {
    // draw the line for frequency band i, scaling it by 4 so we can see it a bit better
    float freq =  fft.getBand(i);
    
    fill(0,30,100);
    if(i==maxIndex){fill(120,100,100);}
    rect(x+i*linesize, y-freq/3, linesize,freq/3);
    fill(0,30,30);
     if(i==maxIndex){fill(120,30,30);}
    rect(x+i*linesize, y, linesize,freq/12);
    if(x+i*linesize+linesize>350)break;
  }
 
  if(meanLevel<0.01)maxIndex*=0.8;
  meanMaxIndex = ((meanMaxIndex*smoothnesSlieder.getValue())+maxIndex)/(smoothnesSlieder.getValue()+1);
  
  stroke(0, 0, 100);
  rect(x+meanMaxIndex*linesize, y, linesize, 30);
  
  line(x, y-meanFreq/3, x+(i+1)*linesize, y -meanFreq/3);
  fill(255);
}
