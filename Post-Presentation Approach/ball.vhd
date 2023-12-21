LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ball IS
    GENERIC (
        initial_x: INTEGER;
        initial_y: INTEGER
    );
    
	PORT (
		v_sync    : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		red       : OUT STD_LOGIC;
		green     : OUT STD_LOGIC;
        curr_x, curr_y : OUT std_logic_vector(10 DOWNTO 0);
        collisionx : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
        collisiony : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
     
		blue      : OUT STD_LOGIC
	);
END ball;

ARCHITECTURE Behavioral OF ball IS
	CONSTANT size  : INTEGER := 20;
	SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is over current pixel position
	-- current ball position - initialized to center of screen
	SIGNAL ball_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_x, 11);
	SIGNAL ball_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_y, 11);
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
	SIGNAL ball_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";

BEGIN

	red <= NOT ball_on; -- color setup for red ball on white background
	green <= NOT ball_on;
	blue  <= '1';

-- process to draw ball current pixel address is covered by ball position
bdraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
BEGIN
    IF (((conv_integer(pixel_col) - conv_integer(ball_x)) *
         (conv_integer(pixel_col) - conv_integer(ball_x)) +
         (conv_integer(pixel_row) - conv_integer(ball_y)) *
         (conv_integer(pixel_row) - conv_integer(ball_y))) <= size * size) THEN
        ball_on <= '1';
    ELSE
        ball_on <= '0';
    END IF;
END PROCESS;

-- process to move ball once every frame (i.e. once every vsync pulse)
mball : PROCESS IS
BEGIN
    WAIT UNTIL rising_edge(v_sync);
    -- allow for bounce off top or bottom of the screen
    IF ball_y + size >= 600 THEN
        ball_y_motion <= "11111111100"; -- -4 pixels
    ELSIF ball_x + size >= 800 THEN
        ball_x_motion <= "11111111100";
    ELSIF ball_x <= size THEN
        ball_x_motion <= "00000000100";
    ELSIF ball_y <= size THEN
        ball_y_motion <= "00000000100"; -- +4 pixels
    END IF;
    
    IF (collisionx = "00000000100" OR collisionx = "11111111100") THEN
    ball_x <= ball_x + collisionx;
    
    ELSIF (collisiony = "00000000100" OR collisiony = "11111111100") THEN
    ball_y <= ball_y + collisiony; -- compute the next ball position
    
    ELSE 
    ball_y <= ball_y + ball_y_motion; -- compute the next ball position
    ball_x <= ball_x + ball_x_motion;
    END IF;
    
    curr_x <= ball_x;
    curr_y <= ball_y;
END PROCESS;

END Behavioral;