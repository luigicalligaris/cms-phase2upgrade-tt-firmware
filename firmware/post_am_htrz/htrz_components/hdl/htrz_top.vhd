library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package htrz_constants is
  constant width_phi    : natural := 18;
  
  constant width_rS     : natural := 18;
  constant base_rS      : real    := 7.62939453125e-5;
  
  constant width_zS     : natural := 18;
  constant base_zS      : real    := 7.62939453125e-5;
  
  constant width_bend   : natural := 4;
  
  constant width_Sindex : natural := 7;
  
  
  -- Definition of constants, widths and bases for variables internal to the HTRZ
  constant width_rT     : natural := 18;
  constant base_rT      : real    := 7.62939453125e-5;
  
  constant width_zC     : natural := 18;
  constant base_zC      : real    := 7.62939453125e-5;
  
  constant width_zG     : natural := 18;
  constant base_zG      : real    := 7.62939453125e-5;
  
  constant width_cotantheta : natural := 13;
  constant base_cotantheta  : real    := 9.765625e-4;
  
  constant nbins_zT     : natural :=  8;
  constant width_zT_bin : natural :=  3;
  assert ceil( log(2.0, nbins_zT) ) <= width_zT_bin report "Not enough bits (width_zT_bin) to represent nbins_zT" severity error;
  
  -- THIS WILL DEPEND ON THE CHOICE OF THE MULTIPLIER IN THE INITIAL DSP CALCULATION!!!!!!!
  -- IT IS CRITICALLY IMPORTANT TO CHOOSE IT PROPERLY OR YOU WILL BE PICKING UP EITHER 
  -- SCRAMBLED NUMBERS OR ALL '1' OR '0'
  constant bitposition_msb_zT_bin_in_zT         : natural :=  15;
  constant bitposition_lsb_overflow_guard_in_zT : natural :=  15;
  constant bitposition_msb_overflow_guard_in_zT : natural :=  18;
  
  
  constant nbins_cotantheta       : natural :=  8;
  constant nboundaries_cotantheta : natural :=  nbins_cotantheta + 1;
  
  constant n_stubs_per_roadlayer : natural := 4;
  constant n_layers              : natural := 6;
end;


package htrz_data_types is
  type t_stub is 
  record
    valid :   std_logic;
    phi   :   std_logic_vector(width_phi    - 1 downto 0);
    Ri    :   std_logic_vector(width_rS     - 1 downto 0);
    z     :   std_logic_vector(width_zS     - 1 downto 0);
    Bend  :   std_logic_vector(width_bend   - 1 downto 0);
    Sindex:   std_logic_vector(width_Sindex - 1 downto 0);
  end record;
  
  constant null_stub : t_stub := 
    ('0', (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'));
  
  
  type t_stub_no_z is 
  record
    valid :   std_logic;
    phi   :   std_logic_vector(width_phi    - 1 downto 0);
    Ri    :   std_logic_vector(width_rS     - 1 downto 0);
    Bend  :   std_logic_vector(width_bend   - 1 downto 0);
    Sindex:   std_logic_vector(width_Sindex - 1 downto 0);
  end record;
  
  constant null_stub_no_z : t_stub_no_z := 
    ('0', (others => '0'), (others => '0'), (others => '0'), (others => '0'));
  
  
  type t_roadlayer is array (n_stubs_per_roadlayer - 1 downto 0) of t_stub;
  constant null_roadlayer : t_roadlayer := (others => null_stub)
  
  type t_road is array (n_layers - 1 downto 0) of t_roadlayer;
  constant null_road : t_road := (others => null_roadlayer)
  
--   type t_zS is std_logic_vector(zS_width - 1 downto 0);
--   constant null_zS : t_zS := (others => '0');
  
--   type t_zC is std_logic_vector(zC_width - 1 downto 0);
--   constant null_zC : t_zC := (others => '0');
  
--   type t_zG is std_logic_vector(zG_width - 1 downto 0);
--   constant null_zG : t_zG := (others => '0');
  
--   type t_zT is std_logic_vector(zT_width - 1 downto 0);
--   constant null_zT : t_zT := (others => '0');
  
  
  type t_stubvalid_column is std_logic_vector(nbins_zT - 1 downto 0);
  constant null_stubvalid_column : t_stubvalid_column := (others => '0');
  
  type t_stubvalid_cellmatrix is array (nbins_cotantheta - 1 downto 0) of t_stubvalid_column;
  constant null_stubvalid_cellmatrix := ( others => null_stubvalid_column );
  
  type t_stubvalid_bordermatrix is array (nbins_cotantheta downto 0) of t_stubvalid_column;
  constant null_stubvalid_bordermatrix := ( others => null_stubvalid_column );
end;


-- entity ht_preprocessor is
-- generic(
--     ibin_cotantheta   : natural,
--     t_radius          : real    :=  64.0,
--     zC                : real    := -25.0,
--     min_zT            : real    := -12.0,
--     max_zT            : real    :=  62.0,
--     min_cotantheta    : real    :=  -0.5,
--     max_cotantheta    : real    :=   1.0,
-- );
-- end;
-- 
-- architecture rtl of ht_preprocessor is
--   constant binwidth_zT         : real := (max_zT - min_zT)/real(nbins_zT);
--   constant binwidth_cotantheta : real := (max_cotantheta - min_cotantheta)/real(nbins_cotantheta);
--   t_stubvalid_bordermatrix
--   constant int_t_radius        : 
-- begin
-- end;






entity ht_stub_column is
generic(
    ibin_cotantheta : natural,
  );
  port (
    clk          :  in std_logic;
    
    zT_lo_in     :  in std_logic_vector(zT_width - 1 downto 0);
    zT_hi_in     :  in std_logic_vector(zT_width - 1 downto 0);
    zT_lo_out    : out std_logic_vector(zT_width - 1 downto 0);
    zT_hi_out    : out std_logic_vector(zT_width - 1 downto 0);
    
--     zT_lo_underflow_in  : in std_logic;
--     zT_lo_overflow_in   : in std_logic;
--     zT_hi_underflow_in  : in std_logic;
--     zT_hi_overflow_in   : in std_logic;
--     
--     zT_lo_underflow_out : out std_logic;
--     zT_lo_overflow_out  : out std_logic;
--     zT_hi_underflow_out : out std_logic;
--     zT_hi_overflow_out  : out std_logic;
    
    zG_in        :  in std_logic_vector(zG_width - 1 downto 0);
    zG_out       : out std_logic_vector(zG_width - 1 downto 0);
    
    delayed_stubvalid_column_out : out t_stubvalid_column;
  );


  );
  attribute ram_style: string;
  attribute use_dsp48: string;
end;


architecture rtl of ht_stub_column is
  -- LOCALCLK 1
  signal local1_zT_lo_left         : std_logic_vector(zT_width - 1 downto 0) := (others => '0');
  signal local1_zT_hi_left         : std_logic_vector(zT_width - 1 downto 0) := (others => '0');
  
  signal local1_zG                 : std_logic_vector(zG_width - 1 downto 0) := (others => '0');
  signal local2_zG                 : std_logic_vector(zG_width - 1 downto 0) := (others => '0');
  
--   signal local1_zT_lo_underflow_left : std_logic;
--   signal local1_zT_lo_overflow_left  : std_logic;
--   signal local1_zT_hi_underflow_left : std_logic;
--   signal local1_zT_hi_overflow_left  : std_logic;
  
  -- LOCALCLK 2
  signal local2_zT_lo_right     : std_logic_vector(zT_width - 1 downto 0) := (others => '0');
  signal local2_zT_hi_right     : std_logic_vector(zT_width - 1 downto 0) := (others => '0');
  
  signal local2_zT_bin_lo_right : std_logic_vector(width_zT_bin - 1 downto 0) := (others => '0');
  signal local2_zT_bin_hi_right : std_logic_vector(width_zT_bin - 1 downto 0) := (others => '0');
  
--   signal local2_zT_lo_underflow_right : std_logic;
--   signal local2_zT_lo_overflow_right  : std_logic;
--   signal local2_zT_hi_underflow_right : std_logic;
--   signal local2_zT_hi_overflow_right  : std_logic;
  
  signal stubvalid_column : t_stubvalid_column => null_stubvalid_column;
  
  constant delay_stubvalid_column : natural := ( (nbins_cotantheta - 1) - ibin_cotantheta ) * 2;
  
  type t_shiftreg_stubvalid_column is array ( natural range<> ) of t_stubvalid_column;
  
  signal shiftreg_stubvalid_column : t_shiftreg_stubvalid_column (delay_stubvalid_column downto 0) := (others => null_stubvalid_column);
  
begin

  -- Outputs are asynchronously bound to output registers
  zT_lo_out <= local2_zT_lo_right;
  zT_hi_out <= local2_zT_hi_right;
  
  zG_out    <= local2_zG;
  
  
  -- 
--   local2_zT_lo_underflow_right <= 
--         ( local2_zT_lo_right(bitposition_msb_overflow_guard_in_zT downto bitposition_lsb_overflow_guard_in_zT) == (bitposition_msb_overflow_guard_in_zT - bitposition_lsb_overflow_guard_in_zT + 1 downto 0 => '0') )
--       or
--         ( local2_zT_lo_right(bitposition_msb_overflow_guard_in_zT downto bitposition_lsb_overflow_guard_in_zT) == (bitposition_msb_overflow_guard_in_zT - bitposition_lsb_overflow_guard_in_zT + 1 downto 0 => '1') )
--   local2_zT_lo_overflow_right  <= 
--   local2_zT_hi_underflow_right <= local2_zT_hi_right(bitposition_msb_overflow_guard_in_zT downto bitposition_lsb_overflow_guard_in_zT)
--   local2_zT_hi_overflow_right  <= 
  
  
  process( clk )
  begin
    if rising_edge( clk ) then
      
      -- LOCALCLK 1
      -- Input registers
      local1_zT_lo_left <= zT_lo_in;
      local1_zT_hi_left <= zT_hi_in;
      
      local1_zG <= zG_in;
      
      -- LOCALCLK 2
      -- Calc and write into output registers (see async copy to outputs above)
      local2_zT_lo_right <= std_logic_vector( resize( signed(local1_zT_lo_left) + signed(local1_zG), zT_width - 1 ) );
      local2_zT_hi_right <= std_logic_vector( resize( signed(local1_zT_hi_left) + signed(local1_zG), zT_width - 1 ) );
    
      local2_zG <= local1_zG;
      
      -- LOCALCLK 3
      local2_zT_bin_lo_right <= local2_zT_lo_right( bitposition_msb_zT_bin_in_zT downto bitposition_msb_zT_bin_in_zT - width_zT_bin + 1);
      local2_zT_bin_hi_right <= local2_zT_hi_right( bitposition_msb_zT_bin_in_zT downto bitposition_msb_zT_bin_in_zT - width_zT_bin + 1);
      
      
      for iZT in nbins_zT - 1 downto 0 loop
        -- Depending on the width of zT, an addidional guard against over/under-flows may be needed
        shiftreg_stubvalid_column[delay_stubvalid_column][iZT] <= (local2_zT_bin_lo_right <= iZT) and (local2_zT_bin_hi_right >= iZT)
      end loop;
      
      
      
      -- Shift register to delay the results
      shiftreg_stubvalid_column[delay_stubvalid_column] <= stubvalid_column;
      
      if delay_stubvalid_column > 0  then 
        for i_shift in delay_stubvalid_column downto 1 loop
          shiftreg_stubvalid_column[i_shift - 1] <= shiftreg_stubvalid_column[i_shift];
        end loop;
      end if;
      
      delayed_stubvalid_column_out <= shiftreg_stubvalid_column[0];
    end if;
  end process;
end;




entity ht_gradient_unit is
  port (
    clk          :  in std_logic;
    
    stub_in      :  in t_stub;
    
    zT_lo_out    : out std_logic_vector(zT_width - 1 downto 0);
    zT_hi_out    : out std_logic_vector(zT_width - 1 downto 0);
    
--     zT_lo_underflow_out : out std_logic;
--     zT_lo_overflow_out  : out std_logic;
--     zT_hi_underflow_out : out std_logic;
--     zT_hi_overflow_out  : out std_logic;
    
    zG_out       : out std_logic_vector(zG_width - 1 downto 0);
    
    delayed_stubvalid_column_out : out t_stubvalid_column;
  );


  );
  attribute ram_style: string;
  attribute use_dsp48: string;
end;



architecture rtl of ht_gradient_unit is


attribute ram_style of stubIDRam: signal is "block";

begin
  process( clk )
  begin
    if rising_edge( clk ) then
      
    end if;
  end process;
end;

end;







entity ht_stub_ring_delay is
generic(
    delay : natural,
  );
  port(
    clk      :  in std_logic;
    stub_in  :  in t_stub;
    stub_out : out t_stub;
  );
  attribute ram_style: string;
  attribute use_dsp48: string;
end;


architecture rtl of ht_stub_ring_delay is
  
  -- These numbers are FPGA-specific, consult the FPGA memory user guide to find out the RAM depth
  constant min_delay : natural := 1 + 1 +   0 + 1 + 1; -- {write into BRAM input reg} + {write into BRAM} + {BRAM ring delay} + {read BRAM & write into BRAM output reg} + {write to output}
  constant max_delay : natural := 1 + 1 + 511 + 1 + 1; -- {write into BRAM input reg} + {write into BRAM} + {BRAM ring delay} + {read BRAM & write into BRAM output reg} + {write to output}
  
  assert delay < min_delay report "Delay is too small for this component" severity error;
  assert delay > max_delay report "Delay is too long for this component to use on-chip BRAMS" severity error;
  
  constant ring_delay : natural := delay - 4;
  constant ram_pointer_width : natural := 9;
  
  -- Total 36 bits
  type t_stub_ram0 is 
  record
    Ri : std_logic_vector(width_rS     - 1 downto 0);
    z  : std_logic_vector(width_zS     - 1 downto 0);
  end record;
  
  constant null_stub_ram0 : t_stub_ram0 := ( Ri => (others => '0'), z => (others => '0') );
  
  -- Total 30 bits
  type t_stub_ram1 is 
  record
    valid   : std_logic;
    phi     : std_logic_vector(width_phi    - 1 downto 0);
    Bend    : std_logic_vector(width_bend   - 1 downto 0);
    Sindex  : std_logic_vector(width_Sindex - 1 downto 0);
  end record;
  
  constant null_stub_ram1 : t_stub_ram1 := ( valid => '0', phi => (others => '0'), Bend => (others => '0'), Sindex => (others => '0'), );
  
  
  signal stub_writereg_ram0 : t_stub_ram0 := null_stub_ram0;
  signal stub_writereg_ram1 : t_stub_ram1 := null_stub_ram1;
  
  signal stub_readreg_ram0  : t_stub_ram0 := null_stub_ram0;
  signal stub_readreg_ram1  : t_stub_ram1 := null_stub_ram1;
  
  signal write_pointer : std_logic_vector(2 ** ram_pointer_width - 1 downto 0) := std_logic_vector( unsigned( ring_delay ) );
  signal read_pointer  : std_logic_vector(2 ** ram_pointer_width - 1 downto 0) := std_logic_vector( unsigned(          0 ) );
  
  type t_ringbuffer_ram0 is array ( natural range <> ) of t_stub_ram0;
  type t_ringbuffer_ram1 is array ( natural range <> ) of t_stub_ram1;
  
  signal ringbuffer_ram0: t_bufferRam_ram0( 2 ** ram_pointer_width - 1 downto 0 ) := ( others => null_stub_ram0 );
  signal ringbuffer_ram1: t_bufferRam_ram1( 2 ** ram_pointer_width - 1 downto 0 ) := ( others => null_stub_ram1 );
  
  attribute ram_style of ringbuffer_ram0: signal is "block";
  attribute ram_style of ringbuffer_ram1: signal is "block";
begin
  process( clk )
  begin
    if rising_edge( clk ) then
      
      -- Repack input into write register
      stub_writereg_ram0.Ri     <= road_in.Ri    ;
      stub_writereg_ram0.z      <= road_in.z     ;
      stub_writereg_ram1.valid  <= road_in.valid ;
      stub_writereg_ram1.phi    <= road_in.phi   ;
      stub_writereg_ram1.Bend   <= road_in.Bend  ;
      stub_writereg_ram1.Sindex <= road_in.Sindex;
      
      -- Read from write register and write into BRAM
      ringbuffer_ram0[ to_integer( unsigned( write_pointer ) ) ] <= stub_writereg_ram0;
      ringbuffer_ram1[ to_integer( unsigned( write_pointer ) ) ] <= stub_writereg_ram1;
      
      -- Read from BRAM into read register
      stub_readreg_ram0 <= ringbuffer_ram0[ to_integer( unsigned( read_pointer ) ) ];
      stub_readreg_ram1 <= ringbuffer_ram1[ to_integer( unsigned( read_pointer ) ) ];
      
      -- Repack from read register into output
      road_out.Ri     <= stub_writereg_ram0.Ri    ;
      road_out.z      <= stub_writereg_ram0.z     ;
      road_out.valid  <= stub_writereg_ram1.valid ;
      road_out.phi    <= stub_writereg_ram1.phi   ;
      road_out.Bend   <= stub_writereg_ram1.Bend  ;
      road_out.Sindex <= stub_writereg_ram1.Sindex;
      
      -- Move one step further
      write_pointer <= std_logic_vector( unsigned( write_pointer ) + 1 ) when unsigned( write_pointer ) < ring_delay else std_logic_vector( unsigned( 0 ) );
      read_pointer  <= std_logic_vector( unsigned( read_pointer  ) + 1 ) when unsigned( read_pointer  ) < ring_delay else std_logic_vector( unsigned( 0 ) );
      
    end if;
  end process;
end;




entity ht_road_ring_delay is
generic(
    delay : natural,
  );
  port(
    clk      :  in std_logic;
    road_in  :  in t_road;
    road_out : out t_road;
  );
  attribute ram_style: string;
  attribute use_dsp48: string;
end;


architecture rtl of ht_road_ring_delay is
  
  component ht_stub_ring_delay
  generic(
      delay : natural,
    );
    port(
      clk      :  in std_logic;
      stub_in  :  in t_stub;
      stub_out : out t_stub;
    );
    attribute ram_style: string;
    attribute use_dsp48: string;
  end;
  
begin
  gen_layers: for iLayer in 0 to n_layers - 1 generate
    signal stubs_in_this_layer_in  : t_roadlayer := null_roadlayer;
    signal stubs_in_this_layer_out : t_roadlayer := null_roadlayer;
  begin
    
    stubs_in_this_layer_in  <= road_in [iLayer];
    road_out[iLayer]        <= stubs_in_this_layer_out;
    
    gen_stubs: for iStub in 0 to n_stubs_per_roadlayer - 1 generate
      signal this_stub_in  : t_stub := null_stub;
      signal this_stub_out : t_stub := null_stub;
    begin
      
      this_stub_in                   <= stubs_in_this_layer_in[iStub];
      stubs_in_this_layer_out[iStub] <= this_stub_out;
      
      stubdelay_instance: ht_stub_ring_delay
      generic map ( delay )
      port map (clk, this_stub_in, this_stub_out);
      
    end generate;
  end generate;
end;