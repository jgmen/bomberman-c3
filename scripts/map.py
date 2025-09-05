import numpy as np

# Mapa ASCII (25 linhas x 60 colunas), removendo J e E
ascii_map = [
"WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",
"W                 W                                        W",
"W                         D    W                           W",
"W                                              D       D   W",
"W    K W   B                                  D            W",
"W        D             D                  K                W",
"W                      D                                   W",
"W                   0                                      W",
"W   B0                         D       D                   W",
"W        K           D                        K     K      W",
"W                              W                 D         W",
"W                             D                            W",
"W          W                                             D W",
"W      D     D                                             W",
"W            D        D    0    B         D                W",
"W         D   W  0                                   B     W",
"W W                                                        W",
"W            DD    D              W                        W",
"W                 B                                        W",
"W                                       W    B             W",
"W  B                              D       W           D    W",
"W  D                                           B        D  W",
"W          0                           B             D     W",
"W  B                                   D              D D  W",
"WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
]

# Mapeamento ASCII \u2192 enum Block
block_map = {' ':0,'W':1,'D':2,'K':3,'B':2,'0':0}  # '0' � player/enemy

# Converter para array linear de bytes
flat_map = np.array([block_map[c] for line in ascii_map for c in line], dtype=np.uint8)

# Salvar como arquivo bin�rio
flat_map.tofile("stage_1.bin")
print("Arquivo stage_1.bin gerado com 1500 bytes!")
