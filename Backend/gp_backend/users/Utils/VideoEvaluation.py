import cv2
import mediapipe as mp
import numpy as np
import time
import torch
import math
from torchvision import transforms
from .Eye_contact import gaze
from .Head_movement.dectect import AntiSpoofPredict
import time
from .Head_movement.pfld import PFLDInference
import os
import joblib
import pandas as pd
from collections import Counter

# to remove warnings
import os
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'

script_dir = os.path.dirname(os.path.abspath(__file__))
checkpoint_dir = os.path.join(script_dir, 'Head_movement')
checkpoint_path = os.path.join(checkpoint_dir, 'checkpoint.pth.tar')

class VideoEvaluation():
    def __init__(self, video_path, frames_to_skip):
        """
        Initialize the VideoEvaluation class.

        Args:
            video_path (str): Path to the video file.
            frames_to_skip (int): Number of frames to skip during processing.
        """
        self.video_path = video_path
        self.frames_to_skip = frames_to_skip

        # head and eye movement related code
        self.model_path = checkpoint_path
        self.device_id = "which gpu id, [0/1/2/3]"
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        checkpoint = torch.load(self.model_path, map_location=self.device)
        self.plfd_backbone = PFLDInference().to(self.device)
        self.plfd_backbone.load_state_dict(checkpoint['plfd_backbone'])
        self.plfd_backbone.eval()
        self.transform = transforms.Compose([transforms.ToTensor()])
        self.total_duration = 0
        self.straight_duration = 0
        self.right_duration = 0
        self.left_duration = 0
        self.up_duration = 0
        self.down_duration = 0
        self.yaw_values = []
        self.pitch_values = []
        self.roll_values = []
        self.head_gaze_score=1
        self.eye_gaze_score=1
        self.gaze_ratio=0
        self.up_down_ratio=0
        # Initialize gaze direction arrays
        self.gaze_directions = []
        self.vertical_gazes = []

        # for detecting poses mediapipe
        self.mp_pose = mp.solutions.pose
        self.pose = self.mp_pose.Pose()
        self.mp_face_mesh = mp.solutions.face_mesh

        # poses and movement throughout the video
        self.poses = []
        self.movement_up = []
        self.movement_close = []
        
        # variables related to moving (change in dependance on the number of angles wanted in the end)
        self.pre_angles = [-1 for _ in range(2)]
        self.moving_thresh = 2

        # load pose classification model
        model_path = script_dir + '/Models/decision_tree_para_ean_tan.pkl'
        self.pose_classificaton_model = joblib.load(model_path)


    def run(self):
        try:
            self.process_frames()
            result = self.get_evaluation()
            return{
                'status_ok' : True,
                'data' : result
            }
        except Exception as e:
            print(type(e))
            return{
                'status_ok' : False,
                'error' : str(e)
            }
 
    def get_evaluation(self) -> dict:

        gesture_use_score = 0
        if((len(self.movement_up) + len(self.poses)) != 0):
            gesture_use_score = len(self.movement_up) * 100 / (len(self.movement_up) + len(self.poses))


        gesture_place_score = 0
        if(len(self.movement_up) != 0):
            gesture_place_score = self.movement_up.count(True) * 100 / len(self.movement_up)

        # percentage of time gestures where close to body
        gesture_close_percentage = 0
        if(len(self.movement_close) != 0):
            gesture_close_percentage = self.movement_close.count(True) * 100 / len(self.movement_close)

      
        good_poses_percentage = bad_poses_percentage_hoh = good_poses_percentage_hc = 0
        if(len(self.poses) != 0):
            good_poses_percentage = self.poses.count('RestUp') * 100 / len(self.poses)
            bad_poses_percentage_hoh = self.poses.count('HandsOnHips') * 100 / len(self.poses)
            good_poses_percentage_hc = self.poses.count('HandsCrossed') * 100 / len(self.poses)

        # Get head and eye gaze score
        self.head_pose_logic()
        self.eye_pose_logic()

        # get gesture use score
        gesture_use_score_rate = self.get_gesture_use_rating(gesture_use_score)

        eval_dict = {
            "gesture_use_score": gesture_use_score_rate,
            "gesture_place_score" : gesture_place_score,
            "gesture_close_percentage" : gesture_close_percentage,
            "good_poses_percentage": good_poses_percentage, 
            "bad_poses_percentage_hoh":bad_poses_percentage_hoh,
            "good_poses_percentage_hc" : good_poses_percentage_hc,
            "gaze_ratio_percentage": self.gaze_ratio,
            "up_down_ratio_percentage": self.up_down_ratio,
            "eye_gaze_score":self.eye_gaze_score,
            "head_gaze_score":self.head_gaze_score
        }
        return eval_dict
    
    def process_frames(self):
        no_person_start_time = None
        cap = cv2.VideoCapture(self.video_path)
        i = 0
        if not cap.isOpened():
            raise Exception("Couldn't open video file")
    
        with self.mp_face_mesh.FaceMesh(
                max_num_faces=1,
                refine_landmarks=True,
                min_detection_confidence=0.5,
                min_tracking_confidence=0.5) as face_mesh:
            prev_time = time.time()
            while cap.isOpened():
                ret, frame = cap.read()
                if not ret:
                    # enters here where it can notread any frames(probably reached end of file)
                    break

                if i % self.frames_to_skip == 0:
                    height, width = frame.shape[:2]
                    #process facelandmarks
                    prev_time = self.process_face_landmarks(frame, prev_time, width, height)

                    image_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                    image_rgb.flags.writeable = False

                    results_from_face_mesh = face_mesh.process(image_rgb)

                    image = cv2.cvtColor(image_rgb, cv2.COLOR_RGB2BGR)
                    
                    # process eye gaze
                    
                    if results_from_face_mesh.multi_face_landmarks:
                        image = self.process_eye_gaze(image, results_from_face_mesh)
                        
                            
                            
                    #pose process
                    results_from_pose = self.pose.process(image_rgb)

                    if results_from_pose.pose_landmarks:
                        features = self.get_features(results_from_pose)
                        is_moving = self.is_moving(features)
                        if is_moving:
                            is_movement_up = self.is_movement_up(features)
                            is_movement_close = self.is_movement_close(features)
                            self.movement_up.append(is_movement_up)
                            self.movement_close.append(is_movement_close)
                        else:
                            pose = self.classify_pose(features)
                            self.poses.append(pose)
                        no_person_start_time = None
                    else:
                        if no_person_start_time is None:
                            no_person_start_time = time.time()
                        else:
                            no_person_duration = time.time() - no_person_start_time
                            if no_person_duration >= 5:
                                raise Exception("There is no one in the video")

                i += 1

        cap.release()
        
    def is_moving(self, features) -> bool:
        # TODO test and check if it could be better
        features_to_get = ['wrists_and_neck', 'elbows_and_neck']
        angles = [features[key][0] for key in features_to_get]
        is_moving = False
        for i in range(2):
            dif = self.pre_angles[i] - angles[i]
            if(abs(dif) > self.moving_thresh):
                is_moving = True
        self.pre_angles = angles
        return is_moving
    
    def is_movement_up(self,features) -> bool:
        left , right = features['left_elbow_wrist_dist'][0], features['right_elbow_wrist_dist'][0]
        up_thresh = 0.075
        if left >= up_thresh and right >= up_thresh:
            return True
        return False
    
    def is_movement_close(self, features) -> bool:
        close_threshhold = 20
        angle1, angle2 = features['shoulder_elbow_right_2'][0], features['shoulder_elbow_left_2'][0]
        # print(angle1, angle2)
        if angle1 <= close_threshhold and angle2 <= close_threshhold:
            return True
        return False
    
    def classify_pose(self, features) -> str:
        features_df = pd.DataFrame({key: features[key] for key in ['elbows_and_neck', 'thumbs_and_neck']})
        predicted_pose = self.pose_classificaton_model.predict(features_df)[0]
        return predicted_pose
    
    def calculate_angle(self, p1, p2, p3):
        vector1 = p1 - p2
        vector2 = p3 - p2
        dot_product = np.dot(vector1, vector2)
        magnitude1 = np.linalg.norm(vector1)
        magnitude2 = np.linalg.norm(vector2)
        cos_angle = dot_product / (magnitude1 * magnitude2)
        cos_angle = np.clip(cos_angle, -1.0, 1.0)
        angle_rad = np.arccos(cos_angle)
        angle_deg = np.degrees(angle_rad)
        return angle_deg
    
    def convert_to_xy(self, tmp):
        return np.array([tmp.x, tmp.y])
    
    def get_features(self, results):
        # TODO: keep only final features
        right_shoulder = self.convert_to_xy(results.pose_landmarks.landmark[11])
        right_elbow = self.convert_to_xy(results.pose_landmarks.landmark[13])
        right_wrist = self.convert_to_xy(results.pose_landmarks.landmark[15])
        left_shoulder = self.convert_to_xy(results.pose_landmarks.landmark[12])
        left_elbow = self.convert_to_xy(results.pose_landmarks.landmark[14])
        left_wrist = self.convert_to_xy(results.pose_landmarks.landmark[16])
        neck = (right_shoulder+left_shoulder) / 2

        right_angle = self.calculate_angle(right_shoulder, right_elbow, right_wrist)
        left_angle = self.calculate_angle(left_shoulder,left_elbow,left_wrist)
        
        elbows_and_neck = self.calculate_angle(left_elbow, neck, right_elbow)

        shoulder_elbow_right = self.calculate_angle(right_shoulder, right_elbow, left_shoulder)
        shoulder_elbow_left = self.calculate_angle(left_shoulder, left_elbow, right_shoulder)

        right_shoulder_down = right_shoulder - np.array([0, -0.15])
        left_shoulder_down = left_shoulder - np.array([0,-0.15])
        shoulder_elbow_right_2 = self.calculate_angle(right_shoulder_down, right_shoulder, right_elbow)
        shoulder_elbow_left_2 = self.calculate_angle(left_shoulder_down, left_shoulder, left_elbow)

        wrists_and_neck = self.calculate_angle(left_wrist, neck, right_wrist)
        right_elbow_wrist_dist = right_elbow[1] - right_wrist[1]
        left_elbow_wrist_dist = left_elbow[1] - left_wrist[1]

        left_thumb = self.convert_to_xy(results.pose_landmarks.landmark[20])
        right_thumb = self.convert_to_xy(results.pose_landmarks.landmark[19])
        thumbs_and_neck = self.calculate_angle(left_thumb, neck, right_thumb) 
        return {"right_angle":[right_angle],
                "left_angle":[left_angle],
                "elbows_and_neck":[elbows_and_neck],
                "shoulder_elbow_right" : [shoulder_elbow_right],
                "shoulder_elbow_left" : [shoulder_elbow_left],
                "shoulder_elbow_right_2" : [shoulder_elbow_right_2],
                "shoulder_elbow_left_2" : [shoulder_elbow_left_2],
                "wrists_and_neck": [wrists_and_neck],
                "right_elbow_wrist_dist":[right_elbow_wrist_dist],
                "left_elbow_wrist_dist":[left_elbow_wrist_dist],
                "thumbs_and_neck" : [thumbs_and_neck]
                }

    def get_num(self,point_dict, name, axis):
        return float(point_dict.get(f'{name}')[axis])

    def cross_point(self,line1, line2):  
        x1, y1, x2, y2 = line1
        x3, y3, x4, y4 = line2

        k1 = (y2 - y1) / (x2 - x1) 
        b1 = y1 - x1 * k1  
        if (x4 - x3) == 0: 
            k2 = None
            b2 = 0
        else:
            k2 = (y4 - y3) / (x4 - x3)
            b2 = y3 - x3 * k2
        if k2 is None:
            x = x3
        else:
            x = (b2 - b1) / (k1 - k2)
        y = k1 * x + b1
        return [x, y]

    def point_line(self,point, line):
        x1, y1, x2, y2 = line
        x3, y3 = point

        k1 = (y2 - y1) / (x2 - x1)
        b1 = y1 - x1 * k1
        k2 = -1.0 / k1
        b2 = y3 - x3 * k2
        x = (b2 - b1) / (k1 - k2)
        y = k1 * x + b1
        return [x, y]

    def point_point(self,point_1, point_2):
        x1, y1 = point_1
        x2, y2 = point_2
        return ((x1 - x2) ** 2 + (y1 - y2) ** 2) ** 0.5

    def calculate_metrics(self,values):
        values_np = np.array(values)
        mean_val = np.mean(values_np)
        std_dev = np.std(values_np)
        variance = np.var(values_np)
        max_val = np.max(values_np)
        min_val = np.min(values_np)
        range_val = max_val - min_val
        return mean_val, std_dev, variance, max_val, min_val, range_val

    def head_pose_logic(self):
        yaw_metrics = self.calculate_metrics(self.yaw_values)
        pitch_metrics = self.calculate_metrics(self.pitch_values)
        roll_metrics = self.calculate_metrics(self.roll_values)
        _, yaw_std, _, _, _, _ = yaw_metrics
        _, pitch_std, _, _, _, _ = pitch_metrics
        _, roll_std, _, _, _, _ = roll_metrics
        
        yaw_score = max(1, 5 - int(yaw_std // 5))  
        pitch_score = max(1, 5 - int(pitch_std // 5))
        roll_score = max(1, 5 - int(roll_std // 5))
        
        self.head_gaze_score = (yaw_score + pitch_score + roll_score) // 3

    def process_face_landmarks(self, frame, prev_time, width, height):
        model_test = AntiSpoofPredict(self.device_id)
        image_bbox = model_test.get_bbox(frame)
        x1, y1, w, h = image_bbox[0], image_bbox[1], image_bbox[2], image_bbox[3]
        x2, y2 = x1 + w, y1 + h

        size = int(max(w, h))
        cx, cy = x1 + w / 2, y1 + h / 2
        x1, x2 = max(0, cx - size / 2), min(width, cx + size / 2)
        y1, y2 = max(0, cy - size / 2), min(height, cy + size / 2)

        cropped = frame[int(y1):int(y2), int(x1):int(x2)]
        cropped = cv2.resize(cropped, (112, 112))

        input = cv2.cvtColor(cropped, cv2.COLOR_BGR2RGB)
        input = self.transform(input).unsqueeze(0).to(self.device)
        _, landmarks = self.plfd_backbone(input)
        pre_landmark = landmarks[0].cpu().detach().numpy().reshape(-1, 2) * [112, 112]

        point_dict = {str(i): [x, y] for i, (x, y) in enumerate(pre_landmark.astype(np.float32))}

        point1, point31, point51 = point_dict['1'], point_dict['31'], point_dict['51']
        crossover51 = self.point_line(point51, [point1[0], point1[1], point31[0], point31[1]])
        yaw_mean = self.point_point(point1, point31) / 2
        yaw_right = self.point_point(point1, crossover51)
        yaw = int((yaw_mean - yaw_right) / yaw_mean * 71.58 + 0.7037)
        self.yaw_values.append(yaw)

        pitch_dis = self.point_point(point51, crossover51)
        pitch_dis = -pitch_dis if point51[1] < crossover51[1] else pitch_dis
        pitch = int(1.497 * pitch_dis + 18.97)
        self.pitch_values.append(pitch)

        roll_tan = abs(self.get_num(point_dict, 60, 1) - self.get_num(point_dict, 72, 1)) / abs(
            self.get_num(point_dict, 60, 0) - self.get_num(point_dict, 72, 0))
        roll = math.degrees(math.atan(roll_tan))
        roll = -roll if self.get_num(point_dict, 60, 1) > self.get_num(point_dict, 72, 1) else roll
        self.roll_values.append(int(roll))

        curr_time = time.time()
        frame_duration = curr_time - prev_time
        self.total_duration += frame_duration

        return curr_time

    def process_eye_gaze(self, image, results_from_face_mesh):
        image, gaze_direction, vertical_gaze = gaze.gaze(image, results_from_face_mesh.multi_face_landmarks[0])
        self.gaze_directions.append(gaze_direction)
        self.vertical_gazes.append(vertical_gaze)
        
        return image
    
    def eye_pose_logic(self):
        gaze_counter = Counter(self.gaze_directions)
        vertical_gaze_counter = Counter(self.vertical_gazes)
        total_gaze_frames = len(self.gaze_directions)

        straight_ratio = gaze_counter["Straight"] / total_gaze_frames if total_gaze_frames else 0
        right_ratio = gaze_counter["Right"] / total_gaze_frames if total_gaze_frames else 0
        left_ratio = gaze_counter["Left"] / total_gaze_frames if total_gaze_frames else 0
        up_ratio = vertical_gaze_counter["Up"] / total_gaze_frames if total_gaze_frames else 0
        down_ratio = vertical_gaze_counter["Down"] / total_gaze_frames if total_gaze_frames else 0

        self.gaze_ratio = (straight_ratio + right_ratio + left_ratio) * 100
        self.up_down_ratio = (up_ratio + down_ratio) * 100


        if self.up_down_ratio < 15:
            self.eye_gaze_score = 5
        elif self.up_down_ratio < 30:
            self.eye_gaze_score = 4
        elif self.up_down_ratio < 60:
            self.eye_gaze_score = 3
        elif self.up_down_ratio < 80:
            self.eye_gaze_score = 2
        else:
            self.eye_gaze_score = 1

    def get_gesture_use_rating(self, value):
        if 0 <= value < 20:
            return -5
        elif 20 <= value < 40:
            return -4
        elif 40 <= value < 55:
            return -3
        elif 55 <= value < 70:
            return -2
        elif 70 <= value < 76:
            return -1
        elif 76 <= value < 85:
            return 0
        elif 85 <= value < 88:
            return 1
        elif 88 <= value < 90:
            return 2
        elif 90 <= value < 93:
            return 3
        elif 93 <= value < 95:
            return 4
        elif 95 <= value <= 100:
            return 5
        else:
            return None  

# print(script_dir)
# video_path = f'{script_dir}/4.mp4'
# frames_to_skip = 10
# videval = VideoEvaluation(video_path=video_path, frames_to_skip=frames_to_skip)
# print(videval.run())