# set debug tui
python

def command_window_facotry(name, cmd): 
    class CommandWindow:
        def __init__(self, tui_window):
            self._tui_window = tui_window
            self._tui_window.title = name

            self._before_prompt_listener = lambda : self._before_prompt()
            gdb.events.before_prompt.connect(self._before_prompt_listener)

        def fetch_cmd(self):
            try:
                return gdb.execute(cmd, from_tty=True, to_string=True)
            except:
                return None

        def _before_prompt(self):
            self.render()

        def render(self):
            self._tui_window.erase()
            output = self.fetch_cmd()
            if(output):
                self._tui_window.write(self.fetch_cmd())
    return CommandWindow

variables_window = command_window_facotry("Variables", "info locals")
breakpoints_window = command_window_facotry("Breakpoints", "info breakpoints")
threads_window = command_window_facotry("Threads", "info threads")
bt_window = command_window_facotry("Stacktrace", "bt")

gdb.register_window_type('breakpoints', breakpoints_window)
gdb.register_window_type('variables', variables_window)
gdb.register_window_type('threads', threads_window)
gdb.register_window_type('bt', bt_window)

end

# Better GDB defaults

set history save
set verbose off
set print pretty on
set print array off
set print array-indexes on
set python print-stack full

# Dispaly Configuration
 
tui enable
tui new-layout dashboard {-horizontal src 1 variables 1} 2 {-horizontal breakpoints 1 threads 1} 1 { -horizontal cmd 1 bt 1} 1 

set style tui-active-border foreground green
set style tui-border foreground none

layout dashboard

