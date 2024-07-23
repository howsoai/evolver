#!/bin/bash

# Function to handle termination signals
cleanup() {
  echo "Caught termination signal. Cleaning up..."
  # Perform any cleanup tasks here
  exit 0
}

# Trap termination signals
trap cleanup SIGINT SIGTERM

# Create the GDB command file
cat <<EOF > gdb_commands.gdb
set pagination off
run
thread apply all bt
EOF

# Run the program with a timeout and attach GDB to print the backtrace if it hangs
timeout --preserve-status -s SIGINT 240 gdb -batch -x gdb_commands.gdb --args ./amalgam-mt --debug-internal-memory tic_tac_toe_evolver.amlg -target-time 180 &> logs.txt

# Display the last 100 lines of the GDB output
tail -n 100 logs.txt
