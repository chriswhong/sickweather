// GeoTrails.pde
// (c) 2012 David Troy (@davetroy)
//
// Simple sketch to allow visualization of simple geo-based trails through time.
// Currently ingests a csv file of tweets in the format of:
// screen_name,timestamp,lat,lon
// and displays them as geo trails on a basemap (specified in this file)
// Trails are displayed with a persistence-of-vision effect and gradually fade out.
// The sketch is rendered at a target frame rate of 30fps and each frame loads
// a certain number of seconds worth of tweets to display (currently 287 seconds).
// The sketch will stop running when it runs out of tweets.

PImage mapImage;
PImage logo;
MercatorMap mercatorMap;
PVector lastLoc;
TweetBase db;
Tweet current;
int currentTime;
TrailSystem trailSystem;
PFont legendFont, legendFont2, legendFont3;

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

void setup() {
  size(1280, 720);
  //frameRate(1);
  smooth();

  mapImage = loadImage("london.png");
  mercatorMap = new MercatorMap(1280, 720, 
  52.025, 51.002, -1.65, 1.263);

  legendFont = createFont("HelveticaNeue-Bold", 24);
  legendFont2 = createFont("HelveticaNeue-Light", 18);
    legendFont3 = createFont("HelveticaNeue-Light", 10);
 //tint(100 , 100, 100);
  lastLoc = new PVector(0, 0);
  image(mapImage, 0, 0, width, height);

  db = new TweetBase();
  current = db.get(0);
  currentTime = current.timestamp;

  trailSystem = new TrailSystem();
  
  g = new Gradient();
  g.addColor(color(58,58,58));
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
  
    for(int i = 0; i < 1280; ++i)
    for(int j = 0; j < 720; ++j)
      heatmap[heatindex][i][j] = 0.0;





}
void draw() 
{
  
  
  // draw the base map
  
   tint(tintamount);
  image(mapImage, 0, 0, width, height);
  tint(255);
  //image(logo,40,375, 125,126);


  // grab tweets for this time interval
 currentTime += 21600;
 

text(currentTime, 30, 200);

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
   for(int i = 0; i < 1280; ++i){
    for(int j = 0; j < 720; ++j){
    
    if (heatmap[heatindex][i][j] < .25){
    
    }
    else {
      set(i,j, g.getGradient(heatmap[heatindex][i][j])) ;
    }
    }}
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
  

  // draw the legends
  fill(255, 255);
  //text(tweets.size(), 30, 25);
  textFont(legendFont);
  text("SickWeather Common Cold", 30, 40);
  textFont(legendFont2);
  //text("Active Bikes: " + trailSystem.size(), 600, 40);
    //text(currentTime,30,70);
  text(reportDate, 30, 70);
   textFont(legendFont3);
  //text("Vizualization by @chris_whong", 30, 525);
  
  

  

  fill(255, 128);
  




  


 //save frames to make a movie later (warning! slow, large disk usage)
  //saveFrame("output/frames####.tiff");


  }
  
  
  void update_heatmap()
{
  // Calculate the new heat value for each pixel
  for(int i = 0; i < 1280; ++i)
    for(int j = 0; j < 720; ++j)
      heatmap[heatindex ^ 1][i][j] = calc_pixel(i, j);
  
  // flip the index to the next heatmap
  heatindex ^= 1;
}

float calc_pixel(int i, int j)
{
  float total = 0.0;
  int count = 0;
  float decay_rate = .9;

  // This is where the magic happens...
  // Average the heat around the current pixel to determine the new value
  for(int ii = -1; ii < 2; ++ii)
  {
    for(int jj = -1; jj < 2; ++jj)
    {
      if(i + ii < 0 || i + ii >= width || j + jj < 0 || j + jj >= height)
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
  for(int ii = -(r / 2); ii < (r / 2); ++ii)
  {
    for(int jj = -(r / 2); jj < (r / 2); ++jj)
    {
      if(i + ii < 0 || i + ii >= width || j + jj < 0 || j + jj >= height)
        continue;
      
      // apply the heat
      heatmap[heatindex][i + ii][j + jj] += delta;
      heatmap[heatindex][i + ii][j + jj] = constrain(heatmap[heatindex][i + ii][j + jj], 0.0, 10);
    }
  }
}

