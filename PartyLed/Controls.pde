Button projectorToggle, videoToggle,slowModeToggle;
Slider beatDelaySlider, minKickLevelSlider,minSnareLevelSlider,minHatLevelSlider,brigthnessSlider,smoothnesSlieder,lineSizeSlider;

void initControls()
{
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("Monospace", 12));

  projectorToggle = cp5.addButton("connect").setPosition(338, 10).setSize(90,50);
  projectorToggle.getCaptionLabel().set("Connect").align(ControlP5.CENTER, ControlP5.CENTER);
  
  slowModeToggle = cp5.addButton("slow").setPosition(232, 10).setSize(50, 50);
  slowModeToggle.getCaptionLabel().set("Slow").align(ControlP5.CENTER, ControlP5.CENTER);
  
  videoToggle = cp5.addButton("video").setPosition(285, 10).setSize(50, 50);
  videoToggle.getCaptionLabel().set("Video").align(ControlP5.CENTER, ControlP5.CENTER);

  beatDelaySlider = cp5.addSlider("beatDelay").setSize(418, 20).setPosition(10, 194).setRange(10, 1000);
  beatDelaySlider.getCaptionLabel().set("Beat Delay (ms)").align(ControlP5.CENTER, ControlP5.CENTER);
  beatDelaySlider.setValue(200);

  minKickLevelSlider = cp5.addSlider("minKickLevel").setSize(10, 122).setPosition(396, 70).setRange(0, 1);
  minKickLevelSlider.setLabelVisible(false);
  minKickLevelSlider.setValue(0.1);
  
  minSnareLevelSlider = cp5.addSlider("minSnareLevel").setSize(10, 122).setPosition(407, 70).setRange(0, 1);
  minSnareLevelSlider.setLabelVisible(false);
  minSnareLevelSlider.setValue(0.1);
  
  minHatLevelSlider = cp5.addSlider("minHatLevel").setSize(10, 122).setPosition(418, 70).setRange(0, 1);
  minHatLevelSlider.setLabelVisible(false);
  minHatLevelSlider.setValue(0.1);
  
  smoothnesSlieder = cp5.addSlider("smooth").setSize(10, 144).setPosition(411, 230).setRange(0, 200);
  smoothnesSlieder.setLabelVisible(false);
  smoothnesSlieder.setValue(40);
  
  brigthnessSlider = cp5.addSlider("bright").setSize(30, 144).setPosition(370, 230).setRange(0, 1);
  brigthnessSlider.setLabelVisible(false);
  brigthnessSlider.setValue(1);
  
  lineSizeSlider = cp5.addSlider("lineSize").setSize(225, 40).setPosition(196, 380).setRange(1, 64);
  lineSizeSlider.getCaptionLabel().set("fft element size").align(ControlP5.CENTER, ControlP5.CENTER);
  lineSizeSlider.setValue(8);
}
float smoothBackup=0,kick=0,hat=0,snare=0;
boolean videoMode = false;
int b = 0;
void controlEvent(ControlEvent event)
{
  if (event.getName()=="slow")
    slowMode=slowMode?false:true;
  if (event.getName()=="connect")
    myClient = new Client(this, "192.168.178.42", 5001); 
  if (event.getName()=="video")
  {
    videoMode=videoMode?false:true;
    if(videoMode==true){
      kick=minKickLevelSlider.getValue();
      snare=minSnareLevelSlider.getValue();
      hat=minHatLevelSlider.getValue();
      smoothBackup=smoothnesSlieder.getValue();
    }
    minKickLevelSlider.setValue(videoMode?1:kick);
    minSnareLevelSlider.setValue(videoMode?1:snare);
    minHatLevelSlider.setValue(videoMode?1:hat);
    smoothnesSlieder.setValue(videoMode?130:smoothBackup);
  }
}


