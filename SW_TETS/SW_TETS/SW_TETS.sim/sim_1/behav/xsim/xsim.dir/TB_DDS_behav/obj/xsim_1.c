/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_2(char*, char *);
extern void execute_3(char*, char *);
extern void execute_4(char*, char *);
extern void execute_1909(char*, char *);
extern void execute_1910(char*, char *);
extern void execute_1911(char*, char *);
extern void execute_1912(char*, char *);
extern void execute_8(char*, char *);
extern void execute_9(char*, char *);
extern void execute_10(char*, char *);
extern void execute_11(char*, char *);
extern void execute_12(char*, char *);
extern void execute_1897(char*, char *);
extern void execute_1898(char*, char *);
extern void execute_1899(char*, char *);
extern void execute_1900(char*, char *);
extern void execute_1905(char*, char *);
extern void execute_1906(char*, char *);
extern void execute_1907(char*, char *);
extern void execute_1908(char*, char *);
extern void execute_7(char*, char *);
extern void execute_134(char*, char *);
extern void execute_192(char*, char *);
extern void execute_537(char*, char *);
extern void execute_538(char*, char *);
extern void execute_546(char*, char *);
extern void execute_554(char*, char *);
extern void execute_555(char*, char *);
extern void execute_131(char*, char *);
extern void execute_132(char*, char *);
extern void execute_133(char*, char *);
extern void execute_194(char*, char *);
extern void execute_199(char*, char *);
extern void execute_210(char*, char *);
extern void execute_202(char*, char *);
extern void execute_205(char*, char *);
extern void execute_206(char*, char *);
extern void execute_216(char*, char *);
extern void execute_214(char*, char *);
extern void execute_544(char*, char *);
extern void execute_541(char*, char *);
extern void execute_542(char*, char *);
extern void execute_550(char*, char *);
extern void execute_551(char*, char *);
extern void execute_552(char*, char *);
extern void execute_152(char*, char *);
extern void execute_153(char*, char *);
extern void execute_163(char*, char *);
extern void execute_143(char*, char *);
extern void execute_149(char*, char *);
extern void execute_150(char*, char *);
extern void execute_147(char*, char *);
extern void execute_155(char*, char *);
extern void execute_157(char*, char *);
extern void execute_159(char*, char *);
extern void execute_161(char*, char *);
extern void execute_223(char*, char *);
extern void execute_529(char*, char *);
extern void execute_530(char*, char *);
extern void execute_226(char*, char *);
extern void execute_228(char*, char *);
extern void execute_230(char*, char *);
extern void execute_270(char*, char *);
extern void execute_272(char*, char *);
extern void execute_273(char*, char *);
extern void execute_367(char*, char *);
extern void execute_396(char*, char *);
extern void execute_403(char*, char *);
extern void execute_415(char*, char *);
extern void execute_504(char*, char *);
extern void execute_505(char*, char *);
extern void execute_520(char*, char *);
extern void execute_503(char*, char *);
extern void execute_508(char*, char *);
extern void execute_509(char*, char *);
extern void execute_236(char*, char *);
extern void execute_237(char*, char *);
extern void execute_238(char*, char *);
extern void execute_244(char*, char *);
extern void execute_262(char*, char *);
extern void execute_263(char*, char *);
extern void execute_265(char*, char *);
extern void execute_253(char*, char *);
extern void execute_259(char*, char *);
extern void execute_260(char*, char *);
extern void execute_257(char*, char *);
extern void execute_313(char*, char *);
extern void execute_285(char*, char *);
extern void execute_286(char*, char *);
extern void execute_316(char*, char *);
extern void execute_349(char*, char *);
extern void execute_351(char*, char *);
extern void execute_352(char*, char *);
extern void execute_309(char*, char *);
extern void execute_310(char*, char *);
extern void execute_312(char*, char *);
extern void execute_300(char*, char *);
extern void execute_306(char*, char *);
extern void execute_307(char*, char *);
extern void execute_304(char*, char *);
extern void execute_320(char*, char *);
extern void execute_325(char*, char *);
extern void execute_343(char*, char *);
extern void execute_344(char*, char *);
extern void execute_346(char*, char *);
extern void execute_334(char*, char *);
extern void execute_340(char*, char *);
extern void execute_341(char*, char *);
extern void execute_338(char*, char *);
extern void execute_356(char*, char *);
extern void execute_357(char*, char *);
extern void execute_358(char*, char *);
extern void execute_400(char*, char *);
extern void execute_390(char*, char *);
extern void execute_391(char*, char *);
extern void execute_393(char*, char *);
extern void execute_381(char*, char *);
extern void execute_387(char*, char *);
extern void execute_388(char*, char *);
extern void execute_385(char*, char *);
extern void execute_478(char*, char *);
extern void execute_426(char*, char *);
extern void execute_429(char*, char *);
extern void execute_464(char*, char *);
extern void execute_465(char*, char *);
extern void execute_436(char*, char *);
extern void execute_438(char*, char *);
extern void execute_441(char*, char *);
extern void execute_469(char*, char *);
extern void execute_470(char*, char *);
extern void execute_474(char*, char *);
extern void execute_486(char*, char *);
extern void execute_487(char*, char *);
extern void execute_459(char*, char *);
extern void execute_460(char*, char *);
extern void execute_462(char*, char *);
extern void execute_450(char*, char *);
extern void execute_456(char*, char *);
extern void execute_457(char*, char *);
extern void execute_454(char*, char *);
extern void execute_526(char*, char *);
extern void execute_1902(char*, char *);
extern void execute_1903(char*, char *);
extern void execute_1904(char*, char *);
extern void execute_1913(char*, char *);
extern void execute_1914(char*, char *);
extern void execute_1915(char*, char *);
extern void execute_1916(char*, char *);
extern void execute_1917(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_8(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_13(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_15(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_16(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_17(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_18(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_19(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_20(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_21(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_22(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_25(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_71(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_72(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_78(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_79(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_82(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_83(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_84(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_105(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_109(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_116(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_125(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_245(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_262(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_263(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_369(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_415(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_416(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_422(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_423(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_426(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_427(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_428(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_449(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_453(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_460(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_469(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_561(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_578(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_579(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_685(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_731(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_732(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_738(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_739(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_742(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_743(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_744(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_765(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_769(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_776(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_785(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_877(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_894(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_895(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1001(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1047(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1048(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1054(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1055(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1058(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1059(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1060(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1081(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1085(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1092(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1101(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1193(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1210(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1211(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_11(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_12(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_14(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[224] = {(funcp)execute_2, (funcp)execute_3, (funcp)execute_4, (funcp)execute_1909, (funcp)execute_1910, (funcp)execute_1911, (funcp)execute_1912, (funcp)execute_8, (funcp)execute_9, (funcp)execute_10, (funcp)execute_11, (funcp)execute_12, (funcp)execute_1897, (funcp)execute_1898, (funcp)execute_1899, (funcp)execute_1900, (funcp)execute_1905, (funcp)execute_1906, (funcp)execute_1907, (funcp)execute_1908, (funcp)execute_7, (funcp)execute_134, (funcp)execute_192, (funcp)execute_537, (funcp)execute_538, (funcp)execute_546, (funcp)execute_554, (funcp)execute_555, (funcp)execute_131, (funcp)execute_132, (funcp)execute_133, (funcp)execute_194, (funcp)execute_199, (funcp)execute_210, (funcp)execute_202, (funcp)execute_205, (funcp)execute_206, (funcp)execute_216, (funcp)execute_214, (funcp)execute_544, (funcp)execute_541, (funcp)execute_542, (funcp)execute_550, (funcp)execute_551, (funcp)execute_552, (funcp)execute_152, (funcp)execute_153, (funcp)execute_163, (funcp)execute_143, (funcp)execute_149, (funcp)execute_150, (funcp)execute_147, (funcp)execute_155, (funcp)execute_157, (funcp)execute_159, (funcp)execute_161, (funcp)execute_223, (funcp)execute_529, (funcp)execute_530, (funcp)execute_226, (funcp)execute_228, (funcp)execute_230, (funcp)execute_270, (funcp)execute_272, (funcp)execute_273, (funcp)execute_367, (funcp)execute_396, (funcp)execute_403, (funcp)execute_415, (funcp)execute_504, (funcp)execute_505, (funcp)execute_520, (funcp)execute_503, (funcp)execute_508, (funcp)execute_509, (funcp)execute_236, (funcp)execute_237, (funcp)execute_238, (funcp)execute_244, (funcp)execute_262, (funcp)execute_263, (funcp)execute_265, (funcp)execute_253, (funcp)execute_259, (funcp)execute_260, (funcp)execute_257, (funcp)execute_313, (funcp)execute_285, (funcp)execute_286, (funcp)execute_316, (funcp)execute_349, (funcp)execute_351, (funcp)execute_352, (funcp)execute_309, (funcp)execute_310, (funcp)execute_312, (funcp)execute_300, (funcp)execute_306, (funcp)execute_307, (funcp)execute_304, (funcp)execute_320, (funcp)execute_325, (funcp)execute_343, (funcp)execute_344, (funcp)execute_346, (funcp)execute_334, (funcp)execute_340, (funcp)execute_341, (funcp)execute_338, (funcp)execute_356, (funcp)execute_357, (funcp)execute_358, (funcp)execute_400, (funcp)execute_390, (funcp)execute_391, (funcp)execute_393, (funcp)execute_381, (funcp)execute_387, (funcp)execute_388, (funcp)execute_385, (funcp)execute_478, (funcp)execute_426, (funcp)execute_429, (funcp)execute_464, (funcp)execute_465, (funcp)execute_436, (funcp)execute_438, (funcp)execute_441, (funcp)execute_469, (funcp)execute_470, (funcp)execute_474, (funcp)execute_486, (funcp)execute_487, (funcp)execute_459, (funcp)execute_460, (funcp)execute_462, (funcp)execute_450, (funcp)execute_456, (funcp)execute_457, (funcp)execute_454, (funcp)execute_526, (funcp)execute_1902, (funcp)execute_1903, (funcp)execute_1904, (funcp)execute_1913, (funcp)execute_1914, (funcp)execute_1915, (funcp)execute_1916, (funcp)execute_1917, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_8, (funcp)transaction_13, (funcp)transaction_15, (funcp)transaction_16, (funcp)transaction_17, (funcp)transaction_18, (funcp)transaction_19, (funcp)transaction_20, (funcp)transaction_21, (funcp)transaction_22, (funcp)transaction_25, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_71, (funcp)transaction_72, (funcp)transaction_78, (funcp)transaction_79, (funcp)transaction_82, (funcp)transaction_83, (funcp)transaction_84, (funcp)transaction_105, (funcp)transaction_109, (funcp)transaction_116, (funcp)transaction_125, (funcp)transaction_245, (funcp)transaction_262, (funcp)transaction_263, (funcp)transaction_369, (funcp)transaction_415, (funcp)transaction_416, (funcp)transaction_422, (funcp)transaction_423, (funcp)transaction_426, (funcp)transaction_427, (funcp)transaction_428, (funcp)transaction_449, (funcp)transaction_453, (funcp)transaction_460, (funcp)transaction_469, (funcp)transaction_561, (funcp)transaction_578, (funcp)transaction_579, (funcp)transaction_685, (funcp)transaction_731, (funcp)transaction_732, (funcp)transaction_738, (funcp)transaction_739, (funcp)transaction_742, (funcp)transaction_743, (funcp)transaction_744, (funcp)transaction_765, (funcp)transaction_769, (funcp)transaction_776, (funcp)transaction_785, (funcp)transaction_877, (funcp)transaction_894, (funcp)transaction_895, (funcp)transaction_1001, (funcp)transaction_1047, (funcp)transaction_1048, (funcp)transaction_1054, (funcp)transaction_1055, (funcp)transaction_1058, (funcp)transaction_1059, (funcp)transaction_1060, (funcp)transaction_1081, (funcp)transaction_1085, (funcp)transaction_1092, (funcp)transaction_1101, (funcp)transaction_1193, (funcp)transaction_1210, (funcp)transaction_1211, (funcp)transaction_11, (funcp)transaction_12, (funcp)transaction_14};
const int NumRelocateId= 224;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/TB_DDS_behav/xsim.reloc",  (void **)funcTab, 224);
	iki_vhdl_file_variable_register(dp + 374648);
	iki_vhdl_file_variable_register(dp + 374704);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/TB_DDS_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void wrapper_func_0(char *dp)

{

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 648864, dp + 645304, 0, 10, 5, 15, 11, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 760240, dp + 645304, 11, 21, 5, 15, 11, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 871616, dp + 645304, 22, 32, 5, 15, 11, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 982992, dp + 645304, 33, 43, 5, 15, 11, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 982992, dp + 645416, 0, 4, 0, 4, 5, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 871616, dp + 645528, 0, 4, 0, 4, 5, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 760240, dp + 645640, 0, 4, 0, 4, 5, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 648864, dp + 645752, 0, 4, 0, 4, 5, 1);

}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/TB_DDS_behav/xsim.reloc");
	wrapper_func_0(dp);

	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/TB_DDS_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/TB_DDS_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/TB_DDS_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
