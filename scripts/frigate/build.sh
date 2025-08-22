# dnf install -y cmake gcc-c++ freetype freetype-devel protobuf-devel

# python3 -m virtualenv venv2
source venv2/bin/activate

# 2. Upgrade pip
# pip install --upgrade pip


pip install git+https://github.com/Deci-AI/super-gradients.git


# sed -i 's/sghub.deci.ai/sg-hub-nv.s3.amazonaws.com/' /usr/local/lib/python3.11/dist-packages/super_gradients/training/pretrained_models.py
# sed -i 's/sghub.deci.ai/sg-hub-nv.s3.amazonaws.com/' /usr/local/lib/python3.11/dist-packages/super_gradients/training/utils/checkpoint_utils.py



## Temp

# 3. Install yolonas via super-gradients (official package)
# pip install super-gradients

# 4. OPTIONAL: install extra packages if needed (e.g., jupyter, opencv)
# pip install jupyter opencv-python

docker run -i -t --gpus all -v $(pwd):/repo -w /repo --entrypoint= ghcr.io/blakeblackshear/frigate:stable-tensorrt bash

apt update

apt install -y git

sed -i 's/sghub.deci.ai/sg-hub-nv.s3.amazonaws.com/' ./venv2/lib/python3.11/site-packages/super_gradients/training/pretrained_models.py
sed -i 's/sghub.deci.ai/sg-hub-nv.s3.amazonaws.com/' ./venv2/lib/python3.11/site-packages/super_gradients/training/utils/checkpoint_utils.py

python3 build.py
