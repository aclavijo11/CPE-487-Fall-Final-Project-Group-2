# CPE-487-Fall-Final-Project-Group-2
This repository showcases the Final Project for group 2. 
An imitation of the Windows lock screen's iconic bubble animation.

In this project, the team created an imitation of the Window lock screen's [bubble animation](https://www.youtube.com/watch?v=Vo19qTt9rlE).  Due to time and skill limitation, we focused on 2 key components:

* Multiple balls
* Ball Collision with each other

The team built off of [Lab 3: Bouncing Ball](https://github.com/byett/dsd/tree/CPE487-Fall2023/Nexys-A7/Lab%203)

To get multiple balls displayed on the screen: 
 The following files were modified: 
 1. vga_top.vhd
 2. vga_sync.vhd
 3. ball.vhd

To ensure the balls existed in different locations 
**Ball.vhd**
1. Added Generic variables in ball.vhd that are called in vga_top

**vga_top.vhd**
1. Initial locations are set via Generic Mapping
2.Signal vectors are added for each ball, 
3. In each instantiation of adding a ball, the initial locations are set followeded by the rgb values
4. Expanded the bit size for vga_sync.vhd variables to 3 bits

**vga_sync.vhd**
1. Expanded the bit size for vga_sync.vhd variables to 3 bits to account for 3 balls.
2. For the rgb out variables, we included each specific ball color values (ex. red_in(0) AND red_in(1) AND red_in(2)

Some problems along the way
*Multiple Driver Error for red/green/blue_out. To fix this issue, we expanded the bit size for red/green/blue_in instead of calling red_in for each ball instantiation.

[Video Link for the above work
](# CPE-487-Fall-Final-Project-Group-2
This repository showcases the Final Project for group 2. 
An imitation of the Windows lock screen's iconic bubble animation.

[Video Link for the work above:](https://youtu.be/Kbr0ko_FnX0)
