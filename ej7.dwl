%dw 2.0
import * from dw::core::Arrays
output application/json
var raw_commands = payload splitBy '\$ ' filter $ != ""
var commands = raw_commands map do {
    var lines = $ splitBy '\n'
    var command = lines[0] splitBy ' '
    ---
    if (command[0] == 'cd')
        {
            name: 'cd',
            destination: command[1]
        }
    else
        {
            name: 'ls',
            files: lines[1 to -1]
                map ($ splitBy ' ')
                map {
                    name: $[1],
                    size: if ($[0] == 'dir') 0 else $[0] as Number,
                    is_dir: $[0] == 'dir'
                    }
        }
}
var run_command = (command, known_state) ->
    if (command.name == 'cd')
        known_state update {
            case cwd at .cwd ->
                if (command.destination == '/') []
                else if (command.destination == '..') cwd[0 to -2] default []
                else cwd ++ [command.destination]
        }
    else
        known_state update {
            case files at .files ->
                command.files map {
                    name: known_state.cwd ++ [$.name],
                    size: $.size,
                    is_dir: $.is_dir
                } ++ files
        }
var files = (([{ cwd: [], files: [] }] ++ commands) reduce ($ run_command $$)).files
var dir_size = (dir_name) ->
    files
    filter $.name[0 to sizeOf(dir_name)-1] == dir_name
    sumBy $.size
var total = 70000000
var used = files sumBy $.size
var free = total - used
var should_free = 30000000 - free
---
{
    exercise_a:
        files
        filter $.is_dir
        map dir_size($.name)
        filter $ <= 100000
        sumBy $,

    used: used,
    free: total - used,
    should_free: should_free,
    exercise_b:
        files
        filter $.is_dir
        map { name: $.name joinBy '/', size: dir_size($.name) }
        filter $.size >= should_free
        orderBy $.size
        map $.size
        firstWith true
}
