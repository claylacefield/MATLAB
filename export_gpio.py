
import h5py, sys, argparse

parser = argparse.ArgumentParser(description="Convert raw gpio data.")
parser.add_argument ( "--original-timestamps", help=
    """Don't normalize timestamps.  This option causes timestamps to be
       output as the original system time when captured.
    """,
    action="store_true", dest="ots")

parser.add_argument ( "--sync", help="Output the sync signal", action="store_true") 
parser.add_argument ( "--trigger", help="Output the trigger signal", action="store_true") 
parser.add_argument ( "--io1", help="Output the gpio1 signal", action="store_true") 
parser.add_argument ( "--io2", help="Output the gpio2 signal", action="store_true") 

parser.add_argument ( "gpio_file", help="The gpio file to convert." )
parser.add_argument ( "txt_file", help="Output file to store results." )

args = parser.parse_args()

f=h5py.File( args.gpio_file, 'r' )

o=open(args.txt_file,'w')

if not args.sync and not args.trigger and not args.io1 and not args.io2:
    parser.print_help()
    print "At least one of sync, trigger, io1 or io2 should be selected."
    sys.exit(1)

# header
o.write ( "frame, time" ) #sync, trigger, io1, io2\n" )
if args.sync:
    o.write ( ", sync" )
if args.trigger:
    o.write ( ", trigger" )
if args.io1:
    o.write ( ", io1" )
if args.io2:
    o.write ( ", io2" )
o.write ( "\n" )

firsttime = f['timestamp'][0]
lastcacheline = "" 
for i,frame in enumerate(f['frame']):
    basetime = f['timestamp'][i]
    for j in range(f['anc_data_count'][i]):
        sample=f['anc_data'][i][j] 
        # for subsamples per sample
        for l in range(4):
            io1 = sample & 1 
            sample >>= 1
            io2 = sample & 1
            sample >>= 1
            sync = sample & 1
            sample >>= 1
            trigger = sample & 1
            sample >>= 1
            sampletime=basetime
            if not args.ots:
                sampletime = sampletime - firsttime

            cacheline = "%d" % frame
            if args.sync:
                cacheline += " %d" % sync
            if args.trigger:
                cacheline += ", %d" % trigger
            if args.io1:
                cacheline += ", %d" % io1
            if args.io2:
                cacheline += ", %d" % io2
 
            if cacheline != lastcacheline:
                o.write ( "%d, %0.4f" %
                    (frame,
                    sampletime) )
                if args.sync:
                    o.write ( ", %d" % sync )
                if args.trigger:
                    o.write ( ", %d" % trigger )
                if args.io1:
                    o.write ( ", %d" % io1 )
                if args.io2:
                    o.write ( ", %d" % io2 )
                o.write ( "\n" )
            lastcacheline = cacheline
            basetime += .001 # 1ms sample interval


