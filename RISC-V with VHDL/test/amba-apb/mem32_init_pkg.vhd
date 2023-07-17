--! \file mem32_init_pkg.vhd
--! \brief Impure function to initialize a memory from a constant array
--! \author Esquirol Charlotte
--! \author Paco Rodríguez
--! \version 0.2
--! \date July 2023
--!
--! Changelog: package renamed, comments updated, removed dependency from numeric_std package and work library
--!
library ieee;
use ieee.std_logic_1164.all;

package mem32_init_pkg is 

	--! Data type of the elements of the constant array used to fill the memory
	type mem32_t is array (natural range <>) of std_logic_vector(31 downto 0);
	
	--! \brief Impure function that takes the constant array init and returns the first depth positions
	--! \param[in] init Constant array of mem32_t elements with initial values
	--! \param[in] depth Number of entries to be initialized
	--! \return Array of depth x mem32_t elements
	-- The returned array is an array of depth x mem32_t elements, 
	-- initialized to init contents.
	-- If depth is larger that init'length then only the first init'length entries are initialized,
	-- the rest contain zero.
	impure function mem32_init_f(init : mem32_t; depth : natural) return mem32_t;

end package mem32_init_pkg;


package body mem32_init_pkg is 

	impure function mem32_init_f(init : mem32_t; depth : natural) return mem32_t is
		variable mem_v : mem32_t(0 to depth-1);
  	begin
		-- report "Debug: function mem32_init_f called" ;
		mem_v := (others => (others => '0')); -- make sure non explicitly-init entries are set to zero
		-- Loop to initialize the first depth entries
		for idx_v in 0 to depth-1 loop
			-- But init only in range of source data array
			if (idx_v >= init'length) then
				exit;
			end if;
			mem_v(idx_v) := init(idx_v);
		end loop; -- idx_v loop
		return mem_v;
  	end function mem32_init_f;

end package body mem32_init_pkg;