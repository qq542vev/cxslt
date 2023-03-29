#!/bin/sh

for file in `cat ~/files`; do

	mm=`grep -E -o 'cxsltl:[a-zA-Z0-9]+?\.[a-zA-Z0-9.]+?' ${file} | sed -E 's/\.[a-zA-Z0-9]+$//g' | sort | uniq`

	echo "# " ${file}

	grep -E -o 'cxsltl:[a-zA-Z0-9]+?\.[a-zA-Z0-9.]+?' ${file} | sed -E 's/\.[a-zA-Z0-9]+$//g' | sort | uniq
	grep '<xsl:import' ${file}

	grep -E -o 'cxsltl:[a-zA-Z0-9]+?\.[a-zA-Z0-9.]+?' ${file} | sed -E 's/\.[a-zA-Z0-9]+$//g' | sort | uniq | wc -l
	grep '<xsl:import' ${file} | wc -l

	echo
done