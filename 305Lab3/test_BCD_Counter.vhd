library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_BCD_counter is
end entity test_BCD_counter;

architecture my_test of test_BCD_counter is 
    signal t_clk, t_enable, t_init, t_direction : std_logic;
    signal t_Q : std_logic_vector(3 downto 0);

    component BCD_counter is 
        port (        clk      : in std_logic;
        enable   : in std_logic;
        init     : in std_logic;
        direction: in std_logic;
        Q_out    : out std_logic_vector(3 downto 0));
    end component BCD_counter;
begin
     DUT: BCD_counter port map (t_clk, t_enable, t_init, t_direction, t_Q);
 
     init: process
     begin 
        t_init <= '1', '0' after 20 ns, '1' after 450 ns, '0' after 550 ns;
        t_enable <= '1', '0' after 800 ns;
        t_direction <= '0', '1' after 300 ns;
         wait;
     end process init;

     clk_gen: process
     begin
         wait for 10 ns;
         t_clk <= '1'; 
         wait for 10 ns;
         t_clk <= '0';
     end process clk_gen;  
end architecture my_test;