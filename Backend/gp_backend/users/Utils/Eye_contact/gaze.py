import cv2
import numpy as np



relative = lambda landmark, shape: (int(landmark.x * shape[1]), int(landmark.y * shape[0]))
relativeT = lambda landmark, shape: (int(landmark.x * shape[1]), int(landmark.y * shape[0]), 0)

def calculate_ear(eye_points, frame_shape):
    A = np.linalg.norm(relative(eye_points[1], frame_shape) - relative(eye_points[5], frame_shape))
    B = np.linalg.norm(relative(eye_points[2], frame_shape) - relative(eye_points[4], frame_shape))
    C = np.linalg.norm(relative(eye_points[0], frame_shape) - relative(eye_points[3], frame_shape))
    ear = (A + B) / (2.0 * C)
    return ear

def gaze(frame, points):
    image_points = np.array([
        relative(points.landmark[4], frame.shape),    # Nose tip
        relative(points.landmark[152], frame.shape),  # Chin
        relative(points.landmark[263], frame.shape),  # Left eye left corner
        relative(points.landmark[33], frame.shape),   # Right eye right corner
        relative(points.landmark[287], frame.shape),  # Left Mouth corner
        relative(points.landmark[57], frame.shape)    # Right Mouth corner
    ], dtype="double")

    image_points1 = np.array([
        relativeT(points.landmark[4], frame.shape), 
        relativeT(points.landmark[152], frame.shape),  
        relativeT(points.landmark[263], frame.shape), 
        relativeT(points.landmark[33], frame.shape), 
        relativeT(points.landmark[287], frame.shape), 
        relativeT(points.landmark[57], frame.shape)  
    ], dtype="double")

    model_points = np.array([
        (0.0, 0.0, 0.0),  # Nose tip
        (0, -63.6, -12.5),  # Chin
        (-43.3, 32.7, -26),  # Left eye left corner
        (43.3, 32.7, -26),  # Right eye right corner
        (-28.9, -28.9, -24.1),  # Left Mouth corner
        (28.9, -28.9, -24.1)  # Right Mouth corner
    ])

    Eye_ball_center_right = np.array([[-29.05], [32.7], [-39.5]])
    Eye_ball_center_left = np.array([[29.05], [32.7], [-39.5]])  

    focal_length = frame.shape[1]
    center = (frame.shape[1] / 2, frame.shape[0] / 2)
    camera_matrix = np.array(
        [[focal_length, 0, center[0]],
         [0, focal_length, center[1]],
         [0, 0, 1]], dtype="double"
    )

    dist_coeffs = np.zeros((4, 1))  
    (success, rotation_vector, translation_vector) = cv2.solvePnP(model_points, image_points, camera_matrix,
                                                                  dist_coeffs, flags=cv2.SOLVEPNP_ITERATIVE)

    left_pupil = relative(points.landmark[468], frame.shape)
    right_pupil = relative(points.landmark[473], frame.shape)

    left_eye_top = relative(points.landmark[159], frame.shape)
    left_eye_bottom = relative(points.landmark[145], frame.shape)
    left_eye_center = ((left_eye_top[0] + left_eye_bottom[0]) / 2, (left_eye_top[1] + left_eye_bottom[1]) / 2)

    right_eye_top = relative(points.landmark[386], frame.shape)
    right_eye_bottom = relative(points.landmark[374], frame.shape)
    right_eye_center = ((right_eye_top[0] + right_eye_bottom[0]) / 2, (right_eye_top[1] + right_eye_bottom[1]) / 2)

    _, transformation, _ = cv2.estimateAffine3D(image_points1, model_points) 

    gaze_direction = "Unknown"  
    vertical_gaze = "Unknown"

    if transformation is not None:  
        pupil_world_cord = transformation @ np.array([[left_pupil[0], left_pupil[1], 0, 1]]).T
        S = Eye_ball_center_left + (pupil_world_cord - Eye_ball_center_left) * 10
        (eye_pupil2D, _) = cv2.projectPoints(S.T, rotation_vector,
                                             translation_vector, camera_matrix, dist_coeffs)
        (head_pose, _) = cv2.projectPoints(pupil_world_cord.T, rotation_vector,
                                           translation_vector, camera_matrix, dist_coeffs)
        gaze = left_pupil + (eye_pupil2D[0][0] - left_pupil) - (head_pose[0][0] - left_pupil)

        p1 = (int(left_pupil[0]), int(left_pupil[1]))
        p2 = (int(gaze[0]), int(gaze[1]))
        cv2.line(frame, p1, p2, (0, 0, 255), 2)


        left_eye_height = left_eye_bottom[1] - left_eye_top[1] if left_eye_bottom[1] != left_eye_top[1] else 1
        right_eye_height = right_eye_bottom[1] - right_eye_top[1] if right_eye_bottom[1] != right_eye_top[1] else 1

        left_pupil_ratio = (left_pupil[1] - left_eye_top[1]) / left_eye_height
        right_pupil_ratio = (right_pupil[1] - right_eye_top[1]) / right_eye_height


        frame_center_x = frame.shape[1] / 2
        if p2[0] < frame_center_x - 50:
            gaze_direction = "Right"
        elif p2[0] > frame_center_x + 50:
            gaze_direction = "Left"
        else:
            gaze_direction = "Straight"

        if left_pupil_ratio < 0.3 and right_pupil_ratio < 0.3:
            vertical_gaze = "Down"
        elif left_pupil_ratio > 0.4 and right_pupil_ratio > 0.4:
            vertical_gaze = "Up"
        else:
            vertical_gaze = "Straight"
        
    
        # if vertical_gaze!="Straight":
        # print('left:',left_pupil_ratio)
        # print('right:',right_pupil_ratio)

        cv2.putText(frame, f"Gaze: {gaze_direction}, {vertical_gaze}", (20, 20), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)

    return frame, gaze_direction, vertical_gaze
