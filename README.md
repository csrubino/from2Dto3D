# Lifting 2D object detections to 3D

We present two new methods based on Interval Analysis and
Computational Geometry for estimating the 3D occupancy and position
of objects from image sequences. Given a calibrated set of images, the
proposed frameworks rst detect objects using o-the-shelf object detectors
and then match bounding boxes in multiple views. The 2D semantic
information given by the bounding boxes are used to eciently recover
3D object position and occupancy using solely geometrical constraints in
multiple views.

## Installation

The MATLAB code does not provide all the dependencies requested.
In the following links you can find some of the dependencies:

vectarrow.m  
https://github.com/daviddoria/Examples/blob/master/Matlab/ransac%20line/vectarrow.m

INTLAB
http://www.ti3.tu-harburg.de/rump/intlab/

parse_json.m
https://ww2.mathworks.cn/matlabcentral/mlc-downloads/downloads/submissions/23988/versions/5/previews/parse_json.m

Dataset SCANNET
http://www.scan-net.org/

read_ply.m
https://github.com/gpeyre/matlab-toolboxes/blob/master/toolbox_graph/read_ply.m

tvt_setup_equations.m , tvt_solve_qr.m
https://github.com/royshil/morethantechnical/tree/master/opencv_ar/optimal_tvt

loadpcd.m
https://au.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/40382/versions/6/previews/loadpcd.m/index.html

MinVolEllipse.m
https://kr.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/9542/versions/3/previews/MinVolEllipse.m







```
