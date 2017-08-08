#! /usr/bin/env python
# This script initialises the 'fcu_rtt_mbt/SUT' in RTT_TestProcedure 
# It is copied from the water_tank.v2 in VSI_Bundle.exe

import os
import glob
import sys
#import xml.etree.ElementTree as ET
import json
import httplib
# for file copy
import shutil
from optparse import OptionParser

import datetime

global opt_VERBOSE
opt_VERBOSE = ["--verbose"]

## ###################################################################
## AUX FUNCTIONS
## ###################################################################

def is_exe(fpath):
	return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

def get_exe(fpath):
	if is_exe(fpath):
		return fpath
	if "PATHEXT" in os.environ:
		for extension in os.environ["PATHEXT"].split(";"):
			newfpath = fpath + extension.lower()
			if is_exe(newfpath):
				return newfpath
	return None

def which(program):
	import os

	fpath, fname = os.path.split(program)
	if fpath:
		fpathext = get_exe(program)
		if fpathext is not None:
			return fpathext
	else:
		for path in os.environ["PATH"].split(os.pathsep):
			path = path.strip('"')
			exe_file = os.path.join(path, program)
			exe_file_ext = get_exe(exe_file)
			if exe_file_ext is not None:
				return exe_file_ext
	pass

def py(scriptcall):
	blurt("Invoking [" + sys.platform + "] " + scriptcall)
	if sys.platform.startswith('win'):
		ret = os.system("C:\\Python27\\python.exe" + " " + scriptcall)
	else:
		ret = os.system(scriptcall)
	return (0 == ret)

def is_empty(any_structure):
	if any_structure:
		return False
	else:
		return True

def blurt(s):
	if not is_empty(opt_VERBOSE):
		sys.stderr.write(s + '\n')

def append_to_file(string, file):
	"""Append a (possible multi-line) string to an existing file.
	Fails if the file does not exist.
	"""
	if not os.path.isfile(file):
		sys.stderr.write("ERROR: append_to_file(): file '{0}' does not exist.\n".format(file))
		raise NameError("File does not exist")
	print("# -> appending to " + file)
	with open(file, "a") as out:
			out.write(string)

def define_sut_in_rts(string, file):
	"""In an existing rts-file, replace everything from 
		 '@abstract machine sut()'
	onward by the string.
	Fails if the file does not exist.
	"""
	if not os.path.isfile(file):
		sys.stderr.write("ERROR: append_to_file(): file '{0}' does not exist.\n".format(file))
		raise NameError("File does not exist")
	bak = file + ".BAK"
	print("# -> changing AM SUT in " + file)
	try:
		os.remove(bak)
	except:
		pass
	os.rename(file, bak)
	with open(bak, "r") as old_file:
		with open(file, "w") as out:
			for line in old_file:
				if line.startswith('@abstract machine sut()'):
					out.write(string)
					return
				else:
					out.write(line)

def rm_f(pattern):
    matches = glob.glob(pattern)
    for path in matches:
        try:
            if os.path.exists(path):
                if os.path.isdir(path):
                    shutil.rmtree(path)
                else:
                    os.remove(path)
        except OSError as e:
            if os.path.exists(path):
                print("Failed to remove {0}: {1}".format(path, e))
				
def cp_f(source_pattern, target):
    matches = glob.glob(source_pattern)
    for source in matches:
        if os.path.exists(source):
            if os.path.exists(target) and not os.path.isdir(target):
                rm_f(target)
            shutil.copy(source, target)

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise

## ###################################################################
## EXECUTABLES
## ###################################################################
if sys.platform.startswith('win'):
	os.environ["PATH"] = os.pathsep.join([os.path.join(os.environ["RTTDIR"], "bin"), os.environ["PATH"], "C:\\opt\\gcc-4.9-win64\\bin"])
	PROG_make = "make.exe"
	MBTDIR="C:\\opt\\rtt-mbt"
	RTTDIR="C:\\opt\\rt-tester"
else:
	PROG_make = which("make")
	MBTDIR="/opt/rtt-mbt"
	RTTDIR="/opt/rt-tester"

PROG_init  = os.path.join(MBTDIR, "bin", "rtt-mbt-init-project.py")
PROG_wrap  = os.path.join(MBTDIR, "bin", "rtt-mbt-fmi2-wrap-to-fmu.py")
PROG_sim   = os.path.join(MBTDIR, "bin", "rtt-mbt-fmi2gen-sim.py")
PROG_tp	   = os.path.join(MBTDIR, "bin", "rtt-mbt-fmi2gen.py")
PROG_solve = os.path.join(MBTDIR, "bin", "rtt-mbt-gen.py")
PROG_build = os.path.join(RTTDIR, "bin", "rtt-build-test.py")

## ###############################################
## [1.1] SUT CREATION: standalone SUT 
## ###############################################
def wrap_SUT():
	print("## -- Wrapping SUT to FMU --------------------------------------------------")
	os.chdir(os.path.join(context, "sut", "SUT"))
	print("## Compiling sample SUT implementation in '{0}'".format(os.getcwd()))
	if 0 != os.system(" ".join([PROG_make,"all"])):
		raise NameError("Make Failed!")
	print("## Creating RTT_TestProcedures/SUT as wrapper to the modelDescription.xml that fits to SUT".format(os.getcwd()))
	os.chdir(context)
	if not py(" ".join([PROG_wrap, "--model-description", os.path.join(context, "RTT_TestProcedures", "Simulation", "model", "modelDescription.xml"), "RTT_TestProcedures/SUT"])):
		raise NameError("Wrapping of SUT failed")
	print("## -- Modifying test procedure...")
	append_to_file("""
// -- Added for SUT inclusion -----
CFLAGS	; -I$(RTT_TESTCONTEXT)/sut/SUT
INCLUDE ; fcu_sut.h
LDPATH	; -L$(RTT_TESTCONTEXT)/sut/SUT
LDFLAGS ; -lfcu_sut
// --------------------------------
""", os.path.join(context, "RTT_TestProcedures", "SUT", "conf", "swi.conf"))
	define_sut_in_rts("""
@abstract machine sut()
{					   
	@INIT:{			   
		fprintf(stderr, "CALL SUT INIT\\n");
		sut_init();						   
	}									   
	@FINIT:{							   
		//
	}
	@PROCESS:{
		double RATSP;
		double OAT;
		// output
		double RAT_out;

		fprintf(stderr, "STARTING SUT PROCESS\\n");

		while(@rttIsRunning){
			/* Map FMU input variables to SUT: X = rttIOPre->X */
			RATSP = rttIOPre->RATSP;
			OAT = rttIOPre->OAT;

			sut_run(OAT, RATSP, &RAT_out);

			/* Map SUT output to FMU output: rttIOPost->X = X */
			rttIOPost->RAT_out = RAT_out;

			@rttWaitSilent(1 _ms);
		}
	}
}
int ti_gettimeofday(struct timeval *tv, struct timezone *tz){
	tv->tv_sec	= @t / 1000;		  
	tv->tv_usec = (@t % 1000) * 1000;
	return 0; 
}
""", os.path.join(context, "RTT_TestProcedures", "SUT", "specs", "fmi2sut.rts"))
	print("## Building Executable")
	if not py(" ".join([PROG_build, "RTT_TestProcedures/SUT"])):
		raise NameError("Building of SUT failed")

	print "Success: RTT_TestProcedures/SUT can now be used as FMU"

## ###############################################
## [1.2] SUT CREATION: FCU Controller
## ###############################################
def wrap_SUT_fcu_ctrl():
	print("## -- Wrapping FCU Controller to FMU --------------------------------------------------")
	os.chdir(os.path.join(context, "sut", "SUT_with_roomwall"))
	print("## Compiling sample SUT_FCU_Ctrl implementation in '{0}'".format(os.getcwd()))
	if 0 != os.system(" ".join([PROG_make,"all"])):
		raise NameError("Make Failed!")
	print("## Creating RTT_TestProcedures/SUT_FCU_Ctrl as wrapper to the modelDescription.xml that fits to SUT : '{0}'".format(os.getcwd()))
	os.chdir(context)
	
	print("## Copying modified interface to RTT_TestProcedures/SUT_FCU_Ctrl/fmi and inc")
	fcu_sut_src_dir = os.path.join(context, "sut", "SUT_with_roomwall")
	fcu_tpdir = os.path.join(context, "RTT_TestProcedures","SUT_FCU_Ctrl")
	fmidir = os.path.join(context, "RTT_TestProcedures","SUT_FCU_Ctrl","fmi")
	sim_fmidir = os.path.join(context, "RTT_TestProcedures","Simulation", "fmi")
	fcu_tp_incdir = os.path.join(fcu_tpdir, "inc")
		
	try:
		mkdir_p(fmidir)
	except:
		print("## fail to create RTT_TestProcedures/SUT_FCU_Ctrl/fmi")

	try:
		mkdir_p(fcu_tp_incdir)
	except:
		print("## fail to create RTT_TestProcedures/SUT_FCU_Ctrl/inc")
		
	try:
		testdatadir = os.path.join(context, "RTT_TestProcedures","SUT_FCU_Ctrl","testdata")
		mkdir_p(testdatadir)
	except:
		print("## fail to create RTT_TestProcedures/SUT_FCU_Ctrl/testdata")

	cp_f(os.path.join(sim_fmidir, "*.c"), fmidir)
	cp_f(os.path.join(sim_fmidir, "*.h"), fmidir)
	cp_f(os.path.join(sim_fmidir, "*.rts"), fmidir)
	print "## copy from {0} to {1}".format(os.path.join(fcu_sut_src_dir, "fmi", "fmi*"), fmidir)
	cp_f(os.path.join(fcu_sut_src_dir, "fmi", "fmi*"), fmidir)
	cp_f(os.path.join(fcu_sut_src_dir, "fmi", "Makefile"), fmidir)
	print "## copy from {0} to {1}".format(os.path.join(fcu_sut_src_dir, "fmi", "rtt*"), fcu_tp_incdir)
	cp_f(os.path.join(fcu_sut_src_dir, "fmi", "rtt*"), fcu_tp_incdir)
	
	if not py(" ".join([PROG_wrap, "--model-description", os.path.join(fcu_sut_src_dir, "fcu_modelDescription.xml"), "RTT_TestProcedures/SUT_FCU_Ctrl"])):
		raise NameError("Wrapping of SUT failed")
	
	print("## -- Modifying test procedure...")
	append_to_file("""
// -- Added for Ether inclusion -----
CFLAGS	; -I$(RTT_TESTCONTEXT)/sut/SUT_with_roomwall/
INCLUDE ; fcu_sut.h
LDPATH	; -L$(RTT_TESTCONTEXT)/sut/SUT_with_roomwall/
LDFLAGS ; -lfcu_sut
//CFLAGS ; -g -ggdb -Wall
// --------------------------------
""", os.path.join(context, "RTT_TestProcedures", "SUT_FCU_Ctrl", "conf", "swi.conf"))
	define_sut_in_rts("""
@abstract machine sut()
{					   
	@INIT:{			   
		fprintf(stderr, "CALL SUT INIT\\n");
		sut_init();						   
	}									   
	@FINIT:{							   
		//
	}
	@PROCESS:{
		double RATSP;
		double RAT;
		double valveopen;
		double fanspeed;

		fprintf(stderr, "STARTING SUT PROCESS\\n");

		while(@rttIsRunning){
			/* Map FMU input variables to SUT: X = rttIOPre->X */
			RATSP = rttIOPre->RATSP;
			RAT = rttIOPre->RAT;

			sut_run(RAT, RATSP, &fanspeed, &valveopen);

			/* Map SUT output to FMU output: rttIOPost->X = X */
			rttIOPost->fanspeed = fanspeed;
			rttIOPost->valveopen = valveopen;

			@rttWaitSilent(1 _ms);
		}
	}
}
int ti_gettimeofday(struct timeval *tv, struct timezone *tz){
	tv->tv_sec	= @t / 1000;		  
	tv->tv_usec = (@t % 1000) * 1000;
	return 0; 
}
""", os.path.join(context, "RTT_TestProcedures", "SUT_FCU_Ctrl", "specs", "fmi2sut.rts"))

	print("## Copying modified interface to RTT_TestProcedures/SUT_FCU_Ctrl/fmi and inc again to make sure wrapper won't override them")
	print "## copy from {0} to {1}".format(os.path.join(fcu_sut_src_dir, "fmi", "fmi*"), fmidir)
	### don't override fmiInterface.h again. Otherwise, the FMI2_MODEL_GUID defined would be modified and won't match with that in dll
	### Finally, it causes fmi2SharedMemoryAttach error since the shm_name used to attach is different from that created shm_name
	### 	logRtTester OK fmu1 MDBG: fmi2SharedMemoryAttach(shm_name=/f06a225e-0a48-11e7-971e-08002748929)
	### 	logRtTester OK fmu1 fmi2SharedMemoryAttach: Error in OpenFileMapping(): returned 0: GetLastErr(): 2
	#cp_f(os.path.join(fcu_sut_src_dir, "fmi", "fmi*"), fmidir)
	cp_f(os.path.join(fcu_sut_src_dir, "fmi", "Makefile"), fmidir)
	print "## copy from {0} to {1}".format(os.path.join(fcu_sut_src_dir, "fmi", "rtt*"), fcu_tp_incdir)
	cp_f(os.path.join(fcu_sut_src_dir, "fmi", "rtt*"), fcu_tp_incdir)
	
	## Problem: connections for FMU wrapped in RTT and FMU from others (20-sim)
	##    input and output variables in RTT starting with IMR., such as IMR.valveopen
	## but input and output variables from others starting with name directly, such as valveopen
	## how to connect them together???
	
	## change to the name below in rtt-mbt-fmi2-wrap-to-fmu.py
	##     name = name.replace("IMR_", "")
	## If name starts with "IMR.v", then remove "IMR." to "v". Otherwise, just keep it as original "v"
	print("## Building Executable")
	if not py(" ".join([PROG_build, "RTT_TestProcedures/SUT_FCU_Ctrl"])):
		raise NameError("Building of SUT_FCU_Ctrl failed")

	print "Success: RTT_TestProcedures/SUT_FCU_Ctrl can now be used as FMU"
	

## ###################################################################
## MAIN
## ###################################################################

usage = """init-prj.py

Project-specific intialisation that build most relevant files, starting
with model import.

"""
__version__ = "$Revision: 1.1.2.5 $".replace("$", "")

parser = OptionParser(usage=usage, version=__version__)
(options, args) = parser.parse_args()


if len(args) != 0:
	sys.stderr.write("ERROR: init-prj.py: surplus number of arguments\n")
	print usage
	sys.exit(0)

context = os.path.realpath(os.path.join(os.path.realpath(__file__), "..", ".."))

os.environ['RTT_TESTCONTEXT'] = context

print "Using RTT_TESTCONTEXT=" + context

try:
	print("## -- Building SUT ---------------------------------------------------------")
	print("## -- Backup specs/fmi2rttInterface.rts -----------------------------------")
	shutil.copyfile(os.path.join(context,"specs","fmi2rttInterface.rts"), os.path.join(context,"specs","fmi2rttInterface.rts.tp00"))

	print("## -- Wrapping SUTs to FMUs --------------------------------------------------")
	os.chdir(context)
	#wrap_SUT()
	wrap_SUT_fcu_ctrl()

except:
	print "!! "
	print "!! Creating of SUT-FMU failed, use 'Simulation' for your experiments."
	print "!! "

print("## -- Restore specs/fmi2rttInterface.rts -----------------------------------")
shutil.move(os.path.join(context,"specs","fmi2rttInterface.rts.tp00"), os.path.join(context,"specs","fmi2rttInterface.rts"))

print """
----------------------------------------------------------------------
   Project Initialisation Finished: FCU_SUT
----------------------------------------------------------------------
"""

