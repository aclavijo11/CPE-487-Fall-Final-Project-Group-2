# CPE-487-Fall-Final-Project-Group-2
This repository showcases the Final Project for group 2: An imitation of the Windows lock screen's iconic bubble animation.

In this project, the team created an imitation of the Window lock screen's [bubble animation](https://www.youtube.com/watch?v=Vo19qTt9rlE).  Due to time and skill limitations, we focused on 2 key components:

* Displaying Multiple balls
* Ball Collision with one another

The team built off of [Lab 3: Bouncing Ball](https://github.com/byett/dsd/tree/CPE487-Fall2023/Nexys-A7/Lab%203)

To get multiple balls displayed on the screen: 
 The following files were modified: 
 1. vga_top.vhd
 2. vga_sync.vhd
 3. ball.vhd

To ensure the balls existed in different locations, the following modifications were implemented: 

**Ball.vhd**
1. Added Generic variables in ball.vhd that are called in vga_top

**vga_top.vhd**
1. Initial locations are set via Generic Mapping
2.Signal vectors are added for each ball, 
3. In each instantiation of adding a ball, the initial locations are set followed by the RGB values
4. Expanded the bit size for vga_sync.vhd variables to 3 bits

**vga_sync.vhd**
1. Expanded the bit size for vga_sync.vhd variables to 3 bits to account for 3 balls.
2. For the RGB out variables, we included each specific ball color value (ex. red_in(0) AND red_in(1) AND red_in(2)

Some problems along the way
*Multiple Driver Error for red/green/blue_out. To fix this issue, we expanded the bit size for red/green/blue_in instead of calling red_in for each ball instantiation.

[Video Link for the above work
](# CPE-487-Fall-Final-Project-Group-2
This repository showcases the Final Project for group 2. 
An imitation of the Windows lock screen's iconic bubble animation.

[Video Link for the work above:](https://youtu.be/Kbr0ko_FnX0)

We then modified the shape and color of the ball. These modifications were similar to what was achieved in lab 3.

[Update Video](https://youtu.be/gdp5zqRE4GQ)

## Approaches for Achieving Ball Collision
1. Our first approach consisted of editing the ball.vhd module to include the positions of all the balls, as passed from vga_top.vhd, and make a series of conditional statements to change each ball's direction of motion once one of its pixels had the same position as another ball's pixel. A sample code from this approach can be seen below.

![image](https://github.com/aclavijo11/CPE-487-Fall-Final-Project-Group-2/assets/98104592/a409feec-0e45-473a-b597-b8939bc7b137)

2. Our second approach was to make the collision detection happen in vga_top.vhd and then update the variables for ball_x_motion and ball_y_motion within vga_top.vhd and pass them to ball.vhd. However, this approach yielded strange behavior where only one ball appeared bouncing at the bottom of the screen, as seen in this [video](https://youtube.com/shorts/SKpYicXmU0A). The code below shows the attempted process coded in vga_top.vhd.

![image](https://github.com/aclavijo11/CPE-487-Fall-Final-Project-Group-2/assets/98104592/e68ca3fc-f801-450e-9573-160945dc62d8)

3. Similar to our second approach, this approach attempted to implement the ball collision algorithm by creating a vector signal that would track if a ball's pixel location was within 10 pixels of another ball's pixel location, then pass that signal to ball.vhd where the process of making the balls change direction would happen. See below a snippet of the codes found in vga_top.vhd and ball.vhd for this approach.

**vga_top.vhd**
![image](https://github.com/aclavijo11/CPE-487-Fall-Final-Project-Group-2/assets/98104592/ba65be1b-808b-4ed5-9416-499a9a45dcb1)

**ball.vhd**
![image](https://github.com/aclavijo11/CPE-487-Fall-Final-Project-Group-2/assets/98104592/874d25fa-1de0-45e8-bd02-aff5cbba25e3)

## Steps to Test Code Using Vivado and Nexys A7 Board

1. Create a new RTL project Final Project in Vivado Quick Start
  * Create five new source files of file type VHDL called clk_wiz_0, clk_wiz_0_clk_wiz, vga_sync, ball, and vga_top
  * Create a new constraint file of file type XDC called vga_top
  * Choose Nexys A7-100T board for the project
  * Click 'Finish'
  * Click design sources and copy the VHDL code from clk_wiz_0.vhd, clk_wiz_0_clk_wiz.vhd, vga_sync.vhd, ball.vhd, and vga_top.vhd

2. Click constraints and copy the code from vga_top.xdc found in [CPE-487-Fall-Final-Project-Group-2](https://github.com/aclavijo11/CPE-487-Fall-Final-Project-Group-2.git)

3. Run synthesis

4. Run implementation

5. Generate bitstream, open hardware manager, and program device

  * Click 'Generate Bitstream
  * Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'
  * Click 'Program Device' then xc7a100t_0 to download vga_top.bit to the Nexys A7 board
 
## Project Process Summary:

* All tasks and goals were vided amongst the team, i.e. no group member had a specific task.
* The team met during 3 lab sections and 3 other meetings outside of scheduled lab time.
* Accomplishments
  * Successfully adding 2 more balls that bounced off the "walls" of the screen.
* Goals not met
  * Implementing the ball collision algorithm successfully.
 
*Overall, we feel confident that we tried our best, and given more time we might have been able to successfully implement our desired goals.

* Please note that the different files found in our repository may not include all approaches discussed here, as we only uploaded the final "working" product.
