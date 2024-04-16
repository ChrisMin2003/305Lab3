library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity minute_counter_tb is
end minute_counter_tb;

architecture tb of minute_counter_tb is
    component minute_counter is
        port (
            clk          : in std_logic;
            start        : in std_logic;
            data_in      : in std_logic_vector (9 downto 0);
            count_minute : out std_logic_vector(6 downto 0);
            count_second : out std_logic_vector(13 downto 0);
            time_out     : out std_logic_vector(9 downto 0)
        );
    end component;

    signal clk          : std_logic := '0';
    signal start        : std_logic := '0';
    signal data_in      : std_logic_vector(9 downto 0) := (others => '0');
    signal count_minute : std_logic_vector(6 downto 0);
    signal count_second : std_logic_vector(13 downto 0);
    signal time_out     : std_logic_vector(9 downto 0);

    constant clk_period : time := 10 ns; -- Clock period of 10 ns (100 MHz)

begin
    -- Instantiate the minute_counter entity
    uut : minute_counter
        port map (
            clk          => clk,
            start        => start,
            data_in      => data_in,
            count_minute => count_minute,
            count_second => count_second,
            time_out     => time_out
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

        -- Wait for some time to observe the output
        wait;

        -- You can add more stimuli here to test different scenarios

        -- End simulation
        wait;
    end process;
end architecture tb;
