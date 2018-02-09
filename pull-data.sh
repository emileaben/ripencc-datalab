#!/usr/bin/env bash

#set -x

DATECMD=date

function print_banner
{
	script_fn=$1

	echo "$script_fn"
	echo "A RIPE NCC raw data downloader script"
	echo "Source: https://github.com/emileaben/ripencc-datalab"
	echo ""
}

function print_help
{
	echo "The tool takes the following options:"
	echo "  -d <date>	Day to pull data for. The default is \"yesterday\"."
	echo "  -n		Just for fun, run some local connecticity tests."
	echo "  -o /output/directory"
	echo "  -h		Print this helpful message"
	echo ""
	echo "The following sources are used for the raw data:"
	echo ""
	echo "1. RIPE Atlas results"
	echo "   https://data-store.ripe.net/datasets/atlas-daily-dumps/YYYY-MM-DD/TYPE-YYYY-MM-DDTHH00.bz2"
	echo ""
	echo "2. RIPE Atlas metadata"
	echo "   https://ftp.ripe.net/ripe/atlas/probes/archive/YYYY/MM/YYYYMMDD.json.bz2"
	echo "   https://ftp.ripe.net/ripe/atlas/measurements/meta-YYYYMMDD.txt.bz2"
	echo ""
	echo "3. OpenIPMap data"
	echo "   https://ftp.ripe.net/ripe/openipmap/geolocations_YYYY-MM-DD.csv.bz2"
	echo ""
	echo "4. RIS BGP data"
	echo "   http://data.ris.ripe.net/rrc{00..21}/YYYY.MM/bview.YYYYMMDD.hh00.gz"
	echo ""
	echo "5. Atlas disconnections"
	echo "   https://atlas.ripe.net/api/v2/measurements/7000/results/?start=START_TS&stop=END_TS&format=json"
	echo ""
#	echo "6. IXP Country Jedi results"
#	echo ""
#	echo "7. RIPEStat"
#	echo ""
}

function setup_env
{
	osname=`uname -a`
	case "$osname" in
	Darwin*)
		# just assume coreutils is installed
		DATECMD=gdate
		;;
	Linux*)
		DATECMD=date
		;;
	*)
		# consider bailing out
		;;
	esac
}

function create_dirs_or_bail
{
	dir=$1

	if [ -e $dir ] && [ ! -d $dir ]
	then
		echo "ERROR: $dir is not a directory; bailing."
		exit 1
	elif [ ! -e $dir ]
	then
		mkdir -p $dir
		if [ $? -ne 0 ]
		then
			echo "ERROR: Could not create $dir; bailing."
			exit 1
		fi
	fi
}

function net_tests
{
	echo ""
	echo "Running a couple of IPv6 tests"
	dns_response=`host -t aaaa ipv6-test.ripe.net`
	echo $dns_response | grep -q "has IPv6 address"
	if [ $? -eq 0 ]
	then
		echo " AAAA resolution works!"

		curl -s6 'https://ipv6-test.ripe.net/ok_small.png' > /dev/null
		if [ $? -eq 0 ]
		then
			echo " HTTPS fetch of small object works"
		fi

		curl -s6 --max-time 1 'https://ipv6-test.ripe.net/ok.png' > /dev/null
		if [ $? -eq 0 ]
		then
			echo " HTTPS fetch of larger object works"
		fi
	fi

	echo ""
	echo "Running a couple of IPv4 tests"
	dns_response=`host -t a ipv4-test.ripe.net`
	echo $dns_response | grep -q "has address"
	if [ $? -eq 0 ]
	then
		echo " A resolution works!"

		curl -s4 'https://ipv4-test.ripe.net/ok_small.png' > /dev/null
		if [ $? -eq 0 ]
		then
			echo " HTTPS fetch of small object works"
		fi
		curl -s4 'https://ipv4-test.ripe.net/ok.png' > /dev/null
		if [ $? -eq 0 ]
		then
		echo " HTTPS fetch of larger object works"
		fi
	fi
}



function fetch_atlas_measurement_data
{
	d=$1
	dir=$2

	echo ""
	echo "------------------------------"
	echo "Fetching Atlas measurement data for $d"

	for type in dns http ntp ping sslcert traceroute
	do
		for hour in `seq -w 0 23`
		do
			url="https://data-store.ripe.net/datasets/atlas-daily-dumps/$d/$type-${d}T${hour}00.bz2"
			out_fn="$dir/$type-${d}T${hour}00.bz2"
			echo "--> $url"
			curl --progress-bar $url > $out_fn
		done
	done
}

function fetch_atlas_metadata
{
	d=$1
	dir=$2

	echo ""
	echo "------------------------------"
	echo "Fetching Atlas metadata for $d"

	yyyy=`$DATECMD --date "$d" +%Y`
	mm=`$DATECMD --date "$d" +%M`
	yyyymmdd=`$DATECMD --date "$d" +%Y%M%d`


	url="https://ftp.ripe.net/ripe/atlas/probes/archive/$yyyy/$mm/$yyyymmdd.json.bz2"
	out_fn="$dir/probes-$yyyymmdd.json.bz2"
	echo "--> $url"
	curl --progress-bar $url > $out_fn

	url="https://ftp.ripe.net/ripe/atlas/measurements/meta-$yyyymmdd.txt.bz2"
	out_fn="$dir/meta-$yyyymmdd.txt.bz2"
	echo "--> $url"
	curl --progress-bar $url > $out_fn
}

function fetch_ris_data
{
	d=$1
	dir=$2

	echo ""
	echo "------------------------------"
	echo "Fetching RIS data for $d"

	# There is rrc00 -- rrc21, active on different dates. Some are retired,
	# but the script will try to pull the three RIBs for each date.
	for rrc in `seq -w 0 21`
	do
		yyyy=`$DATECMD --date "$d" +%Y`
		mm=`$DATECMD --date "$d" +%m`
		yyyymmdd=`$DATECMD --date "$d" +%Y%m%d`

		for ts in 0000 0800 1600
		do
			url="http://data.ris.ripe.net/rrc${rrc}/${yyyy}.${mm}/bview.${yyyymmdd}.$ts.gz"
			out_fn=$dir/rrc${rrc}.bview.${yyyymmdd}.$ts.gz
			curl -sI $url | grep -q "200 OK"
			if [ $? -eq 0 ]
			then
				echo "--> $url"
				curl --progress-bar $url > $out_fn
			fi
		done
	done
}

function fetch_openipmap_data
{
	d=$1
	dir=$2

	echo ""
	echo "------------------------------"
	echo "Fetching Atlas metadata for $d"

	yyyy=`$DATECMD --date "$d" +%Y`
	mm=`$DATECMD --date "$d" +%M`
	dd=`$DATECMD --date "$d" +%d`
	url="https://ftp.ripe.net/ripe/openipmap/geolocations_$yyyy-$mm-$dd.csv.bz2"
	out_fn="$dir/geolocations_$yyyy-$mm-$dd.csv.bz2"

	echo "--> $url"
	curl --progress-bar $url > $out_fn
}

function fetch_disconnect_data
{
	d=$1
	dir=$2

	echo ""
	echo "------------------------------"
	echo "Fetching Atlas disconnect data $d"

	begin_ts=`$DATECMD --date "$d"         +%s`
	end_ts=`  $DATECMD --date "$d + 1 day" +%s`
	url="https://atlas.ripe.net/api/v2/measurements/7000/results/?start=${begin_ts}&stop=${end_ts}&format=json"
	out_fn="$dir/disconnects-$d.json"

	echo "--> $url"
	curl -s $url > $out_fn
}

# set some defaults
outdir="data"
setup_env
d=`$DATECMD --date "yesterday" +"%Y-%m-%d"`

while getopts "d:no:h" opt
do

	case $opt in
	d)
		d="$OPTARG"
		;;
	n)
		net_tests
		exit 0
		;;
	o)
		outdir="$OPTARG"
		;;
	*)
		print_banner $0
		print_help
		exit 1
		;;
	esac

done


atlas_measurements_dir=$outdir/atlas/measurements
atlas_metadata_dir=$outdir/atlas/meta
ris_data_dir=$outdir/ris
openipmap_dir=$outdir/openipmap
disconnect_dir=$outdir/disconnects

echo ""
echo "Going to write data in $outdir"
echo ""

create_dirs_or_bail $atlas_measurements_dir
create_dirs_or_bail $atlas_metadata_dir
create_dirs_or_bail $ris_data_dir
create_dirs_or_bail $openipmap_dir
create_dirs_or_bail $disconnect_dir

fetch_atlas_measurement_data $d $atlas_measurements_dir
fetch_atlas_metadata         $d $atlas_metadata_dir
fetch_ris_data               $d $ris_data_dir
fetch_openipmap_data         $d $openipmap_dir
fetch_disconnect_data        $d $disconnect_dir

