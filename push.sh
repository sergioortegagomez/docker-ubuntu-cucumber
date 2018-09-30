#!/bin/bash
git push
git tag -f -a -m "update tag" latest 
git push -f --tags