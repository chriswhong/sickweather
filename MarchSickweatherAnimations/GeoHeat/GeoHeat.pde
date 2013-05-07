// GeoHeat.pde
// by Chris Whong @chris_whong
//


PImage mapImage;
PImage logo;
MercatorMap mercatorMap;
PVector lastLoc;
TweetBase db;
Tweet current;
int currentTime;
TrailSystem trailSystem;
PFont legendFont, legendFont2, legendFont3, legendFont4, legendFont5;

int cx, cy;
float secondsRadius;
float minutesRadius;
float hoursRadius;
float clockDiameter;

float heatmap[][][] = new float[2][1280][720];
int heatindex = 0; 
Gradient g;

int radius = 75;
int tintamount = 50;
String monthstring;

void setup() {
  size(1280, 720);
  //frameRate(1);
  smooth();

  mapImage = loadImage("uk.png");
  logo = loadImage("logo.png");
  mercatorMap = new MercatorMap(1280, 720, 
  59.15, 49.849, -17.9, 10.64);
  legendFont = createFont("HelveticaNeue-Bold", 24);
  legendFont2 = createFont("HelveticaNeue-Light", 24);
  legendFont3 = createFont("HelveticaNeue-Light", 75);
  legendFont4 = createFont("HelveticaNeue-Light", 55);
  legendFont5 = createFont("HelveticaNeue-Light", 180);
  //tint(100 , 100, 100);
  lastLoc = new PVector(0, 0);
  image(mapImage, 0, 0, width, height);

  db = new TweetBase();
  current = db.get(0);
  currentTime = current.timestamp;

  trailSystem = new TrailSystem();

  g = new Gradient();
  g.addColor(color(58, 58, 58));
  //g.addColor(color(102, 0, 102));
  g.addColor(color(0, 144, 255));
  g.addColor(color(0, 255, 207));
  g.addColor(color(51, 204, 102));
  g.addColor(color(111, 255, 0));
  g.addColor(color(191, 255, 0));
  g.addColor(color(255, 240, 0));
  g.addColor(color(255, 153, 102));
  g.addColor(color(204, 51, 0));
  g.addColor(color(153, 0, 0));

  for (int i = 0; i < 1280; ++i)
    for (int j = 0; j < 720; ++j)
      heatmap[heatindex][i][j] = 0.0;
}
void draw() 
{


  // draw the base map

  tint(tintamount);
  image(mapImage, 0, 0, width, height);
  tint(255);




  // grab tweets for this time interval
  currentTime += 21600;


  //text(currentTime, 30, 200);

  ArrayList<Tweet> newTweets = db.tweetsThrough(currentTime);




  fill(255, 255);
  //text(tweets.size(), 30, 25);
  textFont(legendFont);
  //text("newTweets Size:", 30, 100);
  //text(newTweets.size(), 210,100);

  // stop if there are no more tweets to display

  // add new tweets and draw the trails



  trailSystem.addTweets(newTweets);

  trailSystem.draw();



  update_heatmap();
  for (int i = 0; i < 1280; ++i) {
    for (int j = 0; j < 720; ++j) {

      if (heatmap[heatindex][i][j] < .25) {
      }
      else {
        set(i, j, g.getGradient(heatmap[heatindex][i][j])) ;
      }
    }
  }
  // generate formatted date
  int offsetTime = currentTime + 14400;
  Date time = new java.util.Date((long)offsetTime*1000);
  DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy HH:mm");
  String reportDate = df.format(time);
  DateFormat minsFormat = new SimpleDateFormat("m");
  String mins = minsFormat.format(time);
  int minsint = Integer.parseInt(mins);
  DateFormat hoursFormat = new SimpleDateFormat("h");
  String hours = hoursFormat.format(time);
  int hoursint = Integer.parseInt(hours);
  DateFormat apFormat = new SimpleDateFormat("a");
  String ap = apFormat.format(time);

  DateFormat monthFormat = new SimpleDateFormat("M");
  String mmonth = monthFormat.format(time);
  DateFormat yearFormat = new SimpleDateFormat("y");
  String yyear = yearFormat.format(time);
  DateFormat dayFormat = new SimpleDateFormat("d");
  String dday = dayFormat.format(time);  

  // draw the legends
  image(logo, 30, 30, 269, 153);
  fill(255, 255);
  //text(tweets.size(), 30, 25);
  textFont(legendFont);
  //text("SickWeather Common Cold", 30, 40);
  textFont(legendFont2);
  //text("Active Bikes: " + trailSystem.size(), 600, 40);
  //text(currentTime,30,70);
  //text(reportDate, 30, 70);
  textAlign(CENTER);
  text("Man Flu Symptoms", 160, 200);

  textFont(legendFont3);
  //text("Vizualization by @chris_whong", 30, 525);

  text("20" + yyear, 160, 650);

  textFont(legendFont5);
  text(dday, 160, 565);


  switch(Integer.parseInt(mmonth)) {
  case 1:
    monthstring="January";
    break;
  case 2:
    monthstring="February";
    break;
  case 3:
    monthstring="March";
    break;
  case 4:
    monthstring="April";
    break;
  case 5:
    monthstring="May";
    break;
  case 6:
    monthstring="June";
    break;
  case 7:
    monthstring="July";
    break;
  case 8:
    monthstring="August";
    break;
  case 9:
    monthstring="September";
    break;
  case 10:
    monthstring="October";
    break;
  case 11:
    monthstring="November";
    break;
  case 12:
    monthstring="December";
    break;
  }

  textFont(legendFont4); 
  text(monthstring, 160, 400);

  textFont(legendFont5); 




  fill(255, 128);








  //save frames to make a movie later (warning! slow, large disk usage)
  saveFrame("manflu/frames####.tiff");
}


void update_heatmap()
{
  // Calculate the new heat value for each pixel
  for (int i = 0; i < 1280; ++i)
    for (int j = 0; j < 720; ++j)
      heatmap[heatindex ^ 1][i][j] = calc_pixel(i, j);

  // flip the index to the next heatmap
  heatindex ^= 1;
}

float calc_pixel(int i, int j)
{
  float total = 0.0;
  int count = 0;
  float decay_rate = .95;

  // This is where the magic happens...
  // Average the heat around the current pixel to determine the new value
  for (int ii = -1; ii < 2; ++ii)
  {
    for (int jj = -1; jj < 2; ++jj)
    {
      if (i + ii < 0 || i + ii >= width || j + jj < 0 || j + jj >= height)
        continue;

      ++count;
      total += heatmap[heatindex][i + ii][j + jj];
    }
  }

  // return the average
  return ((total / count)*decay_rate);
}

void apply_heat(int i, int j, int r, float delta)
{
  // apply delta heat (or remove it) at location 
  // (i, j) with radius r
  for (int ii = -(r / 2); ii < (r / 2); ++ii)
  {
    for (int jj = -(r / 2); jj < (r / 2); ++jj)
    {
      if (i + ii < 0 || i + ii >= width || j + jj < 0 || j + jj >= height)
        continue;

      // apply the heat
      heatmap[heatindex][i + ii][j + jj] += delta;
      heatmap[heatindex][i + ii][j + jj] = constrain(heatmap[heatindex][i + ii][j + jj], 0.0, 10);
    }
  }
}

