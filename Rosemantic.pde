import processing.pdf.*;
import controlP5.*;

public ControlP5 cp5;

public PVector origin = new PVector(680, 350);
public color backgroundColor = color(0, 0, 0);

public int fileNum = 0;
public String fileName = "rose";
public int num = 1;

public boolean shouldRandomize = false;

public int repetitions = 0;
public int actualSelectedRepetitions = 0;

public float minRay = 1;
public float maxRay = 150;

public float minAngle = 0;
public float maxAngle = 180;

public float minHue1 = 0;
public float maxHue1 = 360;
public float minSaturation1 = 0;
public float maxSaturation1 = 100;
public float minBrightness1 = 0;
public float maxBrightness1 = 100;

public float minHue2 = 0;
public float maxHue2 = 360;
public float minSaturation2 = 0;
public float maxSaturation2 = 100;
public float minBrightness2 = 0;
public float maxBrightness2 = 100;

public PVector[] vectors1 = new PVector[repetitions];
public PVector[] vectors2 = new PVector[repetitions];
public PVector[] vectors3 = new PVector[repetitions];

public color[] colors1 = new color[repetitions];
public color[] colors2 = new color[repetitions];

public float alpha = 1;

public int blending = BLEND;

void setup() {
  size(980, 700, OPENGL);
  colorMode(HSB, 360, 100, 100, 1);
  background(backgroundColor);

  cp5 = new ControlP5(this);

  Button buttonLoad = cp5.addButton("load")
    .setPosition(10, 10)
      .setSize(140, 20);
  buttonLoad.getCaptionLabel().align( CENTER, CENTER);

  Button buttonSave = cp5.addButton("save")
    .setPosition(170, 10)
      .setSize(140, 20);
  buttonSave.getCaptionLabel().align( CENTER, CENTER);

  cp5.addSlider("repetitions")
    .setPosition(10, 50)
      .setSize(300, 15)
        .setRange(1, 100)
          .setValue(50);

  cp5.addRange("ray")
    .setBroadcast(false) 
      .setPosition(10, 70)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minRay, maxRay)
              .setRangeValues(minRay, maxRay)
                .setBroadcast(true);

  cp5.addRange("angle")
    .setBroadcast(false) 
      .setPosition(10, 90)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minAngle, maxAngle)
              .setRangeValues(minAngle, maxAngle)
                .setBroadcast(true);

  cp5.addRange("hue1")
    .setBroadcast(false) 
      .setPosition(10, 120)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minHue1, maxHue1)
              .setRangeValues(minHue1, maxHue1)
                .setBroadcast(true);

  cp5.addRange("saturation1")
    .setBroadcast(false) 
      .setPosition(10, 140)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minSaturation1, maxSaturation1)
              .setRangeValues(minSaturation1, maxSaturation1)
                .setBroadcast(true);

  cp5.addRange("brightness1")
    .setBroadcast(false) 
      .setPosition(10, 160)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minBrightness1, maxBrightness1)
              .setRangeValues(minBrightness1, maxBrightness1)
                .setBroadcast(true);

  cp5.addRange("hue2")
    .setBroadcast(false) 
      .setPosition(10, 190)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minHue2, maxHue2)
              .setRangeValues(minHue2, maxHue2)
                .setBroadcast(true);

  cp5.addRange("saturation2")
    .setBroadcast(false) 
      .setPosition(10, 210)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minSaturation2, maxSaturation2)
              .setRangeValues(minSaturation2, maxSaturation2)
                .setBroadcast(true);

  cp5.addRange("brightness2")
    .setBroadcast(false) 
      .setPosition(10, 230)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minBrightness2, maxBrightness2)
              .setRangeValues(minBrightness2, maxBrightness2)
                .setBroadcast(true);

  cp5.addSlider("alpha")
    .setPosition(10, 260)
      .setSize(300, 15)
        .setRange(0, 1)
          .setValue(1);

  DropdownList dropdownBlending = cp5.addDropdownList("blending")
    .setPosition(10, 300)
      .setSize(300, 165)
        .setItemHeight(15)
          .setBarHeight(15)
            .actAsPulldownMenu(true);
  dropdownBlending.setIndex(0);
  dropdownBlending.addItem("BLEND", BLEND);
  dropdownBlending.addItem("ADD", ADD);
  dropdownBlending.addItem("SUBTRACT", SUBTRACT);
  dropdownBlending.addItem("DARKEST", DARKEST);
  dropdownBlending.addItem("LIGHTEST", LIGHTEST);
  //dropdownBlending.addItem("DIFFERENCE", DIFFERENCE);
  dropdownBlending.addItem("EXCLUSION", EXCLUSION);
  dropdownBlending.addItem("MULTIPLY", MULTIPLY);
  dropdownBlending.addItem("SCREEN", SCREEN);
  dropdownBlending.addItem("REPLACE", REPLACE);

  Button buttonRandomize = cp5.addButton("randomize")
    .setPosition(10, 465)
      .setSize(140, 120);
  buttonRandomize.getCaptionLabel().align(CENTER, CENTER);

  cp5.addSlider("num")
    .setPosition(170, 465)
      .setSize(140, 20)
        .setRange(1, 100)
          .setValue(1);

  Button buttonPdf = cp5.addButton("export_pdf")
    .setPosition(170, 490)
      .setSize(140, 20);
  buttonPdf.getCaptionLabel().align( CENTER, CENTER);

  Button buttonPdf2 = cp5.addButton("export_pdf_cycle_hue")
    .setPosition(170, 515)
      .setSize(140, 20);
  buttonPdf2.getCaptionLabel().align( CENTER, CENTER);

  Button buttonSvg = cp5.addButton("export_svg")
    .setPosition(170, 540)
      .setSize(140, 20);
  buttonSvg.getCaptionLabel().align( CENTER, CENTER);

  Button buttonSvg2 = cp5.addButton("export_svg_cycle_hue")
    .setPosition(170, 565)
      .setSize(140, 20);
  buttonSvg2.getCaptionLabel().align( CENTER, CENTER);

  Toggle toggleBackground = cp5.addToggle("background")
    .setPosition(10, 680)
      .setSize(300, 15)
        .setValue(true)
          .setMode(ControlP5.SWITCH);
  toggleBackground.getCaptionLabel().align(ControlP5.RIGHT_OUTSIDE, CENTER);
  toggleBackground.captionLabel().style().marginLeft = 5;

  randomize();
}


void draw() {
  background(backgroundColor);
  fill(color(0, 0, 25));
  rect(0, 0, 380, 700);

  fill(color(0, 0, 0));
  rect(10, 675, 150, 5);

  fill(color(0, 0, 100));
  rect(160, 675, 150, 5);

  paintGradient(10, 115, 300, 5);
  paintGradient(10, 185, 300, 5);

  if (shouldRandomize) {
    randomizeVectors();
    shouldRandomize = false;
  }
  drawVectors();
}

void paintGradient(float x, float y, float width, float height) {
  for (int i = 0; i < width; ++i) {
    float hue = map(i/width, 0, 1, 0, 360);
    stroke(hue, 100, 100);
    line(x+i, y, x+i, y+height);
  }
}

void controlEvent(ControlEvent event) {
  // min and max values are stored in an array.
  // access this array with controller().arrayValue().
  // min is at index 0, max is at index 1.
  if (event.isFrom("ray")) {
    minRay = int(event.getController().getArrayValue(0));
    maxRay = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("angle")) {
    minAngle = int(event.getController().getArrayValue(0));
    maxAngle = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("hue1")) {
    minHue1 = int(event.getController().getArrayValue(0));
    maxHue1 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("saturation1")) {
    minSaturation1 = int(event.getController().getArrayValue(0));
    maxSaturation1 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("brightness1")) {
    minBrightness1 = int(event.getController().getArrayValue(0));
    maxBrightness1 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("hue2")) {
    minHue2 = int(event.getController().getArrayValue(0));
    maxHue2 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("saturation2")) {
    minSaturation2 = int(event.getController().getArrayValue(0));
    maxSaturation2 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("brightness2")) {
    minBrightness2 = int(event.getController().getArrayValue(0));
    maxBrightness2 = int(event.getController().getArrayValue(1));
  } else if (event.isGroup() && event.name().equals("blending")) {
    blending = (int) event.group().value();
  }
}

void background(boolean flag) {
  if (flag == true) {
    backgroundColor = color(0, 0, 0);
  } else {
    backgroundColor = color(0, 0, 100);
  }
}

void load() {
  selectInput("Select a parameters file to load", "load_callback");
}

void load_callback(File selection) {
  if (selection != null && selection.getName().toLowerCase().endsWith(".ser")) {
    cp5.loadProperties(selection.getAbsolutePath());
    randomize();
  }
}

void save() {
  selectOutput("Select a parameters file to save to", "save_callback");
}

void save_callback(File selection) {
  if (selection != null) {
    cp5.saveProperties(selection.getAbsolutePath());
  }
}

void repetitions(int number) {
  actualSelectedRepetitions = number;
}

void alpha(float number) {
  alpha = number;
}

void randomize() {
  vectors1 = new PVector[actualSelectedRepetitions];
  vectors2 = new PVector[actualSelectedRepetitions];
  vectors3 = new PVector[actualSelectedRepetitions];
  colors1 = new color[actualSelectedRepetitions];
  colors2 = new color[actualSelectedRepetitions];
  shouldRandomize = true;
  repetitions = actualSelectedRepetitions;
}

void num(int number) {
  num =  number;
}

void drawPdf(boolean turnHue) {
  float stepSize = 360 / (float)num;

  for (int i = 0; i < num; i++) {
    PGraphics pdf = createGraphics(600, 600, PDF, fileName + "-" + (fileNum + 1) + ".pdf");
    pdf.beginDraw();

    pdf.colorMode(HSB, 360, 100, 100, 1);
    pdf.noStroke();
    pdf.blendMode(blending);

    pdf.fill(0, 0, 0, 0);
    pdf.rect(0, 0, 600, 600);

    for (int k = 0; k < repetitions; k++) {
      pdf.fill(colors1[k], alpha);
      pdf.triangle(300, 300, 300 + vectors1[k].x, 300 + vectors1[k].y, 300 + vectors3[k].x, 300 + vectors3[k].y);
      pdf.fill(colors2[k], alpha);
      pdf.triangle(300, 300, 300 + vectors2[k].x, 300 + vectors2[k].y, 300 + vectors3[k].x, 300 + vectors3[k].y);
    }

    pdf.dispose();
    pdf.endDraw();

    fileNum++;
    if (num > 1) {

      if (turnHue) {
        turnHue(stepSize);
      }

      randomizeVectors();
    }
  }

  randomize();
}

void export_pdf() {
  drawPdf(false);
}

void export_pdf_cycle_hue() {
  drawPdf(true);
}

void export_svg() {
  drawSvg(true);
}

void export_svg_cycle_hue() {
  drawSvg(true);
}

void drawSvg(boolean turnHue) {
  float stepSize = 360 / (float)num;

  for (int i = 0; i < num; i++) {

    StringBuffer sb = new StringBuffer();
    sb.append("<?xml version=\"1.0\" standalone=\"no\"?>\n");
    sb.append("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n");
    sb.append("<svg viewBox=\"0 0 600 600\" xmlns=\"http://www.w3.org/2000/svg\" version =\"1.1\">\n");
    for (int k = 0; k < repetitions; k++) {
      sb.append(
      "  <polygon points=\"300,300 " + (300 + vectors1[k].x) + "," + (300 + vectors1[k].y) + " " + (300 + vectors3[k].x) + "," + (300 + vectors3[k].y)
        + "\" fill=\"#" + hex(colors1[k], 6) + "\" "
        + "style=\"opacity:" + alpha + "\""
        + "/>" + "\n"
        );
      sb.append(
      "  <polygon points=\"300,300 " + (300 + vectors2[k].x) + "," + (300 + vectors2[k].y) + " " + (300 + vectors3[k].x) + "," + (300 + vectors3[k].y)
        + "\" fill=\"#" + hex(colors2[k], 6) + "\" "
        + "style=\"opacity:" + alpha + "\""
        + "/>" + "\n"
        );
    }
    sb.append("</svg>\n");

    String[] lines = new String[1];
    lines[0] = sb.toString();
    saveStrings(fileName + "-" + (fileNum + 1) + ".svg", lines);

    fileNum++;
    if (num > 1) {

      if (turnHue) {
        turnHue(stepSize);
      }

      randomizeVectors();
    }
  }

  randomize();
}

void turnHue(float stepSize) {
  minHue1 += stepSize;
  if (minHue1 > 360) minHue1 -= 360;
  maxHue1 += stepSize;
  if (maxHue1 > 360) maxHue1 -= 360;
  minHue2 += stepSize;
  if (minHue2 > 360) minHue2 -= 360;
  maxHue2 += stepSize;
  if (minHue2 > 360) minHue2 -= 360;
}

void randomizeVectors() {
  for (int k = 0; k < repetitions; k++) {

    float angle1 = random(0, 360);
    PVector vector1 = PVector.fromAngle(radians(angle1));
    vector1.setMag(random(minRay, maxRay));

    float angle2 = angle1 + random(minAngle, maxAngle);
    PVector vector2 = PVector.fromAngle(radians(angle2));
    vector2.setMag(random(minRay, maxRay));

    vectors1[k] = vector1;
    vectors2[k] = vector2;
    vectors3[k] = PVector.add(vector1, vector2);

    float rhue1 = 0;
    if (minHue1 > maxHue1) {
      float range = 360 - minHue1 + maxHue1;
      float rv = random(0, range);
      rhue1 = minHue1 + rv;
      if (rhue1 > 360) rhue1 -= 360;
    } else {
      rhue1 = random(minHue1, maxHue1);
    }

    float rhue2 = 0;
    if (minHue2 > maxHue2) {
      float range = 360 - minHue2 + maxHue2;
      float rv = random(0, range);
      rhue2 = minHue2 + rv;
      if (rhue2 > 360) rhue2 -= 360;
    } else {
      rhue2 = random(minHue2, maxHue2);
    }

    colors1[k] = color(
    rhue1, 
    random(minSaturation1, maxSaturation1), 
    random(minBrightness1, maxBrightness1), 
    alpha);
    colors2[k] = color(
    rhue2, 
    random(minSaturation2, maxSaturation2), 
    random(minBrightness2, maxBrightness2), 
    alpha);
  }
}

void drawVectors() {
  noStroke();
  blendMode(blending);
  for (int k = 0; k < repetitions; k++) {
    fill(colors1[k], alpha);
    triangle(origin.x, origin.y, origin.x + vectors1[k].x, origin.y + vectors1[k].y, origin.x + vectors3[k].x, origin.y + vectors3[k].y);
    fill(colors2[k], alpha);
    triangle(origin.x, origin.y, origin.x + vectors2[k].x, origin.y + vectors2[k].y, origin.x + vectors3[k].x, origin.y + vectors3[k].y);
  }
  blendMode(BLEND);
}

