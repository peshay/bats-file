#!/usr/bin/env bats

load 'test_helper'

TEST_TEMP_DIR="$(temp_make)"

@test 'at least 1 test to run' {
    true
}