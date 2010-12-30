-- mask.vhd
-- 800 bit version
-- start with events and mask in memory; 
-- process events with mask and generate image
--
-- inputs: cmd_start is triggered by 'cmd_start' signal going high
--
-- outputs: 'finished' goes high to indicate when process is complete
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.common_decs.all;

entity data_process is
  port (clk       : in  std_logic;
        cmd_start : in  std_logic;
        finished  : out std_logic;
        valid     : out std_logic;
        startclk  : out std_logic;
        test_data : out std_logic_vector(0 to 15)); 
end data_process;


architecture syn of data_process is
  signal state_reg : integer range 0 to 5 := 0;

-- FOLLOWING IS 500 ELEMENT MASK
--   signal ROM : bit_vector (0 to 499) := 
--"00000100000000000011"&
--"00100011000111000110"&
--"00000000000110000000"&
--"00000100100000110010"&
--"00010010000000000100"&
--"10000000000001100000"&
--"00010000100000100001"&
--"00000001000000000000"&
--"01100001000110011000"&
--"00000000100001001000"&
--"01000000000001001100"&
--"00011100111000011000"&
--"00010000110000001000"&
--"00011100000100000000"&
--"01000000000001000010"&
--"00000000001000010000"&
--"01000000100000001110"&
--"00000001110001000010"&
--"00000000110000100000"&
--"10000100010000000010"&
--"00001000000001001000"&
--"01000001001000001000"&
--"10000000110010000000"&
--"10000100000011001000"&
--"01000100000000000011";

-- FOLLOWING ARE 250 AND 800 BIT MASK VERSIONS
  signal ROM : bit_vector (0 to 799) :=
    "11001100000001000100000100010001000000000100000100"&
    "11000000001000001000100000100000010000000100010010"&
    "00011000100000000000000001001000001000100100000011"&
    "00010000100000000001100001000000001100100100000000"&
    "00001001001000000100000000001000110000001000000110"&
    "00001000001000000100010000000010000001100001100100"&
    "10011000001000000001000001000100001100000000001001"&
    "00100011000001001000000000000001100000000000000000"&
    "01001100001000001001000100000000001000001000001001"&
    "00100001100000001001000000000010011000011000011000"&
    "01000001000000000000011001001100010001000000100001"&
    "00100000000000010011000010010001000000000100110000"&
    "00100110000000000100011000000000000000001000000000"&
    "00100000010000001001100100000100100000010000011000"&
    "01000000010000000001001000000100001100000100100110"&
    "00111000100000001001000000000100010001000000010010";
-- END OF 800 BIT MASK

-- FOLLOWING IS FOR 2100 BIT MASK
--"00100110000001000001001000000100001000000100010000"&
--"00001000000000100100010000110000100000001001000001"&
--"00000000100100000010000100100000100100000000100000"&
--"10000000001100000000001000001100000110000010000010";
--"01000010000000010000110001100000000000010010011000"&
--"00000001001001001000100000010011100010000001110010"&
--"00001000000010000000100000000000000001000010000001"&
--"00100000100100000010010010000100010000100000010000"&
--"00000000001001100110011000000100000000010000001000"&
--"10000000000000000000100010000001000100010001000000"&
--"10011100000111111000010000000010000000001000000100"&
--"11100000000000001000000000001001000000000000000100"&
--"00001000100000100001000110010001000100000100001001"&
--"10000100100001000010010000001000010001000010000110"&
--"01000000000010001000100001001000000000001000100010"&
--"00000000000000000100011001000110000100001000000010"&
--"00000100000000000011001000110001110001100000000000"&
--"01100000000000010010000011001000010010000000000100"&
--"10000000000001100000000100001000001000010000000100"&
--"00000000000110000100011001100000000000100001001000"&
--"01000000000001001100000111001110000110000001000011"&
--"00000010000001110000010000000001000000000001000010"&
--"00000000001000010000010000001000000011100000000111"&
--"00010000100000000011000010000010000100010000000010"&
--"00001000000001001000010000010010000010001000000011"&
--"00100000001000010000001100100001000100000000000011";
-- END OF 2100 BIT MASK

  signal shiftreg : bit_vector (0 to 799) := (others => '0');

  type image_array is array (0 to 499) of integer range -2047 to +2047;
  --type image_array is array (0 to 499) of integer range -32767 to +32768;  -- expand for 10X loop
  signal image : image_array := (others => 0);

  -- type events_array is array (0 to 394) of integer range 0 to 4095;


  -- These should not be constants; they are all calculated
  constant MINVAL   : integer := 692;
  constant MAXVAL   : integer := 942;
  constant MAXLOOPS : integer := events_array'length;

  signal nshifts : integer range 0 to 4095;
  signal done    : std_logic := '0';
  signal nloops  : integer range 0 to 750;
  signal nval    : integer range 0 to 500;
  
begin
  
  process (clk)

  begin
    finished <= '0';
    if (clk'event and clk = '1') then
      case state_reg is
--  hold for cmd_start or after process is done          
        when 0 =>
          valid    <= '0';
          startclk <= '0';
          if (cmd_start = '0') then
            finished <= '0';
            done     <= '0';
          end if;
          if (cmd_start = '1' and done = '0') then
            state_reg <= 1;
            nloops    <= 0;
            startclk  <= '1';
          end if;
--  load shift register and determine number of shifts
        when 1 =>
          valid    <= '0';
          startclk <= '1';
          if (nloops = 0) then
            image <= (others => 0);
          end if;
          if (done = '0') then
            shiftreg  <= ROM;
            nshifts   <= events(nloops) - MINVAL;
            nloops    <= nloops + 1;
            state_reg <= 2;
          end if;
--   shift the SR 
        when 2 =>
          valid     <= '0';
          startclk  <= '1';
          shiftreg  <= shiftreg sll nshifts;
          state_reg <= 3;
--  loop through each bit of SR and change image according to SR bit       
        when 3 =>
          valid    <= '0';
          startclk <= '1';
          for i in 0 to 249 loop
            if shiftreg(i) = '1' then
              image(i) <= image(i) + 4;
            else
              image(i) <= image(i) - 1;
            end if;
          end loop;
          state_reg <= 4;
--  determine whether all loops have been done
        when 4 =>
          valid    <= '0';
          startclk <= '1';
          if (nloops > (MAXLOOPS-1)) then
            state_reg <= 5;
          else
            state_reg <= 1;
          end if;

--  output 250 image elements then its done   
        when 5 =>
          if (nloops > (MAXLOOPS + 249)) then
            nloops    <= 0;
            finished  <= '1';
            done      <= '1';
            state_reg <= 0;
            valid     <= '0';
            startclk  <= '0';
          else
            test_data <= std_logic_vector(to_signed(image(nloops-MAXLOOPS), 16));
            valid     <= '1';
            startclk  <= '1';
            state_reg <= 5;
            nloops    <= nloops + 1;
          end if;
      end case;
    end if;
  end process;
end syn;

