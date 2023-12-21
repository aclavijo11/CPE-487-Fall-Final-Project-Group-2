LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_top IS
    GENERIC (
        initial_x1 : INTEGER := 50;
        initial_y1 : INTEGER := 50;
        initial_x2 : INTEGER := 700;
        initial_y2 : INTEGER := 500;
        initial_x3 : INTEGER := 50;
        initial_y3 : INTEGER := 250
    );
    PORT (
        clk_in    : IN STD_LOGIC;
        vga_red   : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_green : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_blue  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        vga_hsync : OUT STD_LOGIC;
        vga_vsync : OUT STD_LOGIC
    );

END vga_top;

ARCHITECTURE Behavioral OF vga_top IS
    SIGNAL pxl_clk : STD_LOGIC;
    -- internal signals to connect modules
    SIGNAL S_red, S_green, S_blue : std_logic_vector(2 downto 0);
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL ball1_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_x1, 11);
    SIGNAL ball1_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_y1, 11);
    SIGNAL ball2_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_x2, 11);
    SIGNAL ball2_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_y2, 11);
    SIGNAL ball3_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_x3, 11);
    SIGNAL ball3_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(initial_y3, 11);
    SIGNAL collision1 : STD_LOGIC_VECTOR(10 DOWNTO 0):= "00000000000";
    SIGNAL collision2 : STD_LOGIC_VECTOR(10 DOWNTO 0):= "00000000000";
    SIGNAL collision3 : STD_LOGIC_VECTOR(10 DOWNTO 0):= "00000000000";
    CONSTANT size : INTEGER := 20;
    -- current ball motion - initialized to +4 pixels/frame

    
    COMPONENT ball IS
        GENERIC (
            initial_x: INTEGER;
            initial_y: INTEGER

        );
        PORT (
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            curr_x, curr_y : OUT std_logic_vector(10 DOWNTO 0);
            collision : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
            red : OUT STD_LOGIC;
            green : OUT STD_LOGIC;
            blue : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN std_logic_vector(2 downto 0);
            green_in  : IN std_logic_vector(2 downto 0);
            blue_in   : IN std_logic_vector(2 downto 0);
            red_out   : OUT STD_LOGIC;
            green_out : OUT STD_LOGIC;
            blue_out  : OUT STD_LOGIC;
            hsync     : OUT STD_LOGIC;
            vsync     : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
    END COMPONENT;

    component clk_wiz_0 is
        port (
            clk_in1  : in std_logic;
            clk_out1 : out std_logic
        );
    end component;

BEGIN
    -- vga_driver only drives MSB of red, green & blue
    -- so set other bits to zero

    vga_red(1 DOWNTO 0) <= "00";
    vga_green(1 DOWNTO 0) <= "00";
    vga_blue(0) <= '0';

    add_ball1 : ball
        GENERIC MAP (
            initial_x => initial_x1,
            initial_y => initial_y1
        )
        PORT MAP (
            v_sync    => S_vsync,
            pixel_row => S_pixel_row,
            pixel_col => S_pixel_col,
            curr_x => ball1_x,
            curr_y => ball1_y,
            collision => collision1,
            red       => S_red(0),
            green     => S_green(0),
            blue      => S_blue(0)
        );

    add_ball2 : ball
        GENERIC MAP (
            initial_x => initial_x2,
            initial_y => initial_y2
        )
        PORT MAP (
            v_sync    => S_vsync,
            pixel_row => S_pixel_row,
            pixel_col => S_pixel_col,
            curr_x => ball2_x,
            curr_y => ball2_y,
            collision => collision2,
            red       => S_red(1),
            green     => S_green(1),
            blue      => S_blue(1)
        );

    add_ball3 : ball
        GENERIC MAP (
            initial_x => initial_x3,
            initial_y => initial_y3
 
        )
        PORT MAP (
            v_sync    => S_vsync,
            pixel_row => S_pixel_row,
            pixel_col => S_pixel_col,
            curr_x => ball3_x,
            curr_y => ball3_y,
            collision => collision3,
            red       => S_red(2),
            green     => S_green(2),
            blue      => S_blue(2)
        );
        
    vga_driver : vga_sync
        PORT MAP (
            --instantiate vga_sync component
            pixel_clk => pxl_clk,
            red_in    => S_red,
            green_in  => S_green,
            blue_in   => S_blue,
            red_out   => vga_red(2),
            green_out => vga_green(2),
            blue_out  => vga_blue(1),
            pixel_row => S_pixel_row,   -- Use separate signals for the first ball
            pixel_col => S_pixel_col,    -- Use separate signals for the first ball
            hsync     => vga_hsync, 
            vsync     => S_vsync
        );
        

    vga_vsync <= S_vsync; --connect output vsync

    clk_wiz_0_inst : clk_wiz_0
    port map (
        clk_in1   => clk_in,
        clk_out1  => pxl_clk
    );

bounce_off : PROCESS IS
BEGIN
    --WAIT UNTIL rising_edge(S_vsync);
    -- allow for bounce off upon collision between ball 1 and ball 2
    IF (ball1_y - ball2_y <10) THEN -- if ball 1 pixel y is to the left of ball 2
        collision1 <= "11111111100"; -- ball 1 -4 pixels (goes left)
        collision2 <= "00000000100"; -- ball 2 +4 pixels (goes right)
    ELSIF (ball1_x - ball2_x <10)THEN -- if ball 1 pixel x is to the left of ball 2
        collision1 <= "11111111100"; -- ball 1-4 pixels (goes left)
        collision2 <= "00000000100"; -- ball 2 +4 pixels (goes right)
    ELSIF (ball1_x -ball2_x > 10) THEN -- if ball 1 pixel x is to the right of ball 2
        collision1 <= "00000000100"; -- ball 2 +4 pixels (goes right)
        collision2 <= "11111111100"; -- ball 2 -4 pixels (goes left)
    ELSIF (ball1_y - ball2_y >10) THEN -- if ball 1 pixel y is to the right of ball 2
        collision1 <= "00000000100"; -- ball 1 +4 pixels (goes right)
        collision2 <= "11111111100"; -- ball 2 -4 pixels (goes left)
    --if no collision detection
    ELSE
    collision1 <= "00000000000";
    collision2 <= "00000000000";
    END IF;
    
    END PROCESS;
END Behavioral;
   

