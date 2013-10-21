//Developed by Rajarshi Roy
import java.awt.Robot; //java library that lets us take screenshots
import java.awt.AWTException;
import java.awt.event.InputEvent;
import java.awt.image.BufferedImage;
import java.awt.Rectangle;
import java.awt.Dimension;
import processing.serial.*; //library for serial communication


Serial port; //creates object "port" of serial class
Robot robby; //creates object "robby the robot" of robot class

void setup()
{
port = new Serial(this, Serial.list()[0],9600); //set baud rate (pulse rate)
size(250, 250); //window size (doesn't matter)
try //standard Robot class error check
{
robby = new Robot();
}
catch (AWTException e)
{
println("Robot class not supported by your system!");
exit();
}
}

void draw()
{
int pixel; //ARGB variable with 32 int bytes where
//sets of 8 bytes are: Alpha, Red, Green, Blue
float r=0;
float g=0;
float b=0;

//get screenshot into object "screenshot" of class BufferedImage
BufferedImage screenshot = robby.createScreenCapture(new Rectangle(new Dimension(1920,1080)));
//1920*1080 is the screen resolution (original resolution was 1368*928)

// Initialize counting variables.
int i=0;
int j=0;
//1920*1080
//Skip every alternate pixel making program 4 times faster
for(i =0;i<1920; i=i+2){
for(j=0; j<1080;j=j+2){
pixel = screenshot.getRGB(i,j); //the ARGB integer has the colors of pixel (i,j)
r = r+(int)(255&(pixel>>16)); //add up reds
g = g+(int)(255&(pixel>>8)); //add up greens
b = b+(int)(255&(pixel)); //add up blues
}
}
// Divide resolution by 2 to get these numbers (ex: 1920 / 2 = 960)
r=r/(960*540); //average red (remember that I skipped ever alternate pixel)
g=g/(960*540); //average green
b=b/(960*540); //average blue


port.write(0xff); //write marker (0xff) for synchronization
port.write((byte)(r)); //write red value
port.write((byte)(g)); //write green value
port.write((byte)(b)); //write blue value
delay(10); //delay for safety

background(r,g,b); //make window background average color
}
