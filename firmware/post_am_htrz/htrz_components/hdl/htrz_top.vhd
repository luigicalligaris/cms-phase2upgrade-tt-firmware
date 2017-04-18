library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package ht_data_types is

  constant zT_width           : integer := 12;
  constant zT_increment_width : integer := 12;
  
  constant nbins_zT         : integer := 8;
  constant nbins_cotantheta : integer := 8;
  
  -- This is a nameplace for the record (tbd)
  type t_stub  is std_logic_vector(65 downto 0);
  
  type t_roadlayer is array ( natural range<> ) of t_stub;
  type t_road      is array ( natural range<> ) of t_roadlayer;
  
  
  type t_zT is 
  record
    zT_lo : std_logic_vector( zT_width - 1 downto 0 );
    underflow_hi : std_logic;
    underflow_lo : std_logic;
    overflow_hi  : std_logic;
    overflow_lo  : std_logic;
  end record;
  
  constant null_zT : t_zT := ( ( others => '0' ), '0', '0', '0', '0');
  
  
  type t_zT_increment is std_logic_vector( zT_increment_width - 1 downto 0 );
  constant null_zT_increment : t_zT_increment := ( others => '0' );
  
  
  type t_stubvalid_column is std_logic_vector( nbins_zT - 1 downto 0 );
  constant null_stubvalid_column : t_stubvalid_column := ( others => '0' );
  
  type t_stubvalid_array is array ( natural range<> ) of t_stubvalid_column;
  constant null_stubvalid_array := ( others => null_stubvalid_column );
end;





entity ht_stub_column is
  generic(
    ibin_cotantheta : natural,
--     column_m_loedge : integer := -0.5,
--     column_m_hiedge : integer :=  1.0,
--     column_c_nbins  : integer := 8,
--     column_c_loedge : integer := -0.5,
--     column_c_hiedge : integer :=  1.0,
  );
  port (
    clk          :  in std_logic;
    
    stub_in      :  in t_stub;
    stub_out     : out t_stub;
    
    zT_in        :  in t_zT;
    zT_increment :  in t_zT_increment;
    zT_out       : out t_zT;
    
    validborder_left  :  in t_stubvalid_column;
    validborder_right : out t_stubvalid_column;
    
    validbins_in  : t_stubvalid_array( nbins_cotantheta - 1 downto 0 );
    validbins_out : t_stubvalid_array( nbins_cotantheta - 1 downto 0 );
  );


  );
  attribute ram_style: string;
  attribute use_dsp48: string;
end;


architecture rtl of ht_stub_column is
  signal zT_left  : t_zT := null_zT;
  signal zT_right : t_zT := null_zT;
  
  signal validbins_thiscolumn : t_stubvalid_column := null_stubvalid_column;
  signal validbins_shift1     : t_stubvalid_array  := null_stubvalid_array;
  signal validbins_shift2     : t_stubvalid_array  := null_stubvalid_array;
begin
  
  
  
  
  process( clk )s
  begin
    if rising_edge( clk ) then
      zT_left <= zT_in;    -- LOCALCLK 1
      zT_right <= zT_left; -- LOCALCLK 2
      zT_out  <= zT_right; -- LOCALCLK 3
      
      
      validbins_shift1 <= validbins_in;      -- LOCALCLK 1
      validbins_shift2 <= validbins_shift1;  -- LOCALCLK 2
      validbins_out    <= validbins_shift2;  -- LOCALCLK 3
      
      -- This column fill its own validity bits in the HT matrix (null algo for now)
      validbins_shift2[ibin_cotantheta] <= null_stubvalid_column; -- LOCALCLK 2
      
      
    end if;
  end process;
end;
