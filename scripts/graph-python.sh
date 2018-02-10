#!/bin/bash

sfood pocha/ $@ | sfood-graph  | dot -Tsvg  


