--------------------------------------------------------------------------------
-- Copyright (c) 1995-2003 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 9.1i
--  \   \         Application : ISE
--  /   /         Filename : w.vhw
-- /___/   /\     Timestamp : Tue Dec 03 14:27:04 2013
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: w
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY w IS
END w;

ARCHITECTURE testbench_arch OF w IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT cpu
        PORT (
            reset : In std_logic;
            clk : In std_logic;
            ABUS : Out std_logic_vector (15 DownTo 0);
            DBUS : InOut std_logic_vector (15 DownTo 0);
            nMREQ : Out std_logic;
            nWR : Out std_logic;
            nRD : Out std_logic;
            nBHE : Out std_logic;
            nBLE : Out std_logic;
            CS : Out std_logic;
            tempt : Out std_logic_vector (3 DownTo 0);
            tempIR : Out std_logic_vector (15 DownTo 0);
            tempALUOUT : Out std_logic_vector (7 DownTo 0);
            tempRtemp : Out std_logic_vector (7 DownTo 0);
            tempAddr : Out std_logic_vector (15 DownTo 0);
            tempPCout : Out std_logic_vector (15 DownTo 0);
            tempz : Out std_logic;
            tempcy : Out std_logic
        );
    END COMPONENT;

    SIGNAL reset : std_logic := '1';
    SIGNAL clk : std_logic := '0';
    SIGNAL ABUS : std_logic_vector (15 DownTo 0) := "0000000000000000";
    SIGNAL DBUS : std_logic_vector (15 DownTo 0) := "ZZZZZZZZZZZZZZZZ";
    SIGNAL nMREQ : std_logic := '0';
    SIGNAL nWR : std_logic := '0';
    SIGNAL nRD : std_logic := '0';
    SIGNAL nBHE : std_logic := '0';
    SIGNAL nBLE : std_logic := '0';
    SIGNAL CS : std_logic := '0';
    SIGNAL tempt : std_logic_vector (3 DownTo 0) := "0000";
    SIGNAL tempIR : std_logic_vector (15 DownTo 0) := "0000000000000000";
    SIGNAL tempALUOUT : std_logic_vector (7 DownTo 0) := "00000000";
    SIGNAL tempRtemp : std_logic_vector (7 DownTo 0) := "00000000";
    SIGNAL tempAddr : std_logic_vector (15 DownTo 0) := "0000000000000000";
    SIGNAL tempPCout : std_logic_vector (15 DownTo 0) := "0000000000000000";
    SIGNAL tempz : std_logic := '0';
    SIGNAL tempcy : std_logic := '0';

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 0 ns;

    BEGIN
        UUT : cpu
        PORT MAP (
            reset => reset,
            clk => clk,
            ABUS => ABUS,
            DBUS => DBUS,
            nMREQ => nMREQ,
            nWR => nWR,
            nRD => nRD,
            nBHE => nBHE,
            nBLE => nBLE,
            CS => CS,
            tempt => tempt,
            tempIR => tempIR,
            tempALUOUT => tempALUOUT,
            tempRtemp => tempRtemp,
            tempAddr => tempAddr,
            tempPCout => tempPCout,
            tempz => tempz,
            tempcy => tempcy
        );

        PROCESS    -- clock process for clk
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                clk <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                clk <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS
            BEGIN
                -- -------------  Current Time:  85ns
                WAIT FOR 85 ns;
                reset <= '0';
                DBUS <= "0000000110000000";
                -- -------------------------------------
                -- -------------  Current Time:  285ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  885ns
                WAIT FOR 600 ns;
                DBUS <= "0000011100000001";
                -- -------------------------------------
                -- -------------  Current Time:  1085ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  1685ns
                WAIT FOR 600 ns;
                DBUS <= "0010000000001001";
                -- -------------------------------------
                -- -------------  Current Time:  1885ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  2485ns
                WAIT FOR 600 ns;
                DBUS <= "0001001000000001";
                -- -------------------------------------
                -- -------------  Current Time:  2685ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  3285ns
                WAIT FOR 600 ns;
                DBUS <= "0000011000000001";
                -- -------------------------------------
                -- -------------  Current Time:  3485ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  4085ns
                WAIT FOR 600 ns;
                DBUS <= "0010101100000000";
                -- -------------------------------------
                -- -------------  Current Time:  4285ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  4485ns
                WAIT FOR 200 ns;
                DBUS <= "0000000010000000";
                -- -------------------------------------
                -- -------------  Current Time:  4685ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  4885ns
                WAIT FOR 200 ns;
                DBUS <= "0000100000000001";
                -- -------------------------------------
                -- -------------  Current Time:  5085ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  5285ns
                WAIT FOR 200 ns;
                DBUS <= "0000000010000000";
                -- -------------------------------------
                -- -------------  Current Time:  5485ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  5685ns
                WAIT FOR 200 ns;
                DBUS <= "0001110000000111";
                -- -------------------------------------
                -- -------------  Current Time:  5885ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  6085ns
                WAIT FOR 200 ns;
                DBUS <= "0000000010000000";
                -- -------------------------------------
                -- -------------  Current Time:  6285ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  6485ns
                WAIT FOR 200 ns;
                DBUS <= "0011000110000000";
                -- -------------------------------------
                -- -------------  Current Time:  6685ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  7285ns
                WAIT FOR 600 ns;
                DBUS <= "0011100100000010";
                -- -------------------------------------
                -- -------------  Current Time:  7485ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  8085ns
                WAIT FOR 600 ns;
                DBUS <= "0100000110000000";
                -- -------------------------------------
                -- -------------  Current Time:  8285ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  8885ns
                WAIT FOR 600 ns;
                DBUS <= "0100101000000001";
                -- -------------------------------------
                -- -------------  Current Time:  9085ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  9685ns
                WAIT FOR 600 ns;
                DBUS <= "1000100000000011";
                -- -------------------------------------
                -- -------------  Current Time:  9885ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  10485ns
                WAIT FOR 600 ns;
                DBUS <= "0101000100000000";
                -- -------------------------------------
                -- -------------  Current Time:  10685ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  11285ns
                WAIT FOR 600 ns;
                DBUS <= "0101101000000001";
                -- -------------------------------------
                -- -------------  Current Time:  11485ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  12085ns
                WAIT FOR 600 ns;
                DBUS <= "0110000111111111";
                -- -------------------------------------
                -- -------------  Current Time:  12285ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  12885ns
                WAIT FOR 600 ns;
                DBUS <= "0110101000000001";
                -- -------------------------------------
                -- -------------  Current Time:  13085ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  13685ns
                WAIT FOR 600 ns;
                DBUS <= "0010000000000000";
                -- -------------------------------------
                -- -------------  Current Time:  13885ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  14485ns
                WAIT FOR 600 ns;
                DBUS <= "0010000000001001";
                -- -------------------------------------
                -- -------------  Current Time:  14685ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  15285ns
                WAIT FOR 600 ns;
                DBUS <= "0010000000010010";
                -- -------------------------------------
                -- -------------  Current Time:  15485ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  16085ns
                WAIT FOR 600 ns;
                DBUS <= "0010000000011011";
                -- -------------------------------------
                -- -------------  Current Time:  16285ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  16885ns
                WAIT FOR 600 ns;
                DBUS <= "0010000000100100";
                -- -------------------------------------
                -- -------------  Current Time:  17085ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  17685ns
                WAIT FOR 600 ns;
                DBUS <= "0010000000110110";
                -- -------------------------------------
                -- -------------  Current Time:  17885ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  18485ns
                WAIT FOR 600 ns;
                DBUS <= "0010000000111111";
                -- -------------------------------------
                -- -------------  Current Time:  18685ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  19285ns
                WAIT FOR 600 ns;
                DBUS <= "0111000000000000";
                -- -------------------------------------
                -- -------------  Current Time:  19485ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  20085ns
                WAIT FOR 600 ns;
                DBUS <= "0111100000000000";
                -- -------------------------------------
                -- -------------  Current Time:  20285ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  20885ns
                WAIT FOR 600 ns;
                DBUS <= "1000000000100011";
                -- -------------------------------------
                -- -------------  Current Time:  21085ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  21685ns
                WAIT FOR 600 ns;
                DBUS <= "1001000011111101";
                -- -------------------------------------
                -- -------------  Current Time:  21885ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  22485ns
                WAIT FOR 600 ns;
                DBUS <= "1000100000000001";
                -- -------------------------------------
                -- -------------  Current Time:  22685ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                -- -------------  Current Time:  23285ns
                WAIT FOR 600 ns;
                DBUS <= "1001000011111101";
                -- -------------------------------------
                -- -------------  Current Time:  23485ns
                WAIT FOR 200 ns;
                DBUS <= "ZZZZZZZZZZZZZZZZ";
                -- -------------------------------------
                WAIT FOR 6715 ns;

            END PROCESS;

    END testbench_arch;

