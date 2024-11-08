library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wishbone_tb is
end wishbone_tb;

architecture behavior of wishbone_tb is
    constant master_width : integer := 64;
    constant slave_width : integer := 64;

    signal CLK_I : std_logic := '0';
    signal RST_I : std_logic := '1';
    signal DATA_INPUT : std_logic_vector(master_width-1 downto 0);
    signal ADR_INPUT : std_logic_vector(7 downto 0);
    signal WE_INPUT : std_logic := '1';
    signal DATA_OUTPUT : std_logic_vector(master_width-1 downto 0);
    signal SMP : std_logic := '0';

    component wishbone_intercon
        generic (
            master_width : integer := 64;
            slave_width : integer := 16
        );
        port (
            CLK_I : in std_logic;
            RST_I : in std_logic;
            DATA_INPUT : in std_logic_vector(master_width-1 downto 0);
            ADR_INPUT : in std_logic_vector(7 downto 0);
            WE_INPUT : in std_logic;
            SMP : in std_logic;
            DATA_OUTPUT : out std_logic_vector(master_width-1 downto 0)
        );
    end component;

begin
    uut: wishbone_intercon
        generic map (
            master_width => 64,
            slave_width => 16
        )
        port map (
            CLK_I => CLK_I,
            RST_I => RST_I,
            DATA_INPUT => DATA_INPUT,
            ADR_INPUT => ADR_INPUT,
            WE_INPUT => WE_INPUT,
            SMP => SMP,
            DATA_OUTPUT => DATA_OUTPUT
        );

    clk_process: process
    begin
			-- while true loop
        CLK_I <= not CLK_I;
        wait for 5 ps;
			-- end loop;
    end process;

    be : process
    begin
        DATA_INPUT <= x"123ababaabcdef90";
        ADR_INPUT <= "10110110";
        WE_INPUT <= '1';
        wait for 30 ps;
        RST_I <= '0';
        wait for 40 ps;
        WE_INPUT <= '1';
        DATA_INPUT <= x"1234567812345678";
        ADR_INPUT <= "11000110";
        wait for 350 ps;
        WE_INPUT <= '0';
        SMP <= '1';
        ADR_INPUT <= "10110110";
        wait for 30 ps;
        DATA_INPUT <= x"abcdefabcdefabcd";
        -- WE_INPUT <= '1';
        wait;
		end process be;

end behavior;
