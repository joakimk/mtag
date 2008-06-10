@echo off
REM This is needed for ruby to find the spec command on windows :(
REM Would really like to remove this hack.
spec %*
