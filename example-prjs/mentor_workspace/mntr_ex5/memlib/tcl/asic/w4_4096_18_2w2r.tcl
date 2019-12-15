flow package require MemGen
flow run /MemGen/MemoryGenerator_BuildLibWithTempDir {
    RTLTOOL RTLCompiler
    VENDOR Nangate
    TECHNOLOGY 045nm
    OUTPUT_DIR memlib_asic
    MODULE w4_4096_18_2w2r
    LIBRARY w4_Nangate_RAMS
    WIDTH 18
    DEPTH 4096
    AREA 0
    RDWRRESOLUTION UNKNOWN
    READLATENCY 1
    WRITELATENCY 1
    TIMEUNIT 1ns
    READDELAY 0.1
    WRITEDELAY 0.1
    INPUTDELAY 0.01
    INITDELAY 1
    VHDLARRAYPATH {}
    VERILOGARRAYPATH {}
    FILES {
        { FILENAME /home/giuseppe/research/projects/fastml/hls4ml-mentor.git/example-prjs/mentor_workspace/mntr_ex5/memlib/asic/w4_4096_18_2w2r.v
          FILETYPE Verilog MODELTYPE generic PARSE 1 PATHTYPE copy STATICFILE 1 VHDL_LIB_MAPS work }
        { FILENAME /home/giuseppe/research/projects/fastml/hls4ml-mentor.git/example-prjs/mentor_workspace/memgen/tech/opencell_45nm/wrapper_ccs_ram_sync_dualport.v
          FILETYPE Verilog MODELTYPE generic PARSE 1 PATHTYPE copy STATICFILE 1 VHDL_LIB_MAPS work }
        { FILENAME /opt/cad/catapult/pkgs/siflibs/ccs_ram_sync_dualport.v
          FILETYPE Verilog MODELTYPE generic PARSE 1 PATHTYPE copy STATICFILE 1 VHDL_LIB_MAPS work }
    }
    PARAMETERS {}
    PORTS {
        {NAME port_1 MODE Write}
        {NAME port_2 MODE Write}
        {NAME port_3 MODE Read}
        {NAME port_4 MODE Read}
    }
    PINMAPS {
        {PHYPIN CLK  LOGPIN CLOCK        DIRECTION in  WIDTH 1.0  PHASE 1  DEFAULT {} PORTS {port_1 port_2 port_3 port_4}}
        {PHYPIN CE0  LOGPIN PORT_ENABLE  DIRECTION in  WIDTH 1.0  PHASE 1  DEFAULT {} PORTS port_1}
        {PHYPIN A0   LOGPIN ADDRESS      DIRECTION in  WIDTH 12.0 PHASE {} DEFAULT {} PORTS port_1}
        {PHYPIN D0   LOGPIN DATA_IN      DIRECTION in  WIDTH 18.0 PHASE {} DEFAULT {} PORTS port_1}
        {PHYPIN WE0  LOGPIN WRITE_ENABLE DIRECTION in  WIDTH 1.0  PHASE 1  DEFAULT {} PORTS port_1}
        {PHYPIN WEM0 LOGPIN WRITE_MASK   DIRECTION in  WIDTH 18.0 PHASE 1  DEFAULT {} PORTS port_1}
        {PHYPIN CE1  LOGPIN PORT_ENABLE  DIRECTION in  WIDTH 1.0  PHASE 1  DEFAULT {} PORTS port_2}
        {PHYPIN A1   LOGPIN ADDRESS      DIRECTION in  WIDTH 12.0 PHASE {} DEFAULT {} PORTS port_2}
        {PHYPIN D1   LOGPIN DATA_IN      DIRECTION in  WIDTH 18.0 PHASE {} DEFAULT {} PORTS port_2}
        {PHYPIN WE1  LOGPIN WRITE_ENABLE DIRECTION in  WIDTH 1.0  PHASE 1  DEFAULT {} PORTS port_2}
        {PHYPIN WEM1 LOGPIN WRITE_MASK   DIRECTION in  WIDTH 18.0 PHASE 1  DEFAULT {} PORTS port_2}
        {PHYPIN CE2  LOGPIN PORT_ENABLE  DIRECTION in  WIDTH 1.0  PHASE 1  DEFAULT {} PORTS port_3}
        {PHYPIN A2   LOGPIN ADDRESS      DIRECTION in  WIDTH 12.0 PHASE {} DEFAULT {} PORTS port_3}
        {PHYPIN Q2   LOGPIN DATA_OUT     DIRECTION out WIDTH 18.0 PHASE {} DEFAULT {} PORTS port_3}
        {PHYPIN CE3  LOGPIN PORT_ENABLE  DIRECTION in  WIDTH 1.0  PHASE 1  DEFAULT {} PORTS port_4}
        {PHYPIN A3   LOGPIN ADDRESS      DIRECTION in  WIDTH 12.0 PHASE {} DEFAULT {} PORTS port_4}
        {PHYPIN Q3   LOGPIN DATA_OUT     DIRECTION out WIDTH 18.0 PHASE {} DEFAULT {} PORTS port_4}
    }
}