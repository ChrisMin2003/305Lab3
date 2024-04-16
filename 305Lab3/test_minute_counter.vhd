library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity minute_counter_tb is
end minute_counter_tb;

architecture tb of minute_counter_tb is
    component minute_counter is
        port (
        CLOCK_50    : in std_logic;
        KEY0  : in std_logic;
        SW: in std_logic_vector (9 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0);
		  HEX0 : out std_logic_vector(6 downto 0);
        LEDR0     : out std_logic
        );
    end component;

    signal clk          : std_logic := '0';
    signal start        : std_logic := '0';
    signal data_in      : std_logic_vector(9 downto 0) := (others => '0');
    signal count_minute, count_second_tens, count_second_ones : std_logic_vector(6 downto 0);
    signal time_out     : std_logic := '0';

    constant clk_period : time := 20 ns;

begin
    -- Instantiate the minute_counter entity
    uut : minute_counter
        port map (
            CLOCK_50          => clk,
            KEY0        => start,
            SW      => data_in,
            HEX2 => count_minute,
            HEX1 => count_second_tens,
		HEX0 => count_second_ones,
            LEDR0     => time_out
        );

    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_process : process
    begin
        -- Initialize start and data_in
        start <= '1';
        data_in <= "1000000000";

        -- Wait for a few clock cycles
        wait for 100 ns;

        -- Deassert start to begin counting
        start <= '0';

        wait;
    end process;
end architecture tb;
