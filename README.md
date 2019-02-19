# Lifting 2D object detections to 3D


We present two new methods based on Interval Analysis and Computational Geometry for estimating the 3D occupancy and position of objects from image sequences. Given a calibrated set of images, the proposed frameworks first detect objects using off-the-shelf object detectors and then match bounding boxes in multiple views. The 2D semantic information given by the bounding boxes are used to efficiently recover 3D object position and occupancy using solely geometrical constraints in multiple views.

To execute the code, run main.m contained into the main folder. <br> <br>

This code is related to the paper "Lifting 2D object detections to 3D: A geometric approach in multiple views". <br>
If you use this project for your research, please cite:

@article{rubino2017lifting, <br>
  title={Lifting 2D object detections to 3D: A geometric approach in multiple views}, <br>
  author={Rubino, Cosimo and Fusiello, Andrea and Del Bue, Alessio}, <br>
  booktitle={International Conference on Image Analysis and Processing}, <br>
  pages={561--572}, <br>
  year={2017}, <br>
  organization={Springer} <br>
}


## Installation

The MATLAB code does not provide all the dependencies requested. In the following links you can find the dependencies:

vectarrow.m   <br>
https://github.com/daviddoria/Examples/blob/master/Matlab/ransac%20line/vectarrow.m

INTLAB <br>
http://www.ti3.tu-harburg.de/rump/intlab/

parse_json.m <br>
https://ww2.mathworks.cn/matlabcentral/mlc-downloads/downloads/submissions/23988/versions/5/previews/parse_json.m

Dataset SCANNET <br>
http://www.scan-net.org/

read_ply.m <br>
https://github.com/gpeyre/matlab-toolboxes/blob/master/toolbox_graph/read_ply.m

tvt_setup_equations.m , tvt_solve_qr.m <br>
https://github.com/royshil/morethantechnical/tree/master/opencv_ar/optimal_tvt

loadpcd.m <br>
https://au.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/40382/versions/6/previews/loadpcd.m/index.html

MinVolEllipse.m <br>
https://kr.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/9542/versions/3/previews/MinVolEllipse.m

