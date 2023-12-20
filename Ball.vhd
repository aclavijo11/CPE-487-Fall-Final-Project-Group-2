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
     ball_x2, ball_y2 : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
     ball_x3, ball_y3 : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
     curr_x, curr_y : OUT std_logic_vector(10 DOWNTO 0);

		blue      : OUT STD_LOGIC
	);
END ball;

ARCHITECTURE Behavioral OF ball IS
	CONSTANT size  : INTEGER := 20;
	
	--BALL1
	SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is over current pixel position
	-- current ball position - initialized to center of screen
	SIGNAL ball_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_x, 11);
	SIGNAL ball_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_y, 11);
	
	-- current ball motion - initialized to +4 pixels/frame
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
	SIGNAL ball_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";

BEGIN

	red <= NOT ball_on; -- color setup for red ball on white background
	green <= NOT ball_on;
	blue  <= '1';


-- process to draw ball current pixel address is covered by ball position
bdraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
BEGIN
    -- IF (pixel_col >= ball_x - size) AND
    --     (pixel_col <= ball_x + size) AND
    --     (pixel_row >= ball_y - size) AND
    --     (pixel_row <= ball_y + size) THEN
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

    -- BALL1 COLLISION
    -- IF ((ball_x - ball_x2 <= "00001010") OR
    --     (ball_x - ball_x2 >= "11110110")) AND
    --    ((ball_y - ball_y2 <= "00001010") OR
    --     (ball_y - ball_y2 >= "11110110")) THEN
    --    ball_x_motion <= "11111111100";
    --    ball_y_motion <= "11111111100";
    -- END IF;

    IF ((ball_x - ball_x3 <= "00000001010") AND
        (ball_x - ball_x3 >= "11111110110")) AND
       ((ball_y - ball_y3 <= "00000001010") AND
        (ball_y - ball_y3 >= "11111110110")) THEN
        ball_x_motion <= (NOT ball_x_motion) + "1";
        ball_y_motion <= (NOT ball_y_motion) + "1";
    END IF;

    ball_y <= ball_y + ball_y_motion; -- compute the next ball position
    ball_x <= ball_x + ball_x_motion;

    curr_x <= ball_x;
    curr_y <= ball_y;
END PROCESS;

END Behavioral;
