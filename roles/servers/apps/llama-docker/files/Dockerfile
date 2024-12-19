FROM

curl -fsSL https://ollama.com/install.sh | sh
ollama run mistral

sudo apt update && sudo apt install git g++ wget build-essential

git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make -j
cd models
wget https://huggingface.co/TheBloke/Mistral-7B-v0.1-GGUF/resolve/main/mistral-7b-v0.1.Q4_K_S.gguf)
cd ..
./main -m models/mistral-7b-v0.1.Q4_K_S.gguf -p "Whatsup?" -n 400 -e

ollama serve
ollama run llama3
ollama run llama3:8b
