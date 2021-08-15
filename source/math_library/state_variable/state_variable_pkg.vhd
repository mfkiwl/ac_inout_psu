library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library math_library;
    use math_library.multiplier_pkg.all;

------------------------------------------------------------------------
package state_variable_pkg is

    type state_variable_record is record
        state           : int18;
        integrator_gain : int18;
    end record;

    function init_state_variable_gain ( integrator_gain : int18)
        return state_variable_record;

    constant init_state_variable : state_variable_record := (0, 0);

    procedure create_state_variable (
        signal state_variable : inout state_variable_record;
        integrator_gain : int18);

    procedure integrate_state (
        signal state_variable : inout state_variable_record;
        signal multiplier : inout multiplier_record;
        state_equation : in int18);

end package state_variable_pkg;

------------------------------------------------------------------------
package body state_variable_pkg is

    function init_state_variable_gain
    (
        integrator_gain : int18
    )
    return state_variable_record
    is
        variable state_variable : state_variable_record;
    begin
        state_variable := (state => 0, integrator_gain => integrator_gain);
        return state_variable;
    end init_state_variable_gain;

    procedure create_state_variable
    (
        signal state_variable : inout state_variable_record;
        integrator_gain : int18
    ) is
    begin 
        state_variable.integrator_gain <= integrator_gain;

    end create_state_variable;

--------------------------------------------------
    procedure integrate_state
    (
        signal state_variable : inout state_variable_record;
        signal multiplier : inout multiplier_record;
        state_equation : in int18
    ) is
        alias integrator_gain is state_variable.integrator_gain;
    begin
        sequential_multiply(multiplier, integrator_gain, state_equation); 
        if multiplier_is_ready(multiplier) then
            state_variable.state <= get_multiplier_result(multiplier, 15) + state_variable.state;
        end if;
        
    end integrate_state;

------------------------------------------------------------------------
end package body state_variable_pkg;
