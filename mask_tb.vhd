library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use work.common_decs.all;

entity mask_tb is end mask_tb;

architecture behav of mask_tb is
  component data_process is
    port (clk       : in  std_logic;
          reset : in  std_logic;
          finished  : out std_logic;
          valid     : out std_logic;
          startclk  : out std_logic;
          test_data : out std_logic_vector(0 to 15));
  end component;
  -- The device under test is the data_process
  for dut          : data_process use entity work.data_process;
  signal clk       : std_logic;
  signal reset : std_logic;
  signal finished  : std_logic;
  signal valid     : std_logic;
  signal startclk  : std_logic;
  signal test_data : std_logic_vector(0 to 15);
begin
  --  Component instantiation.
  dut : data_process
    port map (clk       => clk,
              reset => reset,
              finished  => finished,
              valid     => valid,
              startclk  => startclk,
              test_data => test_data) ;
  process
    variable l : line;
  begin
    -- Initialize the clock and the start command
    clk       <= '0';
    reset <= '1';
    wait for 2 ns;
    clk       <= '0';
    reset <= '0';
    while not (finished = '1') loop
      wait for 2 ns;
      clk <= not clk;
      wait for 2 ns;
    end loop;
    --for i in 0 to 15 loop
    --  write (l, string'(integer'image(0)));
    --  writeline (output, l);
    --end loop;
    wait;
  end process;
end behav;
