import pynvim
import rime

@pynvim.plugin
class Frontend:
    def __init__(self, nvim):
        self.nvim = nvim
        self.nvim.exec_lua("_source = require('cmp_rime')")
        self.mod = self.nvim.lua._source

    @pynvim.function('RimeInit', sync=True)
    def initialize(self, args):
        rime.shared_data_dir = args[0]['shared_data_dir']      
        rime.user_data_dir = args[0]['user_data_dir']
        return rime.init(True)

    @pynvim.function('RimeGetCandidatesFromKeys')
    def get_candidates_from_keys(self, args):
        keys = args[0]
        max_candidates = args[1]
        cursor = args[2]
        context_id = args[3]
        candidates = rime.get_candidates_from_keys(keys, max_candidates)
        if candidates is None:
            self.mod._callback(context_id, None)
        else:
            items = []
            for candidate in candidates:
                item = {
                    'label': candidate['text'],
                    'filterText': keys,
                    'sortText': f"{candidate['order']:08d}",
                    'kind': 1,
                    'textEdit': {
                        'newText': candidate['text'],
                        'range': {
                            'start': {
                                'line': cursor['row'] - 1,
                                'character': cursor['col'] - len(keys)
                            },
                            'end': {
                                'line': cursor['row'] - 1,
                                'character': cursor['col'] - 1
                            }
                        }
                    }
                }
                items.append(item)
            self.mod._callback(context_id, items)
