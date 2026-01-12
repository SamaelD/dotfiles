#!/bin/sh

free -m | awk '/Swap/ { if ($2 > 0) printf "%.0f\n", $3*100/$2; else print 0 }'
