from powerline.segments import Segment, with_docstring
from powerline.theme import requires_segment_info, requires_filesystem_watcher
from os import environ, path

TOMATO='🍅'

def get_minutes_remaining() -> str:
    pomo_path = environ['HOME'] + '/.local/share/fish/fish_pomo'
    if path.exists(pomo_path):
        with open(pomo_path, 'r') as f:
            return TOMATO + f.readline().split()[0] + 'm'
    else:
        return 'None'

@requires_filesystem_watcher
@requires_segment_info
class PomoSegment(Segment):
  divider_highlight_group = None

  def __call__(self, pl, segment_info, create_watcher):
    return [{
      'contents': get_minutes_remaining(),
      'highlight_groups': ['information:regular'],
      }]

pomo = with_docstring(PomoSegment(), '''Return a segment that periodically checks a pomodoro timer file.''')
