#!/bin/bash

# https://github.com/patriciogonzalezvivo/glslViewer/wiki/Interacting-with-GlslViewer

# load shaders ./ccprogram.vert ./ccprogram.frag
# load mesh ./mesh/cube.gltf
# load texture in uniform order

glslviewer \
    -C ./skybox/default.hdr \
    ./ccprogram.vert \
    ./ccprogram.frag \
    ./mesh/plane/plane.gltf \
    -mainTexture ./texture/main.png \
    -maskTexture ./texture/mask.png \
    -noiseTexture ./texture/noise.png \
    -e define,PLATFORM_OSX \
    -e define,DEBUG,on \
    -e define,MODEL_VERTEX_TEXCOORD \
    -e define,MATERIAL_ILLUM,4 \
    -e define,MATERIAL_TRANSMITTANCE,0.0,0.0,0.0 \
    --verbose
