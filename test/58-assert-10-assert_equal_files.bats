#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

# Correctness
@test 'assert_files_equal() <file>: returns 0 if <file1> and <file2> are the same' {
  local -r file1="${TEST_FIXTURE_ROOT}/dir/file_with_text"
  local -r file2="${TEST_FIXTURE_ROOT}/dir/same_file_with_text"
  run assert_files_equal "$file1" "$file2"
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}


@test 'assert_files_equal() <file>: returns 1 if <file1> and <file2> are not the same' {
  local -r file1="${TEST_FIXTURE_ROOT}/dir/same_file_with_text"
  local -r file2="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_files_equal "$file1" "$file2"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 4 ]
  [ "${lines[0]}" == '-- files are not the same --' ]
  [ "${lines[1]}" == "path : $file1" ]
  [ "${lines[2]}" == "path : $file2" ]
}

# Transforming path
@test 'assert_files_equal() <file>: used <file2> as a directory' {
  local -r file2="${TEST_FIXTURE_ROOT}/dir/same_file_with_text"
  local -r file1="${TEST_FIXTURE_ROOT}/dir"
  run assert_files_equal "$file1" "$file2"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 5 ]
  [ "${lines[0]}" == "cmp: ${TEST_FIXTURE_ROOT}/dir: Is a directory" ]
  [ "${lines[1]}" == "-- files are not the same --" ]
  [ "${lines[2]}" == "path : $file1" ]
}

@test 'assert_files_equal() <file>: replace suffix of displayed path' {
  local -r file1="${TEST_FIXTURE_ROOT}/dir/file_with_text"
  local -r file2="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_files_equal "$file1" "$file2"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 4 ]
  [ "${lines[0]}" == '-- files are not the same --' ]
  [ "${lines[1]}" == "path : $file1" ]
  [ "${lines[2]}" == "path : $file2" ]
}

@test 'assert_files_equal() <file>: replace infix of displayed path' {
  local -r file1="${TEST_FIXTURE_ROOT}/dir/file_with_text"
  local -r file2="${TEST_FIXTURE_ROOT}/dir"
  local -r BATSLIB_FILE_PATH_REM1="$file1"
  local -r BATSLIB_FILE_PATH_ADD1='..'
  local -r BATSLIB_FILE_PATH_REM2="$file2"
  local -r BATSLIB_FILE_PATH_ADD2='..'
  run assert_files_not_equal "$file1" "$file2"
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" == "cmp: ${TEST_FIXTURE_ROOT}/dir: Is a directory" ]
}
