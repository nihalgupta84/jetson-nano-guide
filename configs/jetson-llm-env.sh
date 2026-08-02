# Source this file when working with the reproducible Nano LLM stack.
export PATH=/data/cmake-3.22.6/bin:/data/gcc-8.5/bin:/usr/local/cuda-10.2/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:${LD_LIBRARY_PATH:-}
export LLAMA_CPP_HOME=/data/llama.cpp
export JETSON_MODEL_HOME=/data/models
