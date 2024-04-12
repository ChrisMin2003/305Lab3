library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity minute_counter is
    port (
        clk    : in std_logic;
        start  : in std_logic;
        data_in: in std_logic_vector (9 downto 0);
        count_minute : out std_logic_vector(6 downto 0);
        count_second : out std_logic_vector(13 downto 0);
        time_out     : out std_logic_vector(9 downto 0)
    );
end entity minute_counter;

architecture rtl of minute_counter is
    component BCD_counter is
        port (
            clk       : in std_logic;
            enable    : in std_logic;
            init      : in std_logic;
            direction : in std_logic;
            Q_out     : out std_logic_vector(3 downto 0)
        );
    end component BCD_counter;
    
    component BCD_to_SevenSeg is 
      port (
          BCD_digit : in std_logic_vector(3 downto 0);
           SevenSeg_out : out std_logic_vector(6 downto 0)
    );
    end component BCD_to_SevenSeg;
    
    signal enable : std_logic;
    signal minute_enable, tens_enable, ones_enable : std_logic;
    signal minute_init, tens_init, ones_init     : std_logic;
    signal minute_dir, tens_dir, ones_dir       : std_logic;
    signal minute_count, tens_count, ones_count   : std_logic_vector(3 downto 0);
    signal BCD_minute, BCD_tens, BCD_ones : std_logic_vector(3 downto 0);
    signal Seg_minute, Seg_tens, Seg_ones : std_logic_vector(6 downto 0);
    signal time_out_temp : std_logic_vector(9 downto 0);

begin
    tens_counter : BCD_counter
    port map (
        clk       => clk,
        enable    => tens_enable,
        init      => tens_init,
        direction => tens_dir,
        Q_out     => tens_count
    );

    ones_counter : BCD_counter
    port map (
        clk       => clk,
        enable    => ones_enable,
        init      => ones_init,
        direction => ones_dir,
        Q_out     => ones_count
    );
    
    minute_counter : BCD_counter
    port map (
        clk       => clk,
        enable    => minute_enable,
        init      => minute_init,
        direction => minute_dir,
        Q_out     => minute_count
    );
    
    converter_minute : BCD_to_SevenSeg
    port map (
        BCD_digit => minute_count,
        SevenSeg_out => Seg_minute
    );

    converter_tens : BCD_to_SevenSeg
    port map (
        BCD_digit => tens_count,
        SevenSeg_out => Seg_tens
    );

    converter_ones : BCD_to_SevenSeg
    port map (
        BCD_digit => ones_count,
        SevenSeg_out => Seg_ones
    );

    process (clk)
    begin
        if rising_edge(clk) then
            if time_out_temp = data_in then
              enable <= '0';
              minute_enable <= '0';
              tens_enable <= '0';
              ones_enable <= '0';
            elsif start = '1' then
                enable <= '1';
                minute_init <= '1';
                tens_init   <= '1';
                ones_init   <= '1';
                minute_dir  <= '0';
                tens_dir    <= '0';
                ones_dir    <= '0';
                minute_enable <= '1';
                tens_enable <= '1';
                ones_enable <= '1';
            elsif enable = '1' then
                minute_dir  <= '0';
                tens_dir    <= '0';
                ones_dir    <= '0';
                  if ones_count = "1000" then
                   if tens_count = "0101" then
                      if minute_count = "0011" then
                        minute_init <= '1';
                        tens_init   <= '1';
                        ones_init   <= '1';
                        minute_enable <= '1';
                        tens_enable <= '1';
                        ones_enable <= '1';
                      else 
                        minute_init <= '0';
                        tens_init   <= '1';
                        ones_init   <= '1';
                        minute_enable <= '1';
                        tens_enable <= '1';
                        ones_enable <= '1';
                      end if;
                    else 
                      minute_init <= '0';
                      tens_init   <= '0';
                      ones_init   <= '1';
                      minute_enable <= '0';
                     tens_enable <= '1';
                     ones_enable <= '1';
                    end if;
                  else
                    minute_init <= '0';
                   tens_init   <= '0';
                   ones_init   <= '0';
                   minute_enable <= '0';
                   tens_enable <= '0';
                   ones_enable <= '1';
                  end if;
                end if;
              end if;
    end process;
            time_out <= minute_count(1 downto 0) & tens_count & ones_count;
            time_out_temp <= minute_count(1 downto 0) & tens_count & ones_count;
            count_minute <= Seg_minute;
            count_second <= Seg_tens & Seg_ones;
            
end architecture rtl;


