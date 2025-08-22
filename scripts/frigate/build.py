from super_gradients.common.object_names import Models
from super_gradients.conversion import DetectionOutputFormatMode
from super_gradients.training import models

model = models.get(Models.YOLO_NAS_S, pretrained_weights="coco")


# export the model for compatibility with Frigate

model.export("yolo_nas_s.onnx",
             output_predictions_format=DetectionOutputFormatMode.FLAT_FORMAT,
             max_predictions_per_image=20,
             num_pre_nms_predictions=300,
             confidence_threshold=0.4,
             input_image_shape=(320,320),
            )


# from google.colab import files

# files.download('yolo_nas_s.onnx')
