#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

# Correctness
@test 'assert_equal_files() <file>: returns 0 if <file1> and <file2> are the same' {
  local -r file1="${TEST_FIXTURE_ROOT}/dir/file_with_text"
  local -r file2="${TEST_FIXTURE_ROOT}/dir/same_file_with_text"
  run assert_equal_files "$file1" "$file2"
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}


@test 'assert_equal_files() <file>: returns 1 if <file1> and <file2> are not the same' {
  local -r file1="${TEST_FIXTURE_ROOT}/dir/same_file_with_text"
  local -r file2="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_equal_files "$file1" "$file2"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- files are not the same --' ]
  [ "${lines[1]}" == "path : $file" ]
  [ "${lines[2]}" == '--' ]
}

# Transforming path
@test 'assert_equal_files() <file>: used <file2> as a directory' {
  local -r file2="${TEST_FIXTURE_ROOT}/dir/same_file_with_text"
  local -r file1="${TEST_FIXTURE_ROOT}/dir"
  run assert_equal_files "$file1" "$file2"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 4 ]
  [ "${lines[0]}" == "cmp: ${TEST_FIXTURE_ROOT}/dir: Is a directory" ]
  [ "${lines[1]}" == "-- files are not the same --" ]
  [ "${lines[2]}" == 'path : ' ]
}

@test 'assert_equal_files() <file>: replace suffix of displayed path' {
  local -r file1="${TEST_FIXTURE_ROOT}/dir/file_with_text"
  local -r file2="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_equal_files "${TEST_FIXTURE_ROOT}/dir"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- files are not the same --' ]
  [ "${lines[1]}" == "path : " ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_equal_files() <file>: replace infix of displayed path' {
  local -r file1="${TEST_FIXTURE_ROOT}/dir/file_with_text"
  local -r file2="${TEST_FIXTURE_ROOT}/dir/same_file_with_text"
  run assert_equal_files "${TEST_FIXTURE_ROOT}/dir"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- files are not the same --' ]
  [ "${lines[1]}" == "path : " ]
  [ "${lines[2]}" == '--' ]
}
