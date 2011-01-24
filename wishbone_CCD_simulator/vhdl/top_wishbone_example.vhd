---------------------------------------------------------------------------
-- Company     : Automaticaly generated by POD
-- Author(s)   : 
-- 
-- Creation Date : 2009-03-03
-- File          : Top_wishbone_example.vhd
--
-- Abstract : 
-- insert a description here
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity top_wishbone_example is

    port
    (
        imx_data : inout std_logic_vector(15 downto 0);
        imx_address : in std_logic_vector(11 downto 0);
        ext_clk : in std_logic;
        imx_cs_n : in std_logic;
        imx_eb3_n : in std_logic;
        imx_oe_n : in std_logic;
        gls_irq : out std_logic;
        led_o : out std_logic;
        button_i : in std_logic
    );
end entity top_wishbone_example;

architecture top_wishbone_example_1 of top_wishbone_example is
    -------------------------
    -- declare components  --
    -------------------------


    component rstgen_syscon
        port (
            -- candr
            gls_clk  : out std_logic;
            gls_reset  : out std_logic;
            -- clk_ext
            ext_clk  : in std_logic
        );
    end component;

    component led
        generic(
            id : natural := 2;
            wb_size : natural := 16
        );
        port (
            -- int_led
            led_o  : out std_logic;
            -- candr
            gls_reset  : in std_logic;
            gls_clk  : in std_logic;
            -- swb16
            wbs_add  : in std_logic;
            wbs_writedata  : in std_logic_vector(15 downto 0);
            wbs_readdata  : out std_logic_vector(15 downto 0);
            wbs_strobe  : in std_logic;
            wbs_cycle  : in std_logic;
            wbs_write  : in std_logic;
            wbs_ack  : out std_logic
        );
    end component;

    component button
        generic(
            id : natural := 3
        );
        port (
            -- int_button
            button_i  : in std_logic;
            irq  : out std_logic;
            -- candr
            gls_reset  : in std_logic;
            gls_clk  : in std_logic;
            -- swb16
            wbs_add  : in std_logic;
            wbs_readdata  : out std_logic_vector(15 downto 0);
            wbs_strobe  : in std_logic;
            wbs_write  : in std_logic;
            wbs_ack  : out std_logic;
            wbs_cycle  : in std_logic
        );
    end component;

    component wishbone_wrapper
        port (
            -- eim
            imx_address  : in std_logic_vector(11 downto 0);
            imx_data   : inout std_logic_vector(15 downto 0);
            imx_cs_n   : in std_logic;
            imx_oe_n   : in std_logic;
            imx_eb3_n  : in std_logic;
            -- candr
            gls_reset : in std_logic;
            gls_clk   : in std_logic;
            -- mwb16
            wbm_address  : out std_logic_vector(12 downto 0);
            wbm_readdata : in std_logic_vector(15 downto 0);
            wbm_writedata: out std_logic_vector(15 downto 0);
            wbm_strobe : out std_logic;
            wbm_write  : out std_logic;
            wbm_ack    : in std_logic;
            wbm_cycle  : out std_logic
        );
    end component;

    component irq_mngr
        generic(
            id : natural := 1;
            irq_level : std_logic := '1';
            irq_count : integer := 1
        );
        port (
            -- candr
            gls_clk  : in std_logic;
            gls_reset  : in std_logic;
            -- swb16
            wbs_s1_address  : in std_logic_vector(1 downto 0);
            wbs_s1_readdata  : out std_logic_vector(15 downto 0);
            wbs_s1_writedata  : in std_logic_vector(15 downto 0);
            wbs_s1_ack  : out std_logic;
            wbs_s1_strobe  : in std_logic;
            wbs_s1_cycle  : in std_logic;
            wbs_s1_write  : in std_logic;
            -- irq
            irqport  : in std_logic_vector(0 downto 0);
            -- ext_irq
            gls_irq  : out std_logic
        );
    end component;

    component intercon
        port (
            -- irq_mngr00_swb16
            irq_mngr00_wbs_s1_address  : out std_logic_vector(1 downto 0);
            irq_mngr00_wbs_s1_readdata  : in std_logic_vector(15 downto 0);
            irq_mngr00_wbs_s1_writedata  : out std_logic_vector(15 downto 0);
            irq_mngr00_wbs_s1_ack  : in std_logic;
            irq_mngr00_wbs_s1_strobe  : out std_logic;
            irq_mngr00_wbs_s1_cycle  : out std_logic;
            irq_mngr00_wbs_s1_write  : out std_logic;
            -- irq_mngr00_candr
            irq_mngr00_gls_clk  : out std_logic;
            irq_mngr00_gls_reset  : out std_logic;
            -- led0_swb16
            led0_wbs_add  : out std_logic;
            led0_wbs_writedata  : out std_logic_vector(15 downto 0);
            led0_wbs_readdata  : in std_logic_vector(15 downto 0);
            led0_wbs_strobe  : out std_logic;
            led0_wbs_cycle  : out std_logic;
            led0_wbs_write  : out std_logic;
            led0_wbs_ack  : in std_logic;
            -- led0_candr
            led0_gls_reset  : out std_logic;
            led0_gls_clk  : out std_logic;
            -- button0_swb16
            button0_wbs_add  : out std_logic;
            button0_wbs_readdata  : in std_logic_vector(15 downto 0);
            button0_wbs_strobe  : out std_logic;
            button0_wbs_write  : out std_logic;
            button0_wbs_ack  : in std_logic;
            button0_wbs_cycle  : out std_logic;
            -- button0_candr
            button0_gls_reset  : out std_logic;
            button0_gls_clk  : out std_logic;
            -- wrapper
            wrapper_wbm_address  : in std_logic_vector(12 downto 0);
            wrapper_wbm_readdata  : out std_logic_vector(15 downto 0);
            wrapper_wbm_writedata  : in std_logic_vector(15 downto 0);
            wrapper_wbm_strobe  : in std_logic;
            wrapper_wbm_write  : in std_logic;
            wrapper_wbm_ack  : out std_logic;
            wrapper_wbm_cycle  : in std_logic;
            -- wrapper_candr
            wrapper_gls_reset  : out std_logic;
            wrapper_gls_clk  : out std_logic;
            -- rstgen_syscon00_wrapper
            rstgen_syscon00_gls_clk  : in std_logic;
            rstgen_syscon00_gls_reset  : in std_logic
        );
    end component;
    -------------------------
    -- Signals declaration
    -------------------------

    -- intercon
    -- irq_mngr00_swb16
    signal intercon_irq_mngr00_wbs_s1_address :  std_logic_vector(1 downto 0);
    signal intercon_irq_mngr00_wbs_s1_readdata :  std_logic_vector(15 downto 0);
    signal intercon_irq_mngr00_wbs_s1_writedata :  std_logic_vector(15 downto 0);
    signal intercon_irq_mngr00_wbs_s1_ack :  std_logic;
    signal intercon_irq_mngr00_wbs_s1_strobe :  std_logic;
    signal intercon_irq_mngr00_wbs_s1_cycle :  std_logic;
    signal intercon_irq_mngr00_wbs_s1_write :  std_logic;
    -- irq_mngr00_candr
    signal intercon_irq_mngr00_gls_clk :  std_logic;
    signal intercon_irq_mngr00_gls_reset :  std_logic;
    -- led0_swb16
    signal intercon_led0_wbs_add :  std_logic;
    signal intercon_led0_wbs_writedata :  std_logic_vector(15 downto 0);
    signal intercon_led0_wbs_readdata :  std_logic_vector(15 downto 0);
    signal intercon_led0_wbs_strobe :  std_logic;
    signal intercon_led0_wbs_cycle :  std_logic;
    signal intercon_led0_wbs_write :  std_logic;
    signal intercon_led0_wbs_ack :  std_logic;
    -- led0_candr
    signal intercon_led0_gls_reset :  std_logic;
    signal intercon_led0_gls_clk :  std_logic;
    -- button0_swb16
    signal intercon_button0_wbs_add :  std_logic;
    signal intercon_button0_wbs_readdata :  std_logic_vector(15 downto 0);
    signal intercon_button0_wbs_strobe :  std_logic;
    signal intercon_button0_wbs_write :  std_logic;
    signal intercon_button0_wbs_ack :  std_logic;
    signal intercon_button0_wbs_cycle :  std_logic;
    -- button0_candr
    signal intercon_button0_gls_reset :  std_logic;
    signal intercon_button0_gls_clk :  std_logic;
    -- wrapper
    signal intercon_wrapper_wbm_address :  std_logic_vector(12 downto 0);
    signal intercon_wrapper_wbm_readdata :  std_logic_vector(15 downto 0);
    signal intercon_wrapper_wbm_writedata :  std_logic_vector(15 downto 0);
    signal intercon_wrapper_wbm_strobe :  std_logic;
    signal intercon_wrapper_wbm_write :  std_logic;
    signal intercon_wrapper_wbm_ack :  std_logic;
    signal intercon_wrapper_wbm_cycle :  std_logic;
    -- wrapper_candr
    signal intercon_wrapper_gls_reset :  std_logic;
    signal intercon_wrapper_gls_clk :  std_logic;
    -- rstgen_syscon00_wrapper
    signal intercon_rstgen_syscon00_gls_clk :  std_logic;
    signal intercon_rstgen_syscon00_gls_reset :  std_logic;

    -- irq_mngr
    signal irq_mngr00_irqport : std_logic_vector( 0 downto 0) ; 

begin
    -------------------------
    -- declare instances
    -------------------------

    wrapper : wishbone_wrapper
    port map (
            -- eim
            imx_address => imx_address,
            imx_data    => imx_data,
            imx_cs_n    => imx_cs_n,
            imx_oe_n    => imx_oe_n,
            imx_eb3_n   => imx_eb3_n,
            -- candr
            gls_reset    => intercon_wrapper_gls_reset,
            gls_clk      => intercon_wrapper_gls_clk,
            -- mwb16
            wbm_address  => intercon_wrapper_wbm_address,
            wbm_readdata => intercon_wrapper_wbm_readdata,
            wbm_writedata=> intercon_wrapper_wbm_writedata,
            wbm_strobe   => intercon_wrapper_wbm_strobe,
            wbm_write    => intercon_wrapper_wbm_write,
            wbm_ack      => intercon_wrapper_wbm_ack,
            wbm_cycle    => intercon_wrapper_wbm_cycle
            );

    rstgen_syscon00 : rstgen_syscon
    port map (
            -- candr
            gls_clk   => intercon_rstgen_syscon00_gls_clk,
            gls_reset => intercon_rstgen_syscon00_gls_reset,
            -- clk_ext
            ext_clk   => ext_clk
            );

    irq_mngr00 : irq_mngr
    generic map (
            id => 1,
            irq_level => '1',
            irq_count => 1
        )
    port map (
            -- candr
            gls_clk         => intercon_irq_mngr00_gls_clk,
            gls_reset       => intercon_irq_mngr00_gls_reset,
            -- swb16
            wbs_s1_address  => intercon_irq_mngr00_wbs_s1_address,
            wbs_s1_readdata => intercon_irq_mngr00_wbs_s1_readdata,
            wbs_s1_writedata=> intercon_irq_mngr00_wbs_s1_writedata,
            wbs_s1_ack      => intercon_irq_mngr00_wbs_s1_ack,
            wbs_s1_strobe   => intercon_irq_mngr00_wbs_s1_strobe,
            wbs_s1_cycle    => intercon_irq_mngr00_wbs_s1_cycle,
            wbs_s1_write    => intercon_irq_mngr00_wbs_s1_write,
            -- irq
            irqport         => irq_mngr00_irqport,
            -- ext_irq
            gls_irq         => gls_irq
            );

    led0 : led
    generic map (
            id => 2,
            wb_size => 16
        )
    port map (
            -- int_led
            led_o        => led_o,
            -- candr
            gls_reset    => intercon_led0_gls_reset,
            gls_clk      => intercon_led0_gls_clk,
            -- swb16
            wbs_add      => intercon_led0_wbs_add,
            wbs_writedata=> intercon_led0_wbs_writedata,
            wbs_readdata => intercon_led0_wbs_readdata,
            wbs_strobe   => intercon_led0_wbs_strobe,
            wbs_cycle    => intercon_led0_wbs_cycle,
            wbs_write    => intercon_led0_wbs_write,
            wbs_ack      => intercon_led0_wbs_ack
            );

    button0 : button
    generic map (
            id => 3
        )
    port map (
            -- int_button
            button_i     => button_i,
            irq          => irq_mngr00_irqport(0), 
            -- candr
            gls_reset    => intercon_button0_gls_reset,
            gls_clk      => intercon_button0_gls_clk,
            -- swb16
            wbs_add      => intercon_button0_wbs_add,
            wbs_readdata => intercon_button0_wbs_readdata,
            wbs_strobe   => intercon_button0_wbs_strobe,
            wbs_write    => intercon_button0_wbs_write,
            wbs_ack      => intercon_button0_wbs_ack,
            wbs_cycle    => intercon_button0_wbs_cycle
            );

    intercon_intercon : intercon
    port map (
            -- irq_mngr00_swb16
            irq_mngr00_wbs_s1_address   => intercon_irq_mngr00_wbs_s1_address,
            irq_mngr00_wbs_s1_readdata  => intercon_irq_mngr00_wbs_s1_readdata,
            irq_mngr00_wbs_s1_writedata => intercon_irq_mngr00_wbs_s1_writedata,
            irq_mngr00_wbs_s1_ack       => intercon_irq_mngr00_wbs_s1_ack,
            irq_mngr00_wbs_s1_strobe    => intercon_irq_mngr00_wbs_s1_strobe,
            irq_mngr00_wbs_s1_cycle     => intercon_irq_mngr00_wbs_s1_cycle,
            irq_mngr00_wbs_s1_write     => intercon_irq_mngr00_wbs_s1_write,
            -- irq_mngr00_candr
            irq_mngr00_gls_clk          => intercon_irq_mngr00_gls_clk,
            irq_mngr00_gls_reset        => intercon_irq_mngr00_gls_reset,
            -- led0_swb16
            led0_wbs_add                => intercon_led0_wbs_add,
            led0_wbs_writedata          => intercon_led0_wbs_writedata,
            led0_wbs_readdata           => intercon_led0_wbs_readdata,
            led0_wbs_strobe             => intercon_led0_wbs_strobe,
            led0_wbs_cycle              => intercon_led0_wbs_cycle,
            led0_wbs_write              => intercon_led0_wbs_write,
            led0_wbs_ack                => intercon_led0_wbs_ack,
            -- led0_candr
            led0_gls_reset              => intercon_led0_gls_reset,
            led0_gls_clk                => intercon_led0_gls_clk,
            -- button0_swb16
            button0_wbs_add             => intercon_button0_wbs_add,
            button0_wbs_readdata        => intercon_button0_wbs_readdata,
            button0_wbs_strobe          => intercon_button0_wbs_strobe,
            button0_wbs_write           => intercon_button0_wbs_write,
            button0_wbs_ack             => intercon_button0_wbs_ack,
            button0_wbs_cycle           => intercon_button0_wbs_cycle,
            -- button0_candr
            button0_gls_reset           => intercon_button0_gls_reset,
            button0_gls_clk             => intercon_button0_gls_clk,
            -- intercon
            wrapper_wbm_address         => intercon_wrapper_wbm_address,
            wrapper_wbm_readdata        => intercon_wrapper_wbm_readdata,
            wrapper_wbm_writedata       => intercon_wrapper_wbm_writedata,
            wrapper_wbm_strobe          => intercon_wrapper_wbm_strobe,
            wrapper_wbm_write           => intercon_wrapper_wbm_write,
            wrapper_wbm_ack             => intercon_wrapper_wbm_ack,
            wrapper_wbm_cycle           => intercon_wrapper_wbm_cycle,
            -- wrapper_candr
            wrapper_gls_reset           => intercon_wrapper_gls_reset,
            wrapper_gls_clk             => intercon_wrapper_gls_clk,
            -- rstgen_syscon00_wrapper
            rstgen_syscon00_gls_clk     => intercon_rstgen_syscon00_gls_clk,
            rstgen_syscon00_gls_reset   => intercon_rstgen_syscon00_gls_reset
            );

end architecture top_wishbone_example_1;
